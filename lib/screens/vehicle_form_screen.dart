import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/vehicle.dart';
import '../data/database.dart';
import '../services/settings_service.dart';

class VehicleFormScreen extends StatefulWidget {
  final DatabaseService database;
  final SettingsService settingsService;
  final Function() onVehicleSaved;
  final Vehicle? vehicle;

  const VehicleFormScreen({
    super.key,
    required this.database,
    required this.settingsService,
    required this.onVehicleSaved,
    this.vehicle,
  });

  @override
  State<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends State<VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _vinController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _tireSizeStockController = TextEditingController();
  final _tireSizeRunningController = TextEditingController();

  String _fuelType = 'liquid';
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.vehicle != null) {
      _isEditing = true;
      final vehicle = widget.vehicle!;
      _nameController.text = vehicle.name;
      _makeController.text = vehicle.make ?? '';
      _modelController.text = vehicle.model ?? '';
      _yearController.text = vehicle.year?.toString() ?? '';
      _vinController.text = vehicle.vin ?? '';
      _licensePlateController.text = vehicle.licensePlate ?? '';
      _tireSizeStockController.text = vehicle.tireSizeStock ?? '';
      _tireSizeRunningController.text = vehicle.tireSizeRunning ?? '';
      _fuelType = vehicle.fuelType;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _vinController.dispose();
    _licensePlateController.dispose();
    _tireSizeStockController.dispose();
    _tireSizeRunningController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Vehicle' : 'Add Vehicle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vehicle Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Name *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a vehicle name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              const Text('Fuel Type'),
              const SizedBox(height: 10),
              _buildFuelTypeSelector(),
              const SizedBox(height: 20),

              const Text(
                'Vehicle Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _makeController,
                decoration: const InputDecoration(
                  labelText: 'Make',
                ),
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(
                  labelText: 'Model',
                ),
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(
                  labelText: 'Year',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _vinController,
                decoration: const InputDecoration(
                  labelText: 'VIN',
                ),
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _licensePlateController,
                decoration: const InputDecoration(
                  labelText: 'License Plate',
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Tire Sizes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _tireSizeStockController,
                decoration: const InputDecoration(
                  labelText: 'Stock Tire Size',
                  hintText: 'e.g. 205/55R16 or 26 inches',
                ),
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _tireSizeRunningController,
                decoration: const InputDecoration(
                  labelText: 'Running Tire Size',
                  hintText: 'e.g. 205/55R16 or 26 inches',
                ),
              ),
              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(_isEditing ? 'Update Vehicle' : 'Add Vehicle'),
                ),
              ),
              if (_isEditing) ...[
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: _confirmDeleteVehicle,
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Delete Vehicle'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFuelTypeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFuelTypeButton('liquid', 'Fuel'),
        _buildFuelTypeButton('electric', 'Electric'),
        _buildFuelTypeButton('both', 'Both'),
      ],
    );
  }

  Widget _buildFuelTypeButton(String type, String label) {
    bool isSelected = _fuelType == type;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _fuelType = type;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey,
        foregroundColor: Colors.white,
      ),
      child: Text(label),
    );
  }

  Future<void> _confirmDeleteVehicle() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Vehicle'),
        content: Text(
          'Delete ${widget.vehicle!.name}? This will permanently delete the vehicle and all of its fuel entries.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await widget.database.deleteFillEntriesByVehicle(widget.vehicle!.id);
      await widget.database.deleteVehicle(widget.vehicle!.id);
      if (mounted) {
        Navigator.of(context).pop();
        widget.onVehicleSaved();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehicle deleted')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting vehicle: $error')),
        );
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create or update the vehicle
      final vehicle = Vehicle(
        id: _isEditing ? widget.vehicle!.id : const Uuid().v4(),
        name: _nameController.text,
        fuelType: _fuelType,
        make: _makeController.text.isNotEmpty ? _makeController.text : null,
        model: _modelController.text.isNotEmpty ? _modelController.text : null,
        year: _yearController.text.isNotEmpty ? int.parse(_yearController.text) : null,
        vin: _vinController.text.isNotEmpty ? _vinController.text : null,
        licensePlate: _licensePlateController.text.isNotEmpty ? _licensePlateController.text : null,
        tireSizeStock: _tireSizeStockController.text.isNotEmpty ? _tireSizeStockController.text.trim() : null,
        tireSizeRunning: _tireSizeRunningController.text.isNotEmpty ? _tireSizeRunningController.text.trim() : null,
        createdAt: _isEditing ? widget.vehicle!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to database
      if (_isEditing) {
        widget.database.updateVehicle(vehicle).then((_) {
          if (mounted) {
            Navigator.of(context).pop();
            widget.onVehicleSaved();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vehicle updated successfully')),
            );
          }
        }).catchError((error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error updating vehicle: $error')),
            );
          }
        });
      } else {
        widget.database.insertVehicle(vehicle).then((_) {
          if (mounted) {
            Navigator.of(context).pop();
            widget.onVehicleSaved();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vehicle added successfully')),
            );
          }
        }).catchError((error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error adding vehicle: $error')),
            );
          }
        });
      }
    }
  }
}
