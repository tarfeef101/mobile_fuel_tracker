import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/fill_entry.dart';
import '../models/vehicle.dart';
import '../services/exchange_rate_service.dart';
import '../services/settings_service.dart';
import '../data/database.dart';
import '../data/dynamodb_service.dart';
import '../services/sync_service.dart';
import '../utils/unit_conversion.dart';
import '../widgets/option_sheet.dart';

class AddEntryScreen extends StatefulWidget {
  final SettingsService settingsService;
  final DatabaseService database;
  final DynamoDBService dynamoDBService;
  final ExchangeRateService exchangeRateService;
  final SyncService syncService;
  final Function() onEntryAdded;
  final FillEntry? entryToEdit;

  const AddEntryScreen({
    super.key,
    required this.settingsService,
    required this.database,
    required this.dynamoDBService,
    required this.exchangeRateService,
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

  // Edit mode: whether the form shows the stored (original) value/unit pair
  // rather than values converted to the current defaults.
  bool _showOriginalUnits = false;
  bool _unitsDiffer = false;
  Map<String, Map<String, double>> _rates = {};

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
    await _loadEntryForEdit();
  }

  Future<void> _loadEntryForEdit() async {
    final entry = widget.entryToEdit;
    if (entry == null) return;

    setState(() {
      _selectedFuelType = entry.fuelType;
      _selectedVehicleId = entry.vehicleId;
      _batteryBeforeController.text = entry.batteryLevelBefore?.toString() ?? '';
      _batteryAfterController.text = entry.batteryLevelAfter?.toString() ?? '';
      _energyAddedController.text = entry.energyAdded?.toString() ?? '';
      _notesController.text = entry.notes ?? '';
    });

    final unitsDiffer = entry.currency != widget.settingsService.getCurrency() ||
        (entry.distanceUnit ?? 'km') != widget.settingsService.getDistanceUnit() ||
        (entry.capacityUnit ?? 'L') != widget.settingsService.getCapacityUnit();
    if (!unitsDiffer) {
      _applyOriginalUnits(entry);
      return;
    }
    _unitsDiffer = true;

    // Open showing the defaults with values converted, matching history.
    // Without a rate the cost can't be converted, so keep the originals.
    final rates = entry.currency == widget.settingsService.getCurrency()
        ? null
        : await _ratesFor(entry.currency);
    if (!mounted) return;
    final costRate = rates?[widget.settingsService.getCurrency().toUpperCase()];
    if (entry.currency != widget.settingsService.getCurrency() && costRate == null) {
      _applyOriginalUnits(entry);
      setState(() => _showOriginalUnits = true);
      return;
    }
    _applyConvertedUnits(entry, costRate);
  }

  void _applyOriginalUnits(FillEntry entry) {
    setState(() {
      _currency = entry.currency;
      _distanceUnit = entry.distanceUnit ?? 'km';
      _capacityUnit = entry.capacityUnit ?? 'L';
      _odometerController.text = entry.odometer?.toString() ?? '';
      _fuelAmountController.text = entry.fuelAmount?.toString() ?? '';
      _totalCostController.text = entry.totalCost.toString();
    });
  }

  void _applyConvertedUnits(FillEntry entry, double? costRate) {
    final defaultCurrency = widget.settingsService.getCurrency();
    final defaultDistanceUnit = widget.settingsService.getDistanceUnit();
    final defaultCapacityUnit = widget.settingsService.getCapacityUnit();
    setState(() {
      _currency = defaultCurrency;
      _distanceUnit = defaultDistanceUnit;
      _capacityUnit = defaultCapacityUnit;
      _odometerController.text = entry.odometer != null
          ? _fmt(convertDistance(entry.odometer!, entry.distanceUnit, defaultDistanceUnit), 1)
          : '';
      _fuelAmountController.text = entry.fuelAmount != null
          ? _fmt(convertCapacity(entry.fuelAmount!, entry.capacityUnit, defaultCapacityUnit), 2)
          : '';
      _totalCostController.text =
          costRate == null ? entry.totalCost.toString() : _fmt(entry.totalCost * costRate, 2);
      _showOriginalUnits = false;
    });
  }

  Future<void> _toggleOriginalUnits(bool showOriginal) async {
    final entry = widget.entryToEdit!;
    if (showOriginal) {
      _applyOriginalUnits(entry);
      setState(() => _showOriginalUnits = true);
      return;
    }
    final defaultCurrency = widget.settingsService.getCurrency();
    double? costRate;
    if (entry.currency != defaultCurrency) {
      costRate = (await _ratesFor(entry.currency))?[defaultCurrency.toUpperCase()];
      if (!mounted) return;
      if (costRate == null) {
        _showSnackBar('Exchange rate unavailable');
        return;
      }
    }
    _applyConvertedUnits(entry, costRate);
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

  Future<void> _pickCurrency() async {
    final options = await widget.exchangeRateService.currencyCodes();
    if (!mounted) return;
    await showOptionSheet(
      context,
      title: 'Currency',
      options: options,
      selected: _currency,
      onSelected: _changeCurrency,
    );
  }

  Future<void> _changeCurrency(String unit) async {
    if (unit == _currency) return;
    final value = double.tryParse(_totalCostController.text);
    double? converted;
    if (value != null) {
      final rate = (await _ratesFor(_currency))?[unit.toUpperCase()];
      if (!mounted) return;
      if (rate == null) {
        _showSnackBar('Exchange rate unavailable');
        return;
      }
      converted = value * rate;
    }
    setState(() {
      _currency = unit;
      if (converted != null) _totalCostController.text = _fmt(converted, 2);
      _clearOriginalModeIfStale();
    });
  }

  void _pickDistanceUnit() {
    showOptionSheet(
      context,
      title: 'Distance Unit',
      options: const ['km', 'miles'],
      selected: _distanceUnit,
      onSelected: _changeDistanceUnit,
    );
  }

  Future<void> _changeDistanceUnit(String unit) async {
    if (unit == _distanceUnit) return;
    final value = double.tryParse(_odometerController.text);
    final converted = value == null ? null : convertDistance(value, _distanceUnit, unit);
    setState(() {
      _distanceUnit = unit;
      if (converted != null) _odometerController.text = _fmt(converted, 1);
      _clearOriginalModeIfStale();
    });
  }

  void _pickCapacityUnit() {
    showOptionSheet(
      context,
      title: 'Capacity Unit',
      options: const ['L', 'gal', 'mL'],
      selected: _capacityUnit,
      onSelected: _changeCapacityUnit,
    );
  }

  Future<void> _changeCapacityUnit(String unit) async {
    if (unit == _capacityUnit) return;
    final value = double.tryParse(_fuelAmountController.text);
    final converted = value == null ? null : convertCapacity(value, _capacityUnit, unit);
    setState(() {
      _capacityUnit = unit;
      if (converted != null) _fuelAmountController.text = _fmt(converted, 2);
      _clearOriginalModeIfStale();
    });
  }

  // Once a unit is picked by hand the displayed pair is no longer the stored
  // original, so the toggle must go back to the converted state.
  void _clearOriginalModeIfStale() {
    if (widget.entryToEdit != null) _showOriginalUnits = false;
  }

  Future<Map<String, double>?> _ratesFor(String base) async {
    final key = base.toUpperCase();
    final cached = _rates[key];
    if (cached != null) return cached;
    final rates = await widget.exchangeRateService.getRates(base);
    if (rates != null) _rates[key] = rates;
    return rates;
  }

  String _fmt(double value, int digits) => value.toStringAsFixed(digits);

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildUnitChip(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            const SizedBox(width: 4),
            const Icon(Icons.expand_more, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildOriginalUnitsToggle() {
    if (widget.entryToEdit == null || !_unitsDiffer) return const SizedBox.shrink();
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Show original units'),
      subtitle: Text(_showOriginalUnits
          ? 'Values as entered at the time of the fill'
          : 'Values converted to your default units'),
      value: _showOriginalUnits,
      onChanged: _toggleOriginalUnits,
    );
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
              _buildOriginalUnitsToggle(),
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
            prefixIcon: _buildUnitChip(_currency, () => _pickCurrency()),
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
              suffixIcon: _buildUnitChip(_distanceUnit, _pickDistanceUnit),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _fuelAmountController,
            decoration: InputDecoration(
              labelText: 'Fuel Amount',
              suffixIcon: _buildUnitChip(_capacityUnit, _pickCapacityUnit),
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
