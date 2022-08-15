import 'package:core/src/firebase/fire_store/fire_store_service.dart';
import 'package:core/src/firebase/fire_store/i_fire_store_service.dart';
import 'package:core/src/firebase/firebase_auth/firebase_login_service.dart';
import 'package:core/src/firebase/firebase_auth/i_login_service.dart';
import 'package:core/src/navigation/i_navigation_service.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:core/src/connectivity/connectivity_service.dart';
import 'package:core/src/connectivity/i_connectivity_service.dart';
import 'package:core/src/dialog/i_dialog_service.dart';
import 'package:core/src/localization/i_localization_service.dart';
import 'package:core/src/localization/localization_service.dart';
import 'package:core/src/network/i_rest_client.dart';
import 'package:core/src/network/rest_client.dart';
import 'package:core/src/storage/i_storage_service.dart';
import 'package:core/src/storage/storage_service.dart';

final GetIt diContainer = GetIt.instance;

void registerEssentialServices() {
  diContainer.registerLazySingleton<Client>(() => Client());
  diContainer.registerLazySingleton<IRestClient>(
    () => RestClient(diContainer<Client>()),
  );
  diContainer.registerLazySingleton<IStorageService>(() => StorageService());

  diContainer.registerLazySingleton<ILocalizationService>(() => LocalizationService());
  diContainer.registerLazySingleton<IConnectivityService>(() => ConnectivityService(diContainer<IDialogService>()));
  diContainer.registerLazySingleton<IFireStoreService>(() => FireStoreService());
  diContainer.registerLazySingleton<ILoginService>(
    () => FirebaseLoginService(
      diContainer<IStorageService>(),
      diContainer<INavigationService>(),
      diContainer<IFireStoreService>(),
    ),
  );
}
