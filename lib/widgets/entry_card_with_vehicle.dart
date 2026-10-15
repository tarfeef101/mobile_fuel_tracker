import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/fill_entry.dart';
import '../models/vehicle.dart';
import '../data/database.dart';
import '../utils/economy.dart';

class EntryCardWithVehicle extends StatelessWidget {
  final FillEntry entry;
  final Function(String) onDelete;
  final Function(FillEntry) onEdit;
  final DatabaseService database;
  final FillEconomy? economy;

  const EntryCardWithVehicle({
    super.key,
    required this.entry,
    required this.onDelete,
    required this.onEdit,
    required this.database,
    this.economy,
  });

  @override
  Widget build(BuildContext context) {
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
                Text(
                  '${entry.totalCost} ${entry.currency}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${entry.fuelType == 'liquid' ? entry.fuelAmount : entry.energyAdded} ${entry.fuelType == 'liquid' ? 'L' : 'kWh'}',
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
                'Trip economy: ${formatConsumption(economy!.consumptionPer100Km, miles: entry.distanceUnit == 'miles')}'
                ' over ${formatDistance(economy!.distanceKm, miles: entry.distanceUnit == 'miles')}',
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
}
