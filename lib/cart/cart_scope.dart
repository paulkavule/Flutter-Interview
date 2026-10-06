import 'package:flutter/widgets.dart';

import 'cart.dart';

/// Exposes the single [Cart] to every route and rebuilds dependents when it
/// changes.
class CartScope extends InheritedNotifier<Cart> {
  const CartScope({super.key, required Cart cart, required super.child})
    : super(notifier: cart);

  static Cart of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'No CartScope found in context');
    return scope!.notifier!;
  }
}
