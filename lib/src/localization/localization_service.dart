import 'package:flutter/cupertino.dart';
import 'package:simple_core/src/localization/i_localization_service.dart';
import 'package:simple_core/src/localization/localizer.dart';

class LocalizationService implements ILocalizationService {
  late BuildContext context;
  @override
  String translate(String key) {
    return Localizer.of(context)!.translate(key);
  }
}
