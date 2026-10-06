import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> searchProducts(String query);
}
