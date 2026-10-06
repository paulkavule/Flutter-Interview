class Product {
  const Product({
    required this.id,
    required this.name,
    required this.priceInMinorUnits,
    required this.availableStock,
  });

  final int id;
  final String name;
  final int priceInMinorUnits;
  final int availableStock;
}

/// Local product data supplied for the interview.
const sampleProducts = [
  Product(
    id: 1,
    name: 'Wireless mouse',
    priceInMinorUnits: 2499,
    availableStock: 5,
  ),
  Product(
    id: 2,
    name: 'Mechanical keyboard',
    priceInMinorUnits: 8950,
    availableStock: 2,
  ),
  Product(
    id: 3,
    name: 'USB-C cable',
    priceInMinorUnits: 799,
    availableStock: 10,
  ),
  Product(
    id: 4,
    name: '27" monitor',
    priceInMinorUnits: 24900,
    availableStock: 1,
  ),
  Product(
    id: 5,
    name: 'Laptop stand',
    priceInMinorUnits: 3450,
    availableStock: 0,
  ),
  Product(id: 6, name: 'Webcam', priceInMinorUnits: 5999, availableStock: 3),
];

/// Formats integer minor units (cents) without ever touching `double`.
String formatMoney(int minorUnits) {
  final major = minorUnits ~/ 100;
  final minor = (minorUnits % 100).toString().padLeft(2, '0');
  return '\$$major.$minor';
}
