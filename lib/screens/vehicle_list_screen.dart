import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../data/database.dart';
import '../services/settings_service.dart';
import '../utils/tire.dart';
import 'vehicle_form_screen.dart';

class VehicleListScreen extends StatefulWidget {
  final DatabaseService database;
  final SettingsService settingsService;

  const VehicleListScreen({
    super.key,
    required this.database,
    required this.settingsService,
  });

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  List<Vehicle> _vehicles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final vehicles = await widget.database.getAllVehicles();
      setState(() {
        _vehicles = vehicles;
      });
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading vehicles: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Describes the odometer correction derived from the running tire size,
  /// shown only when the user entered one.
  String? _tireCorrectionText(Vehicle vehicle) {
    final running = vehicle.tireSizeRunning;
    if (running == null || running.isEmpty) return null;

    final stock = vehicle.tireSizeStock;
    final sizes = (stock != null && stock.isNotEmpty) ? '$stock → $running' : running;
    final offset = tireSizeOffset(stock, running);
    if (offset == null) return 'Tires: $sizes (unrecognized size)';
    if (offset.abs() < 0.0005) return 'Tires: $sizes (no correction)';
    final sign = offset > 0 ? '+' : '';
    return 'Tires: $sizes (${sign}${(offset * 100).toStringAsFixed(1)}% correction)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VehicleFormScreen(
                    database: widget.database,
                    settingsService: widget.settingsService,
                    onVehicleSaved: _loadVehicles,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _vehicles.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.car_repair, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No vehicles found'),
                      Text('Add your first vehicle to get started'),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = _vehicles[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(vehicle.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${vehicle.make ?? ''} ${vehicle.model ?? ''} ${vehicle.year ?? ''}'),
                            Text('${vehicle.fuelType} • ${vehicle.licensePlate ?? 'No plate'}'),
                            if (_tireCorrectionText(vehicle) != null)
                              Text(_tireCorrectionText(vehicle)!,
                                  style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VehicleFormScreen(
                                database: widget.database,
                                settingsService: widget.settingsService,
                                onVehicleSaved: _loadVehicles,
                                vehicle: vehicle,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
