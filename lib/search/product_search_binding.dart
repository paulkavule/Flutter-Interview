import 'package:get/get.dart';

import 'product_search_controller.dart';

class ProductSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductSearchController(repository: Get.find()));
  }
}
