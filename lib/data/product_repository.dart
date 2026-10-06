import 'dart:math';

import 'product.dart';

/// Supplied repository. Candidates must not modify this file.
///
/// Each call waits a random 200-1500 ms, so responses may arrive out of order.
/// Any query containing [errorQuery] fails with an exception.
class ProductRepository {
  ProductRepository({Random? random}) : _random = random ?? Random();

  static const errorQuery = 'fail';

  final Random _random;

  Future<List<Product>> searchProducts(String query) async {
    final delay = Duration(milliseconds: 200 + _random.nextInt(1300));
    await Future<void>.delayed(delay);

    final normalized = query.trim().toLowerCase();
    if (normalized.contains(errorQuery)) {
      throw Exception('Search failed for "$query"');
    }
    return _products
        .where((p) => p.name.toLowerCase().contains(normalized))
        .toList();
  }
}

const _products = [
  Product(id: 1, name: 'Wireless Mouse', priceInMinorUnits: 2499),
  Product(id: 2, name: 'Mechanical Keyboard', priceInMinorUnits: 8999),
  Product(id: 3, name: 'USB-C Hub', priceInMinorUnits: 3450),
  Product(id: 4, name: 'Laptop Stand', priceInMinorUnits: 2999),
  Product(id: 5, name: 'Noise Cancelling Headphones', priceInMinorUnits: 19999),
  Product(id: 6, name: 'Webcam HD', priceInMinorUnits: 5999),
  Product(id: 7, name: 'Monitor 27 inch', priceInMinorUnits: 24999),
  Product(id: 8, name: 'Desk Lamp', priceInMinorUnits: 1999),
  Product(id: 9, name: 'Mouse Pad', priceInMinorUnits: 999),
  Product(id: 10, name: 'Portable SSD 1TB', priceInMinorUnits: 11999),
  Product(id: 11, name: 'Bluetooth Speaker', priceInMinorUnits: 4599),
  Product(id: 12, name: 'Laptop Sleeve', priceInMinorUnits: 1799),
];
