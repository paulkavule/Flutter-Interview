sealed class ProductSearchEvent {
  const ProductSearchEvent();
}

final class ProductSearchStarted extends ProductSearchEvent {
  const ProductSearchStarted();
}

final class ProductSearchQueryChanged extends ProductSearchEvent {
  const ProductSearchQueryChanged(this.query);

  final String query;
}

final class ProductSearchRetryRequested extends ProductSearchEvent {
  const ProductSearchRetryRequested();
}

final class ProductSearchExecutionRequested extends ProductSearchEvent {
  const ProductSearchExecutionRequested(this.query);

  final String query;
}
