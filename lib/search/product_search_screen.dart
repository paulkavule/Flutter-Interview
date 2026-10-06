import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/product_search_field.dart';
import '../widgets/product_search_results.dart';
import 'product_search_controller.dart';

class ProductSearchScreen extends GetView<ProductSearchController> {
  const ProductSearchScreen({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: const Column(
        children: [
          Padding(padding: EdgeInsets.all(16), child: ProductSearchField()),
          Expanded(child: ProductSearchResults()),
        ],
      ),
    );
  }
}
