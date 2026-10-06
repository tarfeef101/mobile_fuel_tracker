import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../data/database.dart';
import '../services/settings_service.dart';

class VehicleListScreen extends StatefulWidget {
  final DatabaseService database;
  final SettingsService settingsService;
  final Function(Vehicle) onVehicleSelected;

  const VehicleListScreen({
    super.key,
    required this.database,
    required this.settingsService,
    required this.onVehicleSelected,
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
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          widget.onVehicleSelected(vehicle);
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                ),
    );
  }
}