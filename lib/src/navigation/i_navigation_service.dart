import 'package:flutter/material.dart';

enum NavigationFlow { regular, home, more }

abstract class INavigationService {
  GlobalKey<NavigatorState> get navigatorKey;
  Future<T?> pushNamed<T, S>(String routeName, {S? arguments});
  Future<T?> pushNamedAndRemoveUntil<T, S>(String routeName, {S arguments});
  void pop<T>({T? arguments});
  void popUntil(String routeName, {dynamic arguments});
}
