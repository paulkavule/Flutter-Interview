import '../../data/product.dart';

abstract class IProductRepository {
  Future<List<Product>> searchProducts(String query);
}
