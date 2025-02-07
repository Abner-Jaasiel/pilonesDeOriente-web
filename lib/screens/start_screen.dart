import 'package:carkett/providers/appconfig_controller.dart';
import 'package:carkett/providers/navigator_controller.dart';
import 'package:carkett/screens/home_screen.dart';
import 'package:carkett/screens/seller/product_aggregator_screen.dart';
import 'package:carkett/screens/paid_carousel/shopping_cart_screen.dart';
import 'package:carkett/screens/setting/user_profile_screen.dart';
import 'package:carkett/services/auth_firebase_service.dart';
import 'package:carkett/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_buttom_navigation_bar.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return user == null
        ? (kIsWeb
            ? const WebStartScreen(
                token: null,
              )
            : const MobileStartScreen(
                token: null,
              ))
        : FutureBuilder(
            future: loadUserFromPreferences(user.uid),
            builder: (context, snapshot) {
              return FutureBuilder(
                  future: AuthFirebaseService().getIdToken(),
                  builder: (constex, snapshot0) {
                    if (snapshot0.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot0.hasError) {
                      print(snapshot0.error);
                      return Center(child: Text('Error: ${snapshot0.error}'));
                    }

                    return (kIsWeb
                        ? WebStartScreen(
                            token: snapshot0.data,
                          )
                        : MobileStartScreen(
                            token: snapshot0.data,
                          ));
                  });
            });
  }
}

class WebStartScreen extends StatelessWidget {
  const WebStartScreen({super.key, required this.token});
  final String? token;

  @override
  Widget build(BuildContext context) {
    final navigatorController = Provider.of<NavigatorController>(context);
    AppConfigController appConfigController =
        Provider.of<AppConfigController>(context);

    if (token != null) {
      navigatorController.initializePageController();
    }

    return Scaffold(
      body: token != null
          ? PageView(
              onPageChanged: (page) {
                navigatorController.setIndex(page);
              },
              controller: navigatorController.pageController,
              children: [
                const HomeScreen(),
                if (appConfigController.isSeller)
                  const ProductAggregatorScreen(),
                const ShoppingCartScreen(),
                const LoadUserProfileScreen(),
              ],
            )
          : const HomeScreen(),
      bottomNavigationBar: token != null
          ? CustomButtomNavigationBar(isSeller: appConfigController.isSeller)
          : IconButton(
              onPressed: () {
                GoRouter.of(context).push('/login');
              },
              icon: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login),
                  SizedBox(width: 10),
                  Text('Log In'),
                ],
              )),
    );
  }
  /* const WebStartScreen({super.key, required this.token});
  final String? token;
  @override
  Widget build(BuildContext context) {
    final bool withButtons = Provider.of<AppbarController>(context).withButtons;
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniStartDocked,
      body: Consumer<NavigatorController>(
          builder: (context, navigatorController, _) {
        return token != null
            ? PageView(
                onPageChanged: (page) {
                  navigatorController.setIndex(page);
                },
                controller: navigatorController.pageController,
                children: const [
                  HomeScreen(),
                  ProductAggregatorScreen(),
                  ShoppingCartScreen(),
                  LoadUserProfileScreen()
                ],
              )
            : const HomeScreen();
      }),
      bottomNavigationBar: token != null
          ? (withButtons ? null : const CustomButtomNavigationBar())
          : IconButton(
              onPressed: () {
                GoRouter.of(context).push('/login');
              },
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.login),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(S.current.logIn)
                ],
              )),
    );
  }*/
}

class MobileStartScreen extends StatelessWidget {
  /*const MobileStartScreen({super.key, required this.token});
  final String? token;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      //   drawer: MyDrawer(),
      body: Consumer<NavigatorController>(
          builder: (context, navigatorController, _) {
        return token != null
            ? PageView(
                onPageChanged: (page) {
                  navigatorController.setIndex(page);
                },
                controller: navigatorController.pageController,
                children: const [
                  HomeScreen(),
                  ProductAggregatorScreen(),
                  ShoppingCartScreen(),
                  LoadUserProfileScreen()
                ],
              )
            : const HomeScreen();
      }),
      bottomNavigationBar: token != null
          ? (/*withButtons ? null : */ const CustomButtomNavigationBar())
          : IconButton(
              onPressed: () {
                GoRouter.of(context).push('/login');
              },
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.login),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(S.current.logIn)
                ],
              )),
    );
  }*/
  const MobileStartScreen({super.key, required this.token});
  final String? token;

  @override
  Widget build(BuildContext context) {
    final navigatorController = Provider.of<NavigatorController>(context);
    AppConfigController appConfigController =
        Provider.of<AppConfigController>(context);

    if (token != null) {
      navigatorController.initializePageController();
    }

    return Scaffold(
      body: token != null
          ? PageView(
              onPageChanged: (page) {
                navigatorController.setIndex(page);
              },
              controller: navigatorController.pageController,
              children: [
                const HomeScreen(),
                if (appConfigController.isSeller)
                  const ProductAggregatorScreen(),
                const ShoppingCartScreen(),
                const LoadUserProfileScreen(),
              ],
            )
          : const HomeScreen(),
      bottomNavigationBar: token != null
          ? CustomButtomNavigationBar(isSeller: appConfigController.isSeller)
          : IconButton(
              onPressed: () {
                GoRouter.of(context).push('/login');
              },
              icon: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login),
                  SizedBox(width: 10),
                  Text('Log In'),
                ],
              )),
    );
  }
}
