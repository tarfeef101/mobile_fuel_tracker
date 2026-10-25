import 'package:flutter/material.dart';

/// Bottom sheet to pick one of [options]; scrollable so long lists (e.g. all
/// ~166 forex currency codes) fit.
Future<void> showOptionSheet(
  BuildContext context, {
  required String title,
  required List<String> options,
  String? selected,
  required Future<void> Function(String) onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: ListView(
                  shrinkWrap: true,
                  children: options.map((option) {
                    return ListTile(
                      title: Text(option),
                      trailing: selected == option
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () {
                        Navigator.of(context).pop();
                        onSelected(option);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
