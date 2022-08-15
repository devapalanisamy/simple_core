import 'dart:async';
import 'dart:io';

import 'package:core/core.dart';
import 'package:core/src/constants/constants.dart';
import 'package:core/src/firebase/fire_store/i_fire_store_service.dart';
import 'package:core/src/firebase/firebase_auth/i_login_service.dart';
import 'package:core/src/logger/custom_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FirebaseLoginService extends ILoginService {
  FirebaseLoginService(this._storageService, this._navigationService, this._fireStoreService);
  final IFireStoreService _fireStoreService;

  final INavigationService _navigationService;
  final IStorageService _storageService;
  late StreamSubscription<PendingDynamicLinkData> dynamicLinksSubscription;
  final FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  final StreamController<bool> _startLoginProcessController = StreamController<bool>.broadcast();
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  final Logger logger = getLogger();

  @override
  Future<bool> sendEmailForPasswordlessSignIn({required String email}) async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    ActionCodeSettings? acs;
    final String url = 'https://imonkapp.page.link/auth1?email=$email';

    if (Platform.isIOS) {
      acs = ActionCodeSettings(
        url: url,
        handleCodeInApp: true,
        iOSBundleId: info.packageName,
      );
    } else if (Platform.isAndroid) {
      acs = ActionCodeSettings(
        url: url,
        handleCodeInApp: true,
        androidPackageName: info.packageName,
        androidInstallApp: true,
        androidMinimumVersion: '12',
      );
    }
    try {
      await _authInstance.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: acs!,
      );
    } on FirebaseAuthException catch (fae) {
      throw Exception(fae.toString());
    }
    return true;
  }

  Future<bool> _verifyPasswordlessSignIn({required String email, required String url}) async {
    final bool validLink = _authInstance.isSignInWithEmailLink(url);
    if (validLink) {
      try {
        final UserCredential credential = await _authInstance.signInWithEmailLink(email: email, emailLink: url);
        if (credential.user != null) {
          await _storageService.setEncryptedValue<bool>(key: Constants.isLoggedIn, value: true);
          logger.d(credential.toString());
          await _fireStoreService
              .addDocument('users', <String, String>{'email': email, 'userId': credential.user!.uid});
          return true;
        }
        return false;
      } catch (e) {
        logger.d(e);
      }
    }
    return false;
  }

  @override
  Future<void> initDynamicLinks() async {
    bool result = false;
    final String? email = await _storageService.getEncryptedValue<String>(key: Constants.email);
    if (email == null) {
      return;
    }
    final bool isSignedIn = await getLoggedInStatus();
    if (isSignedIn) {
      return;
    }
    dynamicLinksSubscription = dynamicLinks.onLink.listen((PendingDynamicLinkData dynamicLinkData) async {
      final String link = dynamicLinkData.link.toString();
      logger.d(link);
      result = await _verifyPasswordlessSignIn(email: email, url: link);
      logger.d('_verifyPasswordlessSignIn result: $result');
      _startLoginProcessController.add(result);
      dynamicLinksSubscription.cancel();
    });
  }

  @override
  Stream<bool> get startLoginProcessStream => _startLoginProcessController.stream;

  @override
  Future<bool> getLoggedInStatus() async {
    try {
      final bool? isLoggedIn = await _storageService.getEncryptedValue<bool>(key: Constants.isLoggedIn);
      logger.d('user: ${_authInstance.currentUser}');
      await _authInstance.currentUser?.reload();
      return (isLoggedIn ?? false) && _authInstance.currentUser != null;
    } on Exception catch (e) {
      logger.d(e);
      return false;
    }
  }

  @override
  Future<bool> logout(String logoutPath) async {
    await _authInstance.signOut();
    await _storageService.setEncryptedValue<bool>(key: Constants.isLoggedIn, value: false);
    await _navigationService.pushNamedAndRemoveUntil<void, void>(routeName: logoutPath);
    return true;
  }

  @override
  void monitorAuthState(String logoutPath) {
    _authInstance.authStateChanges().listen((User? user) async {
      if (user == null) {
        await logout(logoutPath);
      }
    });
  }
}
