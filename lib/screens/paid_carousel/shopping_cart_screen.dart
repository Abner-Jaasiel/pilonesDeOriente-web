/*import 'package:carkett/generated/l10n.dart';

import 'package:carkett/models/cart_item_model.dart';
import 'package:carkett/providers/payment_controller.dart';
import 'package:carkett/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  List<CartItemModel> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final fetchedCartItems =
          await APIService().fetchCartItems(user.uid, status: 'pending');
      if (mounted) {
        setState(() {
          cartItems = CartItemModel.fromList(
            fetchedCartItems.cast<Map<String, dynamic>>(),
          );
          isLoading = false;
        });
      }
    }
  }

  double _calculateSubtotal() {
    return cartItems.fold(0.0, (sum, item) {
      return sum + (item.price * item.quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    PaymentController paymentController =
        Provider.of<PaymentController>(context);
    double subtotal = _calculateSubtotal();
    paymentController.setSubtotal(subtotal);
    for (var item in cartItems) {
      paymentController.addProductId(item.productId);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.shoppingCart),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? Center(child: Text(S.current.empty))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(cartItems[index].id.toString()),
                            background: Container(
                              color: Colors.red,
                              alignment: AlignmentDirectional.centerEnd,
                              child: const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onDismissed: (direction) {
                              APIService().removeCartItem(
                                cartItems[index].id.toString(),
                                cartItems[index].productId,
                              );
                              setState(() => cartItems.removeAt(index));
                            },
                            child: InkWell(
                              onTap: () => GoRouter.of(context).push(
                                '/product/${cartItems[index].productId}',
                              ),
                              child: Card(
                                elevation: 1,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                  horizontal: 4.0,
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16.0),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      cartItems[index].imageUrl,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    cartItems[index].name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '\$${(cartItems[index].price * cartItems[index].quantity).toStringAsFixed(2)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Qty: ${cartItems[index].quantity}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Total a pagar: \$${subtotal.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              GoRouter.of(context).push('/profile_selection');
                            },
                            child: Text(S.current.buy),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
*/

import 'dart:convert';

import 'package:carkett/generated/l10n.dart';
import 'package:carkett/models/cart_item_model.dart';
import 'package:carkett/providers/appconfig_controller.dart';
import 'package:carkett/providers/payment_controller.dart';
import 'package:carkett/services/api_service.dart';
import 'package:carkett/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  List<CartItemModel> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCartItems();
  }

  Future<void> _loadSavedCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('cartItems');

    if (savedData != null) {
      setState(() {
        cartItems = CartItemModel.fromList(
          List<Map<String, dynamic>>.from(jsonDecode(savedData)),
        );
        isLoading = false;
      });
    } else {
      _fetchCartItems();
    }
  }

  Future<void> _fetchCartItems() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final fetchedCartItems =
          await APIService().fetchCartItems(user.uid, status: 'pending');

      if (mounted) {
        setState(() {
          cartItems = CartItemModel.fromList(
            fetchedCartItems.cast<Map<String, dynamic>>(),
          );
          isLoading = false;
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('cartItems', jsonEncode(fetchedCartItems));
      }
    }
  }

  double _calculateSubtotal() {
    return cartItems.fold(0.0, (sum, item) {
      return sum + (item.price * item.quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    PaymentController paymentController =
        Provider.of<PaymentController>(context);
    double subtotal = _calculateSubtotal();
    paymentController.setSubtotal(subtotal);
    for (var item in cartItems) {
      paymentController.addProductId(item.productId);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.shoppingCart),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? Center(child: Text(S.current.empty))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(cartItems[index].id.toString()),
                            background: Container(
                              color: Colors.red,
                              alignment: AlignmentDirectional.centerEnd,
                              child: const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onDismissed: (direction) {
                              APIService().removeCartItem(
                                cartItems[index].id.toString(),
                                cartItems[index].productId,
                              );
                              setState(() => cartItems.removeAt(index));
                            },
                            child: InkWell(
                              onTap: () => GoRouter.of(context).push(
                                '/product/${cartItems[index].productId}',
                              ),
                              child: Card(
                                elevation: 1,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                  horizontal: 4.0,
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16.0),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      cartItems[index].imageUrl,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    cartItems[index].name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${getFormattedCurrency(cartItems[index].price * cartItems[index].quantity, context)} ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Qty: ${cartItems[index].quantity}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Total a pagar: ${getFormattedCurrency(subtotal, context)}',
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              GoRouter.of(context).push('/profile_selection');
                            },
                            child: Text(S.current.buy),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
