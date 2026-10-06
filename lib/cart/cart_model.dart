import 'package:flutter/foundation.dart';

import '../data/product.dart';

class CartItem {
  CartItem(this.product, this.quantity);

  final Product product;
  int quantity;

  int get totalInMinorUnits => product.priceInMinorUnits * quantity;
}

class CartModel extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  bool get isEmpty => _items.isEmpty;

  int get itemCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  int get totalInMinorUnits =>
      _items.values.fold(0, (sum, item) => sum + item.totalInMinorUnits);

  int quantityOf(Product product) => _items[product.id]?.quantity ?? 0;

  void add(Product product) {
    final item = _items[product.id];
    if (item == null) {
      _items[product.id] = CartItem(product, 1);
    } else {
      item.quantity++;
    }
    notifyListeners();
  }

  void decrement(Product product) {
    final item = _items[product.id];
    if (item == null) return;

    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(product.id);
    }
    notifyListeners();
  }

  void remove(Product product) {
    if (_items.remove(product.id) != null) {
      notifyListeners();
    }
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
