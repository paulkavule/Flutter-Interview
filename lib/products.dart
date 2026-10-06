import 'package:flutter/material.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.icon,
    required this.color,
  });

  final int id;
  final String name;
  final String category;
  final String description;
  final double price;
  final IconData icon;
  final Color color;
}

const _products = [
  Product(
    id: 1,
    name: 'Pour-over set',
    category: 'Kitchen',
    description: 'Ceramic dripper and cup, made for slow mornings.',
    price: 38.00,
    icon: Icons.coffee_outlined,
    color: Color(0xFFF0D8C3),
  ),
  Product(
    id: 2,
    name: 'Linen notebook',
    category: 'Studio',
    description: 'A cloth-bound journal with 192 smooth pages.',
    price: 24.00,
    icon: Icons.menu_book_outlined,
    color: Color(0xFFDCE9DA),
  ),
  Product(
    id: 3,
    name: 'Everyday tote',
    category: 'Carry',
    description: 'Heavyweight cotton canvas with a roomy base.',
    price: 32.00,
    icon: Icons.shopping_bag_outlined,
    color: Color(0xFFE8E2C8),
  ),
  Product(
    id: 4,
    name: 'Desk light',
    category: 'Studio',
    description: 'Warm, adjustable light with a solid oak base.',
    price: 86.00,
    icon: Icons.light_outlined,
    color: Color(0xFFF1E3AE),
  ),
  Product(
    id: 5,
    name: 'Field bottle',
    category: 'Carry',
    description: 'Double-wall steel keeps drinks cold all day.',
    price: 29.00,
    icon: Icons.water_drop_outlined,
    color: Color(0xFFD7E7E9),
  ),
  Product(
    id: 6,
    name: 'Stoneware bowl',
    category: 'Kitchen',
    description: 'A softly speckled bowl for everyday meals.',
    price: 26.00,
    icon: Icons.ramen_dining_outlined,
    color: Color(0xFFEBD9D5),
  ),
];

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final Map<int, int> _cart = {};
  String _selectedCategory = 'All';

  int get _cartCount => _cart.values.fold(0, (sum, count) => sum + count);

  List<String> get _categories => [
        'All',
        ..._products.map((product) => product.category).toSet().toList()
          ..sort(),
      ];

  List<Product> get _visibleProducts => _selectedCategory == 'All'
      ? _products
      : _products
          .where((product) => product.category == _selectedCategory)
          .toList();

  void _changeQuantity(int productId, int quantity) {
    setState(() {
      if (quantity <= 0) {
        _cart.remove(productId);
      } else {
        _cart[productId] = quantity;
      }
    });
  }

  void _openCart() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CartScreen(
          products: _products,
          quantities: _cart,
          onQuantityChanged: _changeQuantity,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 900
        ? 3
        : width >= 560
            ? 2
            : 1;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Objects for everyday',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 3),
                    const Text('Considered goods, made to be used.'),
                  ],
                ),
              ),
              Badge.count(
                count: _cartCount,
                isLabelVisible: _cartCount > 0,
                child: IconButton(
                  onPressed: _openCart,
                  tooltip: 'Open cart',
                  icon: const Icon(Icons.shopping_bag_outlined),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 46,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = _categories[index];
              return ChoiceChip(
                label: Text(category),
                selected: _selectedCategory == category,
                onSelected: (_) => setState(() => _selectedCategory = category),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            itemCount: _visibleProducts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisExtent: 282,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemBuilder: (context, index) {
              final product = _visibleProducts[index];
              return _ProductTile(
                product: product,
                quantity: _cart[product.id] ?? 0,
                onAdd: () => _changeQuantity(
                  product.id,
                  (_cart[product.id] ?? 0) + 1,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    required this.product,
    required this.quantity,
    required this.onAdd,
  });

  final Product product;
  final int quantity;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFE1E5DE)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ColoredBox(
              color: product.color,
              child: Center(
                child: Icon(product.icon,
                    size: 56, color: const Color(0xFF36594C)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 11, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.category.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF69766F),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ),
                    Text('\$${product.price.toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF69766F),
                        height: 1.3,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (quantity > 0)
                      Expanded(
                        child: Text(
                          '$quantity in cart',
                          style: const TextStyle(
                            color: Color(0xFF176B5B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      const Spacer(),
                    IconButton.filledTonal(
                      onPressed: onAdd,
                      tooltip: 'Add ${product.name} to cart',
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.add_shopping_cart_outlined,
                          size: 19),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
    required this.products,
    required this.quantities,
    required this.onQuantityChanged,
  });

  final List<Product> products;
  final Map<int, int> quantities;
  final void Function(int productId, int quantity) onQuantityChanged;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Product> get _cartProducts => widget.products
      .where((product) => (widget.quantities[product.id] ?? 0) > 0)
      .toList();

  double get _subtotal => _cartProducts.fold(
        0,
        (sum, product) =>
            sum + product.price * (widget.quantities[product.id] ?? 0),
      );

  void _update(Product product, int quantity) {
    widget.onQuantityChanged(product.id, quantity);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cartProducts = _cartProducts;
    return Scaffold(
      appBar: AppBar(title: const Text('Your cart')),
      body: cartProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 44),
                  const SizedBox(height: 12),
                  Text('Your cart is empty',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  const Text('Add something useful from the product list.'),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartProducts.length,
                    separatorBuilder: (_, __) => const Divider(height: 24),
                    itemBuilder: (context, index) {
                      final product = cartProducts[index];
                      final quantity = widget.quantities[product.id] ?? 0;
                      return Row(
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              color: product.color,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(product.icon,
                                color: const Color(0xFF36594C)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)} each',
                                  style:
                                      const TextStyle(color: Color(0xFF69766F)),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _update(product, quantity - 1),
                            tooltip: 'Remove one ${product.name}',
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text('$quantity'),
                          IconButton(
                            onPressed: () => _update(product, quantity + 1),
                            tooltip: 'Add one ${product.name}',
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text('Subtotal',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        Text(
                          '\$${_subtotal.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
