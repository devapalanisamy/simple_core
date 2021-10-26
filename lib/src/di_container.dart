import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:simple_core/src/connectivity/connectivity_service.dart';
import 'package:simple_core/src/connectivity/i_connectivity_service.dart';
import 'package:simple_core/src/dialog/i_dialog_service.dart';
import 'package:simple_core/src/localization/i_localization_service.dart';
import 'package:simple_core/src/localization/localization_service.dart';
import 'package:simple_core/src/navigation/i_navigation_service.dart';
import 'package:simple_core/src/navigation/navigation_service.dart';
import 'package:simple_core/src/network/i_rest_client.dart';
import 'package:simple_core/src/network/rest_client.dart';
import 'package:simple_core/src/storage/i_storage_service.dart';
import 'package:simple_core/src/storage/storage_service.dart';

final GetIt diContainer = GetIt.instance;

void registerEssentialServices() {
  diContainer.registerLazySingleton<Client>(() => Client());
  diContainer.registerLazySingleton<IRestClient>(
    () => RestClient(diContainer<Client>()),
  );
  diContainer.registerLazySingleton<IStorageService>(() => StorageService());
  diContainer
      .registerLazySingleton<INavigationService>(() => NavigationService());
  diContainer
      .registerLazySingleton<ILocalizationService>(() => LocalizationService());
  diContainer.registerLazySingleton<IConnectivityService>(
      () => ConnectivityService(diContainer<IDialogService>()));
}
