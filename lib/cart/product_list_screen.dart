import 'package:flutter/material.dart';

import '../data/product.dart';
import '../data/product_repository.dart';
import 'cart_model.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({
    super.key,
    required this.repository,
    required this.cart,
  });

  final ProductRepository repository;
  final CartModel cart;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _products = widget.repository.searchProducts('');
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CartScreen(cart: widget.cart)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          ListenableBuilder(
            listenable: widget.cart,
            builder: (context, _) {
              final count = widget.cart.itemCount;
              return IconButton(
                onPressed: _openCart,
                icon: Badge(
                  label: Text('Items $count'),
                  isLabelVisible: count > 0,
                  child: const Icon(Icons.shopping_cart),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Could not load Product Items'));
          }

          final products = snapshot.data ?? [];

          return ListenableBuilder(
            listenable: widget.cart,
            builder: (context, _) {
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final quantity = widget.cart.quantityOf(product);

                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text(formatPrice(product.priceInMinorUnits)),
                    trailing: quantity == 0
                        ? TextButton(
                            onPressed: () => widget.cart.add(product),
                            child: const Text('Add an Item'),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => widget.cart.decrement(product),
                                icon: const Icon(Icons.remove),
                              ),
                              Text('$quantity'),
                              IconButton(
                                onPressed: () => widget.cart.add(product),
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
