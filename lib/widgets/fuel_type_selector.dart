import 'package:flutter/material.dart';

class FuelTypeSelector extends StatelessWidget {
  final String selectedFuelType;
  final Function(String) onFuelTypeChanged;

  const FuelTypeSelector({
    super.key,
    required this.selectedFuelType,
    required this.onFuelTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFuelTypeButton('liquid', 'Liquid', context),
        _buildFuelTypeButton('electric', 'Electric', context),
        _buildFuelTypeButton('both', 'Both', context),
      ],
    );
  }

  Widget _buildFuelTypeButton(String type, String label, BuildContext context) {
    bool isSelected = selectedFuelType == type;

    return ElevatedButton(
      onPressed: () => onFuelTypeChanged(type),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.grey,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(label),
    );
  }
}
