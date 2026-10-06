# Shopping Cart - Interview Starter

Starter project for the shopping cart task.

## Setup

```bash
flutter create . --project-name shopping_cart
flutter pub get
flutter run
```

`flutter create .` generates the platform folders; it does not overwrite `lib/`.

## Supplied

- `lib/data/product.dart` - `Product` model (`id`, `name`, `priceInMinorUnits`, `availableStock`) and `formatPrice`.
- `lib/data/products.dart` - local sample products, including items with zero stock.
- `lib/screens/` - basic product list and cart screen scaffolding with navigation.

Prices use integer minor units; do not calculate money using `double`.

## Task

| ID | Requirement |
| --- | --- |
| R1 | Add products to the cart. Adding the same product again increases its quantity instead of creating a duplicate line. |
| R2 | Allow quantities to increase or decrease and provide a separate remove action. Enforce quantities from one up to available stock; products with zero stock cannot be added. |
| R3 | Keep the product screen, cart screen, and cart badge synchronized through shared state. The badge shows total item quantities, not the number of distinct products. |
| R4 | Derive line totals, subtotal, and final total from cart state. Apply a fixed 10% discount to the subtotal, rounding the discount to the nearest minor unit. |
| R5 | Display an empty-cart state and retain cart contents when navigating between screens. |
| R6 | Keep cart rules outside UI widgets and avoid manually maintaining separate copies of totals or badge counts. |

You may add any state-management package you prefer.
