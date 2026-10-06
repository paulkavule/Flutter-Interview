import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_search/data/product.dart';
import 'package:product_search/data/product_repository.dart';
import 'package:product_search/main.dart';

void main() {
  testWidgets('tapping outside dismisses the search keyboard', (tester) async {
    await tester.pumpWidget(ProductSearchApp(repository: _TestRepository()));
    await tester.pump();

    await tester.tap(find.byType(TextField));
    await tester.pump();

    EditableText input = tester.widget(find.byType(EditableText));
    expect(input.focusNode.hasFocus, isTrue);

    await tester.tap(find.text('Products'));
    await tester.pump();

    input = tester.widget(find.byType(EditableText));
    expect(input.focusNode.hasFocus, isFalse);
  });
}

class _TestRepository extends ProductRepository {
  @override
  Future<List<Product>> searchProducts(String query) async => const [];
}
