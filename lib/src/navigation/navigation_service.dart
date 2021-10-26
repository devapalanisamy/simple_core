import 'package:flutter/material.dart';
import 'package:simple_core/src/navigation/i_navigation_service.dart';

class NavigationService implements INavigationService {
  @override
  Future<T?> pushNamed<T, S>(String routeName, {S? arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  @override
  Future<T?> pushNamedAndRemoveUntil<T, S>(String routeName, {S? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: arguments);
  }

  @override
  void pop<T>({T? arguments}) {
    return navigatorKey.currentState!.pop(arguments);
  }

  @override
  void popUntil(String routeName, {dynamic arguments}) {
    navigatorKey.currentState!.popUntil((Route<void> r) => r.isFirst);
  }

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
}
