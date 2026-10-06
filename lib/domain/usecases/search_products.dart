import '../../data/product.dart';
import '../repositories/i_product_repository.dart';

class SearchProducts {
  const SearchProducts(this.repository);

  final IProductRepository repository;

  Future<List<Product>> call(String query) {
    return repository.searchProducts(query);
  }
}
