import 'package:flutter/foundation.dart';

import 'product.dart';

class CartLine {
  const CartLine(this.product, this.quantity);

  final Product product;
  final int quantity;

  int get subtotalInMinorUnits => product.priceInMinorUnits * quantity;
}

/// Single source of truth for the cart, shared by the product and cart screens.
///
/// Only quantities are stored; counts and totals are derived on read so they
/// can never drift out of sync.
class CartController extends ChangeNotifier {
  // Keyed by product id; insertion order is the order lines are shown in.
  final Map<int, CartLine> _lines = {};

  List<CartLine> get lines => List.unmodifiable(_lines.values);

  bool get isEmpty => _lines.isEmpty;

  int get itemCount => _lines.values.fold(0, (sum, l) => sum + l.quantity);

  int get totalInMinorUnits =>
      _lines.values.fold(0, (sum, l) => sum + l.subtotalInMinorUnits);

  int quantityOf(Product product) => _lines[product.id]?.quantity ?? 0;

  bool canAdd(Product product) => quantityOf(product) < product.availableStock;

  void add(Product product) {
    if (!canAdd(product)) return;
    _lines[product.id] = CartLine(product, quantityOf(product) + 1);
    notifyListeners();
  }

  void decrement(Product product) {
    final quantity = quantityOf(product);
    if (quantity == 0) return;
    if (quantity == 1) {
      _lines.remove(product.id);
    } else {
      _lines[product.id] = CartLine(product, quantity - 1);
    }
    notifyListeners();
  }

  void remove(Product product) {
    if (_lines.remove(product.id) != null) notifyListeners();
  }

  void clear() {
    if (_lines.isEmpty) return;
    _lines.clear();
    notifyListeners();
  }
}
