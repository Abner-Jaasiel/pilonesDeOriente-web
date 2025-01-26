/*import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteManagerController with ChangeNotifier {
  final List<String> _history = [];

  String? get previousRoute => _history.isNotEmpty ? _history.last : null;

  void navigateTo(BuildContext context, String newRoute) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    if (currentRoute != newRoute) {
      _history.add(currentRoute);

      print("Navigating to: $newRoute");
      GoRouter.of(context).go(newRoute);
      notifyListeners();
    }
  }

  void goBack(BuildContext context) {
    if (_history.isNotEmpty) {
      final previousRoute = _history.removeLast();

      print("Going back to: $previousRoute");
      GoRouter.of(context).go(previousRoute);
      notifyListeners();
    }
  }
}*/
