import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SearchProducts {
  final ProductRepository repository;
  SearchProducts(this.repository);

  Future<Either<Failure, List<Product>>> call(String query) {
    return repository.searchProducts(query);
  }
}
