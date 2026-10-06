import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    try {
      return Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
