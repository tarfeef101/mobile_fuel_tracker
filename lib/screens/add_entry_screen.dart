import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/fill_entry.dart';
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

  const AddEntryScreen({
    super.key,
    required this.settingsService,
    required this.database,
    required this.dynamoDBService,
    required this.syncService,
    required this.onEntryAdded,
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

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _currency = widget.settingsService.getCurrency();
      _distanceUnit = widget.settingsService.getDistanceUnit();
      _capacityUnit = widget.settingsService.getCapacityUnit();
    });
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
        title: const Text('Add New Entry'),
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

  Widget _buildFuelTypeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFuelTypeButton('liquid', 'Liquid'),
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
          decoration: const InputDecoration(
            labelText: 'Total Cost',
            prefixText: 'USD ',
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
            decoration: const InputDecoration(
              labelText: 'Odometer',
              suffixText: ' km',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _fuelAmountController,
            decoration: const InputDecoration(
              labelText: 'Fuel Amount',
              suffixText: ' L',
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create the fill entry
      final entry = FillEntry(
        id: const Uuid().v4(),
        timestamp: DateTime.now(),
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
        syncedAt: null,
        deviceId: widget.settingsService.getDeviceId(),
      );

      // Save to database
      widget.database.insertFillEntry(entry).then((savedEntry) {
        // If cloud sync is enabled, sync this entry immediately
        if (widget.settingsService.getEnableCloudSync()) {
          widget.syncService.syncEntry(savedEntry).then((success) {
            if (mounted) {
              Navigator.of(context).pop();
              widget.onEntryAdded();
            }
          }).catchError((error) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error syncing entry: $error')),
              );
              Navigator.of(context).pop();
              widget.onEntryAdded();
            }
          });
        } else {
          if (mounted) {
            Navigator.of(context).pop();
            widget.onEntryAdded();
          }
        }
      }).catchError((error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving entry: $error')),
          );
        }
      });
    }
  }
}