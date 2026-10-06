import 'package:flutter/material.dart';

import '../data/product_repository.dart';

/// Scaffolding only. Implement the search behaviour described in README.md.
class ProductSearchScreen extends StatelessWidget {
  const ProductSearchScreen({super.key, required this.repository});

  final ProductRepository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: const Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search products',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(child: Center(child: Text('TODO: results'))),
        ],
      ),
    );
  }
}
