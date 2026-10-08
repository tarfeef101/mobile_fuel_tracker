import 'package:flutter/material.dart';
import '../models/fill_entry.dart';
import '../models/vehicle.dart';
import '../data/database.dart';

class EntryCardWithVehicle extends StatelessWidget {
  final FillEntry entry;
  final Function(String) onDelete;
  final DatabaseService database;

  const EntryCardWithVehicle({
    super.key,
    required this.entry,
    required this.onDelete,
    required this.database,
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
                  '${entry.fuelType.capitalizeFirst} Fill',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  entry.timestamp.toString(),
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
                  return Text(
                    'Vehicle: ${entry.vehicleId.substring(0, 6)}...', // Fallback to ID if vehicle not found
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  );
                }
              },
            ),
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
                  icon: const Icon(Icons.delete),
                  onPressed: () => onDelete(entry.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension on String {
  String get capitalizeFirst {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}