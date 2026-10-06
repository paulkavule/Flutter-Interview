# Question 3 — Discussion extension: pagination

> How would you add pagination, prevent duplicate page requests, and retain existing results if the next page fails?

## 1. Change the repository contract

`searchProducts(String query)` returns everything at once, so it can't page. I would extend it to take a cursor and return one page:

```dart
class ProductPage {
  const ProductPage(this.items, this.nextCursor);
  final List<Product> items;
  final String? nextCursor; // null = no more pages
}

Future<ProductPage> searchProducts(String query, {String? cursor, int limit = 20});
```

I prefer a **cursor** to a page number or offset. If products are added or removed between requests, offsets shift, and the user sees duplicates or misses items. A cursor stays tied to a position in the result set.
