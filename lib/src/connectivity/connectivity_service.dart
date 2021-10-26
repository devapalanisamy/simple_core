import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:simple_core/src/connectivity/i_connectivity_service.dart';
import 'package:simple_core/src/dialog/i_dialog_service.dart';
//import 'package:url_launcher/url_launcher.dart';

class ConnectivityService implements IConnectivityService {
  ConnectivityService(this._dialogService);

  final IDialogService _dialogService;
  @override
  Future<void> startConnectivityService(String bottomSheetType) async {
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult event) async {
      //final bool isInternetAvailable = await canLaunch('https://www.google.com/');
      if (event == ConnectivityResult.none) {
        await _dialogService.showBottomSheet(
          bottomSheetType: bottomSheetType,
          isDismissible: false,
        );
      } else {
        if (Get.isBottomSheetOpen!) {
          Navigator.pop(Get.context!);
        }
      }
    });
  }

  @override
  Future<bool> isInternetConnectionActive() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
    //return result != ConnectivityResult.none && (await canLaunch('https://www.google.com/'));
  }
}
