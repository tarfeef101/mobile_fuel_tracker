import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class TireSizeScreen extends StatefulWidget {
  final SettingsService settingsService;
  final Function() onBack;
  final Function() onSettingsChanged;

  const TireSizeScreen({
    super.key,
    required this.settingsService,
    required this.onBack,
    required this.onSettingsChanged,
  });

  @override
  State<TireSizeScreen> createState() => _TireSizeScreenState();
}

class _TireSizeScreenState extends State<TireSizeScreen> {
  final _stockTireSizeController = TextEditingController();
  final _runningTireSizeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _stockTireSizeController.text = widget.settingsService.getTireSizeStock();
    _runningTireSizeController.text = widget.settingsService.getTireSizeRunning();
  }

  @override
  void dispose() {
    _stockTireSizeController.dispose();
    _runningTireSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tire Size Offset'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tire Size Offset Configuration',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'This feature calculates the offset between your stock and running tire sizes to adjust your mileage calculations.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'Stock Tire Size',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _stockTireSizeController,
                decoration: const InputDecoration(
                  labelText: 'Enter stock tire size (e.g., 225/65R17 or 26 inches)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter stock tire size';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Running Tire Size',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _runningTireSizeController,
                decoration: const InputDecoration(
                  labelText: 'Enter running tire size (e.g., 245/60R17 or 27 inches)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter running tire size';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _saveTireSizes,
                  child: const Text('Save Tire Sizes'),
                ),
              ),
              const SizedBox(height: 20),
              if (widget.settingsService.getTireSizeStock().isNotEmpty &&
                  widget.settingsService.getTireSizeRunning().isNotEmpty) ...[
                const Text(
                  'Calculated Offset:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _buildTireSizeOffsetInfo(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTireSizeOffsetInfo() {
    final offset = widget.settingsService.getTireSizeOffset();

    if (offset == null) {
      return const Text(
        'Could not calculate offset. Please ensure both tire sizes are correctly entered.',
        style: TextStyle(color: Colors.red),
      );
    }

    final percentage = offset * 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${percentage >= 0 ? '+' : ''}${percentage.toStringAsFixed(2)}%',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tire size offset percentage',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            Text(
              'This offset represents how much your current tire size differs from the stock size. '
              'A positive value means your current tires are larger (will show fewer miles), '
              'a negative value means they are smaller (will show more miles).',
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  void _saveTireSizes() {
    if (_formKey.currentState!.validate()) {
      widget.settingsService.setTireSizeStock(_stockTireSizeController.text.trim());
      widget.settingsService.setTireSizeRunning(_runningTireSizeController.text.trim());

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tire sizes saved successfully')),
      );

      // Notify parent that settings have changed
      widget.onSettingsChanged();

      // Return to previous screen
      widget.onBack();
    }
  }
}