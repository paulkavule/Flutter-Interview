import '../../data/product.dart';

sealed class ProductSearchState {
  const ProductSearchState();
}

final class ProductSearchInitial extends ProductSearchState {
  const ProductSearchInitial();
}

final class ProductSearchLoading extends ProductSearchState {
  const ProductSearchLoading(this.query);

  final String query;
}

final class ProductSearchSuccess extends ProductSearchState {
  const ProductSearchSuccess({
    required this.products,
    required this.query,
  });

  final List<Product> products;
  final String query;
}

final class ProductSearchEmpty extends ProductSearchState {
  const ProductSearchEmpty(this.query);

  final String query;
}

final class ProductSearchFailure extends ProductSearchState {
  const ProductSearchFailure({
    required this.message,
    required this.query,
  });

  final String message;
  final String query;
}
