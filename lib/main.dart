import 'package:flutter/material.dart';

import 'cart/cart_controller.dart';
import 'cart/product_list_screen.dart';
import 'core/app_theme.dart';
import 'registration/registration_api.dart';
import 'registration/registration_screen.dart';

void main() => runApp(RegistrationApp());

class RegistrationApp extends StatelessWidget {
  /// [api] and [cart] are injectable so tests can substitute fakes.
  RegistrationApp({super.key, RegistrationApi? api, CartController? cart})
    : api = api ?? RegistrationApi(),
      cart = cart ?? CartController();

  final RegistrationApi api;
  final CartController cart;

  static final _theme = buildAppTheme();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create account',
      debugShowCheckedModeBanner: false,
      theme: _theme,
      home: HomeShell(api: api, cart: cart),
    );
  }
}

/// Switches between the registration form and the product cart.
/// [IndexedStack] keeps both screens alive so form input and cart state
/// survive tab changes.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.api, required this.cart});

  final RegistrationApi api;
  final CartController cart;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          RegistrationScreen(api: widget.api),
          ProductListScreen(cart: widget.cart),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_add_outlined),
            selectedIcon: Icon(Icons.person_add),
            label: 'Register',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
        ],
      ),
    );
  }
}
