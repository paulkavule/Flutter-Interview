import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_cart/data/products.dart';
import 'package:shopping_cart/state/cart_model.dart';

void main() {
  test('adding same product increases quantity', () {
    final cart = CartModel();
    cart.add(sampleProducts[0]);
    cart.add(sampleProducts[0]);

    expect(cart.lines.length, 1);
    expect(cart.itemCount, 2);
  });

  test('cannot add more than available stock', () {
    final cart = CartModel();
    cart.add(sampleProducts[1]);
    cart.add(sampleProducts[1]);
    cart.add(sampleProducts[1]);

    expect(cart.itemCount, 2);
  });

  test('cannot add out of stock product', () {
    final cart = CartModel();
    cart.add(sampleProducts[3]);

    expect(cart.isEmpty, true);
  });

  test('calculates 10% discount', () {
    final cart = CartModel();
    cart.add(sampleProducts[2]);

    expect(cart.subtotalInMinorUnits, 3455);
    expect(cart.discountInMinorUnits, 346);
    expect(cart.totalInMinorUnits, 3109);
  });
}
