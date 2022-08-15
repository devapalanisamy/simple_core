abstract class ILoginService {
  Future<bool> sendEmailForPasswordlessSignIn({required String email});
  Future<void> initDynamicLinks();
  Stream<bool> get startLoginProcessStream;
  Future<bool> getLoggedInStatus();
  Future<bool> logout(String logoutPath);
  void monitorAuthState(String logoutPath);
}
