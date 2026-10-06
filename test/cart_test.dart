import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_cart/cart/cart.dart';
import 'package:shopping_cart/data/product.dart';
import 'package:shopping_cart/data/products.dart';

Product byId(int id) => sampleProducts.firstWhere((p) => p.id == id);

void main() {
  late Cart cart;
  final mouse = byId(1); // 2499, stock 5
  final keyboard = byId(2); // 8999, stock 2
  final hub = byId(3); // 3455, stock 10
  final stand = byId(4); // stock 0
  final pad = byId(8); // 995, stock 20

  setUp(() => cart = Cart());
  tearDown(() => cart.dispose());

  test('adding the same product increases quantity on one line', () {
    cart.add(mouse);
    cart.add(mouse);
    expect(cart.lines, hasLength(1));
    expect(cart.quantityOf(mouse.id), 2);
  });

  test('zero-stock products cannot be added', () {
    expect(cart.canAdd(stand), isFalse);
    expect(cart.add(stand), isFalse);
    expect(cart.isEmpty, isTrue);
  });

  test('quantity is capped at available stock', () {
    expect(cart.add(keyboard), isTrue);
    expect(cart.add(keyboard), isTrue);
    expect(cart.add(keyboard), isFalse);
    cart.increment(keyboard.id);
    expect(cart.quantityOf(keyboard.id), 2);
    expect(cart.canIncrement(keyboard.id), isFalse);
  });

  test('decrement stops at one; remove is separate', () {
    cart.add(mouse);
    cart.increment(mouse.id);
    cart.decrement(mouse.id);
    cart.decrement(mouse.id);
    expect(cart.quantityOf(mouse.id), 1);
    expect(cart.canDecrement(mouse.id), isFalse);

    cart.remove(mouse.id);
    expect(cart.isEmpty, isTrue);
  });

  test('badge counts total units, not distinct products', () {
    cart.add(mouse);
    cart.add(mouse);
    cart.add(pad);
    expect(cart.itemCount, 3);
  });

  test('derives line totals, subtotal, discount and total', () {
    cart.add(mouse);
    cart.add(mouse);
    cart.add(keyboard);
    expect(cart.lines.first.lineTotalInMinorUnits, 4998);
    expect(cart.subtotalInMinorUnits, 4998 + 8999); // 13997
    expect(cart.discountInMinorUnits, 1400); // 1399.7 -> 1400
    expect(cart.totalInMinorUnits, 12597);
  });

  test('discount rounds half-up to the nearest minor unit', () {
    cart.add(hub); // 345.5 -> 346
    expect(cart.discountInMinorUnits, 346);
    expect(cart.totalInMinorUnits, 3109);

    cart.remove(hub.id);
    cart.add(pad); // 99.5 -> 100
    expect(cart.discountInMinorUnits, 100);
    expect(cart.totalInMinorUnits, 895);

    cart.add(pad); // 1990 -> 199 exactly
    expect(cart.discountInMinorUnits, 199);
  });

  test('empty cart totals are zero', () {
    expect(cart.subtotalInMinorUnits, 0);
    expect(cart.discountInMinorUnits, 0);
    expect(cart.totalInMinorUnits, 0);
    expect(cart.itemCount, 0);
  });

  test('notifies listeners only on real changes', () {
    var notifications = 0;
    cart.addListener(() => notifications++);
    cart.add(stand); // rejected
    cart.remove(mouse.id); // not in cart
    expect(notifications, 0);
    cart.add(mouse);
    expect(notifications, 1);
  });
}
