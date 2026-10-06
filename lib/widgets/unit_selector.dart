import 'package:flutter/material.dart';

class UnitSelector extends StatelessWidget {
  final String selectedUnit;
  final List<String> units;
  final Function(String) onUnitChanged;

  const UnitSelector({
    super.key,
    required this.selectedUnit,
    required this.units,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: units.map((unit) {
        bool isSelected = selectedUnit == unit;
        return ElevatedButton(
          onPressed: () => onUnitChanged(unit),
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: Text(unit),
        );
      }).toList(),
    );
  }
}