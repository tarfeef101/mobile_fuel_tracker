/// Parses a tire size string and returns the outer diameter in inches.
/// Supports metric sizes (e.g. "225/65R17") and direct diameters (e.g. "26 inches").
double? tireDiameterInches(String tireSize) {
  final size = tireSize.trim();
  if (size.isEmpty) return null;

  // Handle direct diameter input (like "26 inches")
  if (size.contains('in')) {
    return double.tryParse(size.replaceAll(RegExp(r'[^0-9.]'), ''));
  }

  // Handle standard tire size format (e.g., "225/65R17")
  final match = RegExp(r'^(\d+)\/(\d+)[Rr](\d+)$').firstMatch(size);
  if (match != null) {
    final width = double.parse(match.group(1)!);
    final aspectRatio = double.parse(match.group(2)!);
    final rimDiameter = double.parse(match.group(3)!);
    final sidewallHeight = width * aspectRatio / 100; // mm
    return (sidewallHeight * 2 + rimDiameter * 25.4) / 25.4;
  }

  return null;
}

/// Distance correction factor (running/stock - 1) for odometer readings taken
/// with tires different from the stock size. Null if either size is missing
/// or unparseable.
double? tireSizeOffset(String? stockSize, String? runningSize) {
  if (stockSize == null || stockSize.isEmpty) return null;
  if (runningSize == null || runningSize.isEmpty) return null;

  try {
    final stockDiameter = tireDiameterInches(stockSize);
    final runningDiameter = tireDiameterInches(runningSize);
    if (stockDiameter != null && runningDiameter != null && stockDiameter > 0) {
      return runningDiameter / stockDiameter - 1.0;
    }
  } catch (_) {
    return null;
  }

  return null;
}
