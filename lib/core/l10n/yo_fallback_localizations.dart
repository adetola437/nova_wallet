import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Flutter ships no Material, Cupertino or Widgets translations for Yorùbá.
///
/// Without these delegates, switching the app to `yo` throws "No
/// MaterialLocalizations found" the moment a dialog, date picker or text field
/// builds. They serve the English framework strings under a `yo` locale; every
/// string NovaPay itself shows still comes from `app_yo.arb`.
class YoMaterialLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const YoMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'yo';

  @override
  Future<MaterialLocalizations> load(Locale locale) => GlobalMaterialLocalizations.delegate.load(const Locale('en'));

  @override
  bool shouldReload(covariant LocalizationsDelegate<MaterialLocalizations> old) => false;
}

class YoCupertinoLocalizationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const YoCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'yo';

  @override
  Future<CupertinoLocalizations> load(Locale locale) => GlobalCupertinoLocalizations.delegate.load(const Locale('en'));

  @override
  bool shouldReload(covariant LocalizationsDelegate<CupertinoLocalizations> old) => false;
}

class YoWidgetsLocalizationsDelegate extends LocalizationsDelegate<WidgetsLocalizations> {
  const YoWidgetsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'yo';

  @override
  Future<WidgetsLocalizations> load(Locale locale) => GlobalWidgetsLocalizations.delegate.load(const Locale('en'));

  @override
  bool shouldReload(covariant LocalizationsDelegate<WidgetsLocalizations> old) => false;
}
