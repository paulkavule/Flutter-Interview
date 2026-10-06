import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CartModel', () {
    test('adding the same product twice increases quantity (R1)', () {},
        skip: true);

    test('products with zero stock cannot be added (R2)', () {}, skip: true);

    test('quantity cannot go above available stock (R2)', () {}, skip: true);

    test('quantity cannot go below one (R2)', () {}, skip: true);

    test('remove deletes the line (R2)', () {}, skip: true);

    test('item count is the sum of quantities (R3)', () {}, skip: true);

    test('totals apply a rounded 10% discount to the subtotal (R4)', () {},
        skip: true);
  });
}
