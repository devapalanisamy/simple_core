import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_core/src/dialog/i_dialog_service.dart';

class DialogService implements IDialogService {
  DialogService({required this.getAlert, required this.getBottomSheet});
  final Widget Function<S>({required String alertType, S? arguments}) getAlert;
  final Widget Function<S>({required String bottomsheetType, S? arguments})
      getBottomSheet;

  @override
  Future<T> showAlert<T, S>(
      {required String alertType,
      S? arguments,
      bool? barrierDismissiable}) async {
    final Widget widget = getAlert(alertType: alertType, arguments: arguments);
    return await Get.dialog(
      widget,
      barrierDismissible: barrierDismissiable ?? true,
    );
  }

  @override
  Future<T?> showBottomSheet<T, S>(
      {required String bottomSheetType,
      bool? isDismissible,
      S? arguments}) async {
    final Widget widget = getBottomSheet<S>(
        bottomsheetType: bottomSheetType, arguments: arguments);
    return Get.bottomSheet(
      widget,
      useRootNavigator: false,
      isScrollControlled: true,
      isDismissible: isDismissible ?? true,
      enableDrag: isDismissible ?? true,
    );
  }

  @override
  void showToast(String title, String message) {
    Get.snackbar(title, message, snackPosition: SnackPosition.BOTTOM);
  }
}
