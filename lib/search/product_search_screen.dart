import 'package:flutter/material.dart';

import '../data/product_repository.dart';
import '../data/product.dart';
import '../controllers/product_search_controller.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key, required this.repository});

  final ProductRepository repository;

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  late final ProductSearchController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProductSearchController(repository: widget.repository);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: _controller.setQuery,
              decoration: const InputDecoration(
                labelText: 'Search products',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_controller.status) {
      case ProductSearchStatus.loading:
        return const Center(child: Text('Loading...'));
      case ProductSearchStatus.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Something went wrong, try again.'),
              TextButton(
                onPressed: _controller.retry,
                child: const Text('Try again'),
              ),
            ],
          ),
        );
      case ProductSearchStatus.empty:
        return const Center(child: Text('No products found.'));
      case ProductSearchStatus.results:
        return ListView.builder(
          itemCount: _controller.products.length,
          itemBuilder: (context, index) {
            final product = _controller.products[index];
            return ListTile(
              title: Text(product.name),
              trailing: Text('\$${formatPrice(product.priceInMinorUnits)}'),
            );
          },
        );
    }
  }
}
