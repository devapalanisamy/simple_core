import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Localizer {
  Localizer(this.locale);
  final Locale locale;

  static Localizer? of(BuildContext context) => Localizations.of<Localizer>(context, Localizer);

  static const LocalizationsDelegate<Localizer> delegate = _LocalizerDelegate();

  late Map<String, String> _localizedStrings;

  Future<bool> loadLanguageFromFile() async {
    final String jsonString = await rootBundle
        .loadString('assets/languages/${locale.languageCode}_${locale.countryCode!.toLowerCase()}.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((String key, dynamic value) => MapEntry<String, String>(key, value.toString()));

    return true;
  }

  String translate(String key) => _localizedStrings[key] ?? key;
}

class _LocalizerDelegate extends LocalizationsDelegate<Localizer> {
  const _LocalizerDelegate();

  @override
  bool isSupported(Locale locale) {
    return <String>['en'].contains(locale.languageCode);
  }

  @override
  Future<Localizer> load(Locale locale) async {
    final Localizer localizer = Localizer(locale);
    await localizer.loadLanguageFromFile();
    return localizer;
  }

  @override
  bool shouldReload(_LocalizerDelegate locale) {
    return false;
  }
}
