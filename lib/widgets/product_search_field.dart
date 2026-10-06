import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../search/product_search_controller.dart';

class ProductSearchField extends GetView<ProductSearchController> {
  const ProductSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = controller.textController;
    return TextField(
      controller: textController,
      onChanged: controller.onQueryChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        labelText: 'Search products',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: ListenableBuilder(
          listenable: textController,
          builder: (context, _) => textController.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  tooltip: 'Clear',
                  icon: const Icon(Icons.clear),
                  onPressed: controller.clear,
                ),
        ),
      ),
    );
  }
}
