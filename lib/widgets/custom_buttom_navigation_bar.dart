import 'package:carkett/providers/navigator_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class CustomButtomNavigationBar extends StatelessWidget {
  const CustomButtomNavigationBar({
    super.key,
    this.height = 60,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    this.marginIconButton = EdgeInsets.zero,
    this.shape = const CircularNotchedRectangle(),
  });
  final double height;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsetsGeometry marginIconButton;
  final NotchedShape? shape;
  @override
  Widget build(BuildContext context) {
    final NavigatorController navigatorController =
        Provider.of<NavigatorController>(context);

    return BottomAppBar(
      padding: EdgeInsets.zero,
      height: height,
      shape: shape,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Container(
            margin: marginIconButton,
            child: IconButton(
              padding: EdgeInsets.zero,
              color: navigatorController.currentIndex == 0
                  ? Theme.of(context).colorScheme.primary
                  : null,
              onPressed: () {
                navigatorController.pageController.animateToPage(0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              },
              icon: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          Container(
            margin: marginIconButton,
            child: IconButton(
              padding: EdgeInsets.zero,
              color: navigatorController.currentIndex == 1
                  ? Theme.of(context).colorScheme.primary
                  : null,
              onPressed: () {
                navigatorController.pageController.animateToPage(1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              },
              icon: const Icon(Icons.add),
            ),
          ),
          Container(
            margin: marginIconButton,
            child: IconButton(
              padding: EdgeInsets.zero,
              color: navigatorController.currentIndex == 2
                  ? Theme.of(context).colorScheme.primary
                  : null,
              onPressed: () {
                navigatorController.pageController.animateToPage(2,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              },
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          Container(
            margin: marginIconButton,
            child: IconButton(
              padding: EdgeInsets.zero,
              color: navigatorController.currentIndex == 3
                  ? Theme.of(context).colorScheme.primary
                  : null,
              onPressed: () {
                navigatorController.pageController.animateToPage(3,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              },
              icon: const Icon(Icons.person_2_outlined),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: 1.0, end: 0.0, duration: 500.ms);
  }
}
