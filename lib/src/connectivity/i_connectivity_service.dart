abstract class IConnectivityService {
  void startConnectivityService(String bottomSheetType);
  Future<bool> isInternetConnectionActive();
}
