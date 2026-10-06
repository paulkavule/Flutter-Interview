import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/product_repository.dart';
import 'search/product_search_screen.dart';

void main() {
  runApp(ProductSearchApp(repository: ProductRepository()));
}

class ProductSearchApp extends StatelessWidget {
  const ProductSearchApp({super.key, required this.repository});

  final ProductRepository repository;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Product Search',
        theme: ThemeData(colorSchemeSeed: Colors.indigo),
        home: ProductSearchScreen(repository: repository),
      ),
    );
  }
}
