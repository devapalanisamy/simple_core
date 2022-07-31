enum NavigationFlow { regular, home, more }

abstract class INavigationService {
  Future<T?> pushNamed<T, S>({required String routeName, String navigationFlow = 'normal', S? arguments});
  Future<T?> pushNamedAndRemoveUntil<T, S>({required String routeName, String navigationFlow = 'normal', S arguments});
  void pop<T>({String navigationFlow = 'normal', T? arguments});
  void popUntil({required String routeName, String navigationFlow = 'normal', dynamic arguments});
}
