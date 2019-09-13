import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // static inheritedWidget of
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLoclazitionsDelegate();

  // ----------------------

  Map<String,String> _localizedStrings;

  Future<bool> load () async {

    String jsonFileAsString = await rootBundle.loadString('langs/${locale.languageCode}.json');
    Map<String,dynamic> jsonMap =json.decode(jsonFileAsString);

    _localizedStrings = jsonMap.map((key,value){
      return MapEntry(key,value);
    });
    return true;
  }

String translate(String key){

    return   _localizedStrings[key] ?? _localizedStrings['error_key'];
}

} // **********************

class _AppLoclazitionsDelegate extends LocalizationsDelegate<AppLocalizations> {
  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = new AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => true;

// This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLoclazitionsDelegate();
} // ******************
