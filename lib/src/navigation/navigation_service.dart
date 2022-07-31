import 'package:flutter/material.dart';
import 'package:simple_core/src/navigation/i_navigation_service.dart';

class NavigationService implements INavigationService {
  final Map<String, GlobalKey<NavigatorState>> navigatorMap;

  NavigationService(this.navigatorMap);

  @override
  Future<T?> pushNamed<T, S>({required String routeName, String navigationFlow = 'normal', S? arguments}) {
    return navigatorMap[navigationFlow]!.currentState!.pushNamed(routeName, arguments: arguments);
  }

  @override
  Future<T?> pushNamedAndRemoveUntil<T, S>(
      {required String routeName, String navigationFlow = 'normal', S? arguments}) {
    return navigatorMap[navigationFlow]!
        .currentState!
        .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false, arguments: arguments);
  }

  @override
  void pop<T>({String navigationFlow = 'normal', T? arguments}) {
    return navigatorMap[navigationFlow]!.currentState!.pop(arguments);
  }

  @override
  void popUntil({required String routeName, String navigationFlow = 'normal', dynamic arguments}) {
    navigatorMap[navigationFlow]!.currentState!.popUntil((Route<void> r) => r.settings.name == routeName);
  }
}
