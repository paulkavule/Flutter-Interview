# Product Search - Interview Starter

Starter project for the searchable product list task.

## Setup

```bash
flutter create . --project-name product_search
flutter pub get
flutter run
```

`flutter create .` generates the platform folders; it does not overwrite `lib/`.

## Supplied

- `lib/data/product.dart` - `Product` model (`id`, `name`, `priceInMinorUnits`) and `formatPrice`.
- `lib/data/product_repository.dart` - `searchProducts(String query)` with random delays (200-1500 ms). Any query containing `fail` throws. Do not modify this file.
- `lib/search/product_search_screen.dart` - basic screen scaffolding.

## Task

| ID | Requirement |
| --- | --- |
| R1 | Provide a search field and a list showing product names and prices. An empty query retrieves all sample products. |
| R2 | Debounce search input by approximately 400 milliseconds. |
| R3 | Display loading, results, empty, and error states clearly. |
| R4 | Ensure a response from an older query cannot replace the results or state of the current query. This must also apply to delayed errors. |
| R5 | Allow retry after failure using the current query. |
| R6 | Keep search logic outside the presentation widget using a state-management approach of your choice. Clean up timers, listeners, and controllers as applicable. |

You may add any state-management package you prefer.
