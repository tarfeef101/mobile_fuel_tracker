import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/fill_entry.dart';
import '../models/vehicle.dart';
import '../services/settings_service.dart';
import '../data/database.dart';
import '../data/dynamodb_service.dart';
import '../services/sync_service.dart';

class AddEntryScreen extends StatefulWidget {
  final SettingsService settingsService;
  final DatabaseService database;
  final DynamoDBService dynamoDBService;
  final SyncService syncService;
  final Function() onEntryAdded;
  final FillEntry? entryToEdit;

  const AddEntryScreen({
    super.key,
    required this.settingsService,
    required this.database,
    required this.dynamoDBService,
    required this.syncService,
    required this.onEntryAdded,
    this.entryToEdit,
  });

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fuelTypeController = TextEditingController();
  final _odometerController = TextEditingController();
  final _fuelAmountController = TextEditingController();
  final _batteryBeforeController = TextEditingController();
  final _batteryAfterController = TextEditingController();
  final _energyAddedController = TextEditingController();
  final _totalCostController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedFuelType = 'liquid';
  String _currency = 'USD';
  String _distanceUnit = 'km';
  String _capacityUnit = 'L';
  String _selectedVehicleId = ''; // Add vehicle selection

  List<Vehicle> _vehicles = [];
  bool _isLoadingVehicles = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _init();
  }

  Future<void> _init() async {
    // Pre-fill must run after the vehicle list is loaded so the selected
    // vehicle isn't overwritten by the default.
    await _loadVehicles();
    _loadEntryForEdit();
  }

  void _loadEntryForEdit() {
    final entry = widget.entryToEdit;
    if (entry == null) return;
    setState(() {
      _selectedFuelType = entry.fuelType;
      _currency = entry.currency;
      _distanceUnit = entry.distanceUnit ?? _distanceUnit;
      _capacityUnit = entry.capacityUnit ?? _capacityUnit;
      _selectedVehicleId = entry.vehicleId;
      _odometerController.text = entry.odometer?.toString() ?? '';
      _fuelAmountController.text = entry.fuelAmount?.toString() ?? '';
      _batteryBeforeController.text = entry.batteryLevelBefore?.toString() ?? '';
      _batteryAfterController.text = entry.batteryLevelAfter?.toString() ?? '';
      _energyAddedController.text = entry.energyAdded?.toString() ?? '';
      _totalCostController.text = entry.totalCost.toString();
      _notesController.text = entry.notes ?? '';
    });
  }

  Future<void> _loadSettings() async {
    setState(() {
      _currency = widget.settingsService.getCurrency();
      _distanceUnit = widget.settingsService.getDistanceUnit();
      _capacityUnit = widget.settingsService.getCapacityUnit();
    });
  }

  Future<void> _loadVehicles() async {
    setState(() {
      _isLoadingVehicles = true;
    });

    try {
      final vehicles = await widget.database.getAllVehicles();
      setState(() {
        _vehicles = vehicles;
        // Default to first vehicle or set to empty if no vehicles
        if (vehicles.isNotEmpty) {
          _selectedVehicleId = vehicles.first.id;
        } else {
          _selectedVehicleId = '';
        }
      });
    } catch (e) {
      // Handle error
      setState(() {
        _vehicles = [];
        _selectedVehicleId = '';
      });
    } finally {
      setState(() {
        _isLoadingVehicles = false;
      });
    }
  }

  @override
  void dispose() {
    _fuelTypeController.dispose();
    _odometerController.dispose();
    _fuelAmountController.dispose();
    _batteryBeforeController.dispose();
    _batteryAfterController.dispose();
    _energyAddedController.dispose();
    _totalCostController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entryToEdit == null ? 'Add New Entry' : 'Edit Entry'),
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
                'Vehicle',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildVehicleSelector(),
              const SizedBox(height: 20),

              const Text(
                'Fuel Type',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildFuelTypeSelector(),
              const SizedBox(height: 20),

              const Text(
                'Fill Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildFillDetailsForm(),
              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Save Entry'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleSelector() {
    if (_isLoadingVehicles) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_vehicles.isEmpty) {
      return const Text(
        'No vehicles found. Please add a vehicle in settings.',
        style: TextStyle(color: Colors.grey),
      );
    }

    return DropdownButtonFormField<String>(
      value: _selectedVehicleId,
      decoration: const InputDecoration(
        labelText: 'Select Vehicle',
        border: OutlineInputBorder(),
      ),
      items: _vehicles.map((vehicle) {
        return DropdownMenuItem<String>(
          value: vehicle.id,
          child: Text(vehicle.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedVehicleId = value!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a vehicle';
        }
        return null;
      },
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
    bool isSelected = _selectedFuelType == type;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedFuelType = type;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey,
        foregroundColor: Colors.white,
      ),
      child: Text(label),
    );
  }

  Widget _buildFillDetailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _totalCostController,
          decoration: InputDecoration(
            labelText: 'Total Cost',
            prefixText: '$_currency ',
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter total cost';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),

        // Odometer input for liquid fuel
        if (_selectedFuelType == 'liquid') ...[
          TextFormField(
            controller: _odometerController,
            decoration: InputDecoration(
              labelText: 'Odometer',
              suffixText: ' $_distanceUnit',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _fuelAmountController,
            decoration: InputDecoration(
              labelText: 'Fuel Amount',
              suffixText: ' $_capacityUnit',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
        ],

        // Battery levels for electric fuel
        if (_selectedFuelType == 'electric' || _selectedFuelType == 'both') ...[
          TextFormField(
            controller: _batteryBeforeController,
            decoration: const InputDecoration(
              labelText: 'Battery Level Before',
              suffixText: '%',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _batteryAfterController,
            decoration: const InputDecoration(
              labelText: 'Battery Level After',
              suffixText: '%',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _energyAddedController,
            decoration: const InputDecoration(
              labelText: 'Energy Added',
              suffixText: ' kWh',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
        ],

        TextFormField(
          controller: _notesController,
          decoration: const InputDecoration(
            labelText: 'Notes',
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedVehicleId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a vehicle')),
      );
      return;
    }

    final existing = widget.entryToEdit;
    final entry = FillEntry(
      id: existing?.id ?? const Uuid().v4(),
      timestamp: existing?.timestamp ?? DateTime.now(),
      fuelType: _selectedFuelType,
      odometer: _odometerController.text.isNotEmpty ? double.parse(_odometerController.text) : null,
      fuelAmount: _fuelAmountController.text.isNotEmpty ? double.parse(_fuelAmountController.text) : null,
      batteryLevelBefore: _batteryBeforeController.text.isNotEmpty ? double.parse(_batteryBeforeController.text) : null,
      batteryLevelAfter: _batteryAfterController.text.isNotEmpty ? double.parse(_batteryAfterController.text) : null,
      energyAdded: _energyAddedController.text.isNotEmpty ? double.parse(_energyAddedController.text) : null,
      totalCost: double.parse(_totalCostController.text),
      currency: _currency,
      distanceUnit: _distanceUnit,
      capacityUnit: _capacityUnit,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      // Cleared so the edited entry is pushed to the cloud again.
      syncedAt: null,
      deviceId: existing?.deviceId ?? widget.settingsService.getDeviceId(),
      vehicleId: _selectedVehicleId,
    );

    try {
      if (existing != null) {
        await widget.database.updateFillEntry(entry);
      } else {
        await widget.database.insertFillEntry(entry);
      }
      if (widget.settingsService.getEnableCloudSync()) {
        final result = await widget.syncService.syncEntry(entry);
        if (result.failed && mounted) {
          // App-level messenger, so the snackbar survives the pop below.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Saved locally, but cloud sync failed: ${result.error}'),
              duration: const Duration(seconds: 8),
            ),
          );
        }
      }
      if (mounted) {
        Navigator.of(context).pop();
        widget.onEntryAdded();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving entry: $error')),
        );
      }
    }
  }
}
