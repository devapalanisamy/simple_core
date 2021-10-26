abstract class IDialogService {
  Future<T> showAlert<T, S>({required String alertType, S? arguments, bool? barrierDismissiable});
  Future<T?> showBottomSheet<T, S>({required String bottomSheetType, bool? isDismissible, S? arguments});
  void showToast(String title, String message);
}
