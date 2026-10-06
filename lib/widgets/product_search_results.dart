import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../search/product_search_controller.dart';
import '../search/product_search_state.dart';
import 'empty_view.dart';
import 'error_view.dart';
import 'product_list.dart';

class ProductSearchResults extends GetView<ProductSearchController> {
  const ProductSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;

      if (state.status == SearchStatus.failure) {
        return ErrorView(onRetry: controller.retry);
      }

      final products = state.products;
      if (products == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          SizedBox(
            height: 4,
            child: state.isLoading ? const LinearProgressIndicator() : null,
          ),
          Expanded(
            child: products.isEmpty && !state.isLoading
                ? EmptyView(query: state.query)
                : AnimatedOpacity(
                    opacity: state.isLoading ? 0.5 : 1,
                    duration: const Duration(milliseconds: 150),
                    child: ProductList(products: products),
                  ),
          ),
        ],
      );
    });
  }
}
