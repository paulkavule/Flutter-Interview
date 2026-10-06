import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_cart/main.dart';

void main() {
  testWidgets('app starts on the product list', (tester) async {
    await tester.pumpWidget(const ShoppingCartApp());

    expect(find.text('Products'), findsOneWidget);
    expect(find.text('Wireless Mouse'), findsOneWidget);
  });
}
