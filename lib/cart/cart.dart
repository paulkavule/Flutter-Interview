import 'package:flutter/foundation.dart';

import '../data/product.dart';

class CartLine {
  const CartLine({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  int get lineTotalInMinorUnits => product.priceInMinorUnits * quantity;
}

/// Shared cart state and rules.
///
/// Only product quantities are stored; badge count and every total are
/// derived getters, so they can never drift out of sync with the lines.
class Cart extends ChangeNotifier {
  static const discountPercent = 10;

  // Insertion-ordered, keyed by product id so the same product is one line.
  final Map<int, CartLine> _lines = {};

  List<CartLine> get lines => List.unmodifiable(_lines.values);

  bool get isEmpty => _lines.isEmpty;

  /// Total units across all lines (what the badge shows).
  int get itemCount => _lines.values.fold(0, (sum, l) => sum + l.quantity);

  int get subtotalInMinorUnits =>
      _lines.values.fold(0, (sum, l) => sum + l.lineTotalInMinorUnits);

  /// 10% of the subtotal, rounded half-up to the nearest minor unit using
  /// integer arithmetic only.
  int get discountInMinorUnits =>
      (subtotalInMinorUnits * discountPercent + 50) ~/ 100;

  int get totalInMinorUnits => subtotalInMinorUnits - discountInMinorUnits;

  int quantityOf(int productId) => _lines[productId]?.quantity ?? 0;

  bool canAdd(Product product) =>
      quantityOf(product.id) < product.availableStock;

  bool canIncrement(int productId) {
    final line = _lines[productId];
    return line != null && line.quantity < line.product.availableStock;
  }

  bool canDecrement(int productId) => quantityOf(productId) > 1;

  /// Adds one unit, merging into an existing line. Returns false if the
  /// product is out of stock or already at its stock limit.
  bool add(Product product) {
    if (!canAdd(product)) return false;
    _setQuantity(product, quantityOf(product.id) + 1);
    return true;
  }

  void increment(int productId) {
    if (!canIncrement(productId)) return;
    final line = _lines[productId]!;
    _setQuantity(line.product, line.quantity + 1);
  }

  /// Never drops below one; use [remove] to take a line out.
  void decrement(int productId) {
    if (!canDecrement(productId)) return;
    final line = _lines[productId]!;
    _setQuantity(line.product, line.quantity - 1);
  }

  void remove(int productId) {
    if (_lines.remove(productId) != null) notifyListeners();
  }

  void _setQuantity(Product product, int quantity) {
    _lines[product.id] = CartLine(product: product, quantity: quantity);
    notifyListeners();
  }
}
