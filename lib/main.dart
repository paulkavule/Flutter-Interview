import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/search/presentation/screens/search_screen.dart';

void main() {
  runApp(const ProviderScope(child: ProductSearchApp()));
}

class ProductSearchApp extends StatelessWidget {
  const ProductSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Search',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const SearchScreen(),
    );
  }
}
