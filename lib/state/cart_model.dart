import 'package:flutter/foundation.dart';

import '../data/product.dart';

class CartLine {
  const CartLine({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  int get totalInMinorUnits => product.priceInMinorUnits * quantity;
}

class CartModel extends ChangeNotifier {
  static const discountPercent = 10;

  final Map<int, CartLine> _lines = {};

  List<CartLine> get lines => List.unmodifiable(_lines.values);

  bool get isEmpty => _lines.isEmpty;

  /// Total quantity across all lines, not the number of distinct products.
  int get itemCount => _lines.values.fold(0, (sum, line) => sum + line.quantity);

  int get subtotalInMinorUnits =>
      _lines.values.fold(0, (sum, line) => sum + line.totalInMinorUnits);

  /// Discount rounded half-up to the nearest minor unit.
  int get discountInMinorUnits =>
      (subtotalInMinorUnits * discountPercent + 50) ~/ 100;

  int get totalInMinorUnits => subtotalInMinorUnits - discountInMinorUnits;

  int quantityOf(Product product) => _lines[product.id]?.quantity ?? 0;

  bool canIncrement(Product product) =>
      quantityOf(product) < product.availableStock;

  bool canDecrement(Product product) => quantityOf(product) > 1;

  /// Adds one unit, or increases the existing line's quantity.
  void add(Product product) {
    if (!canIncrement(product)) return;
    _setQuantity(product, quantityOf(product) + 1);
  }

  void decrement(Product product) {
    if (!canDecrement(product)) return;
    _setQuantity(product, quantityOf(product) - 1);
  }

  void remove(Product product) {
    if (_lines.remove(product.id) != null) notifyListeners();
  }

  void _setQuantity(Product product, int quantity) {
    _lines[product.id] = CartLine(product: product, quantity: quantity);
    notifyListeners();
  }
}
