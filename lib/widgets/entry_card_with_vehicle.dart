import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/fill_entry.dart';
import '../models/vehicle.dart';
import '../data/database.dart';
import '../utils/currency.dart';
import '../utils/economy.dart';
import '../utils/unit_conversion.dart';

class EntryCardWithVehicle extends StatelessWidget {
  final FillEntry entry;
  final Function(String) onDelete;
  final Function(FillEntry) onEdit;
  final DatabaseService database;
  final FillEconomy? economy;
  final String defaultCurrency;
  final String defaultCapacityUnit;
  final String defaultDistanceUnit;
  final Map<String, Map<String, double>> ratesByBase;

  const EntryCardWithVehicle({
    super.key,
    required this.entry,
    required this.onDelete,
    required this.onEdit,
    required this.database,
    required this.defaultCurrency,
    required this.defaultCapacityUnit,
    required this.defaultDistanceUnit,
    required this.ratesByBase,
    this.economy,
  });

  @override
  Widget build(BuildContext context) {
    final isLiquid = entry.fuelType == 'liquid';
    final amount = isLiquid ? entry.fuelAmount : entry.energyAdded;
    final convertedCost = convertCurrencyAmount(entry.totalCost, entry.currency,
        defaultCurrency, ratesByBase: ratesByBase);
    final costIsConverted = convertedCost != null && entry.currency != defaultCurrency;
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${fuelTypeLabel(entry.fuelType)} Fill',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('MMM d, yyyy HH:mm').format(entry.timestamp),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        costIsConverted
                            ? '${convertedCost.toStringAsFixed(currencyFractionDigits(defaultCurrency))} $defaultCurrency'
                            : '${entry.totalCost} ${entry.currency}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (costIsConverted)
                        Text(
                          '≈ ${entry.totalCost} ${entry.currency}',
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
                Text(
                  isLiquid
                      ? _formatAmount(amount, defaultCapacityUnit)
                      : '$amount kWh',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Display vehicle information if available
            FutureBuilder<Vehicle?>(
              future: database.getVehicleById(entry.vehicleId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading vehicle...', style: TextStyle(fontSize: 14, color: Colors.grey));
                } else if (snapshot.hasData && snapshot.data != null) {
                  return Text(
                    'Vehicle: ${snapshot.data!.name}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  );
                } else {
                  final fallback = entry.vehicleId.isEmpty
                      ? 'Unknown'
                      : entry.vehicleId.substring(0, 6);
                  return Text(
                    'Vehicle: $fallback', // Fallback to ID if vehicle not found
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  );
                }
              },
            ),
            if (economy != null) ...[
              const SizedBox(height: 8),
              Text(
                'Trip economy: ${formatConsumption(economy!.consumptionPer100Km, miles: defaultDistanceUnit == 'miles')}'
                ' over ${formatDistance(economy!.distanceKm, miles: defaultDistanceUnit == 'miles')}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
            if (entry.notes != null && entry.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                entry.notes!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => onEdit(entry),
                  tooltip: 'Edit entry',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => onDelete(entry.id),
                  tooltip: 'Delete entry',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Liquid amount in the default capacity unit, converting when the entry
  /// was stored in a different one.
  String _formatAmount(double? amount, String unit) {
    if (amount == null) return '—';
    final converted = convertCapacity(amount, entry.capacityUnit, unit);
    return unit == 'mL'
        ? '${converted.toStringAsFixed(0)} $unit'
        : '${converted.toStringAsFixed(1)} $unit';
  }
}
