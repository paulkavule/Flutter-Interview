import '../domain/repositories/i_product_repository.dart';
import 'product.dart';
import 'product_repository.dart';

class ProductRepositoryAdapter implements IProductRepository {
  const ProductRepositoryAdapter(this._repository);

  final ProductRepository _repository;

  @override
  Future<List<Product>> searchProducts(String query) {
    return _repository.searchProducts(query);
  }
}
