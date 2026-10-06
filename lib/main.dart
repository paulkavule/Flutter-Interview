import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'data/product_repository.dart';
import 'search/product_search_binding.dart';
import 'search/product_search_screen.dart';

void main() {
  runApp(ProductSearchApp(repository: ProductRepository()));
}

class ProductSearchApp extends StatelessWidget {
  const ProductSearchApp({super.key, required this.repository});

  final ProductRepository repository;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Product Search',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      initialBinding: BindingsBuilder(
        () => Get.put<ProductRepository>(repository, permanent: true),
      ),
      initialRoute: ProductSearchScreen.routeName,
      getPages: [
        GetPage(
          name: ProductSearchScreen.routeName,
          page: () => const ProductSearchScreen(),
          binding: ProductSearchBinding(),
        ),
      ],
    );
  }
}
