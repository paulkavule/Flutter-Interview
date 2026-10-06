class Product {
  const Product({
    required this.id,
    required this.name,
    required this.priceInMinorUnits,
  });

  final int id;
  final String name;

  /// Price in cents; avoid using double for money.
  final int priceInMinorUnits;
}

/// Formats minor units as a display price, e.g. 129900 -> "1299.00".
String formatPrice(int minorUnits) {
  final major = minorUnits ~/ 100;
  final minor = (minorUnits % 100).toString().padLeft(2, '0');
  return '$major.$minor';
}
