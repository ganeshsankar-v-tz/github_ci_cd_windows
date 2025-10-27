import 'package:flutter/material.dart';

import '../main.dart';
/*

const String prefSelectedLanguageCode = 'SelectedLanguageCode';

Future<Locale> setLocale(String languageCode) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(prefSelectedLanguageCode, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String languageCode = prefs.getString(prefSelectedLanguageCode) ?? 'en';
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  return languageCode.isNotEmpty
      ? Locale(languageCode, '')
      : const Locale('en', '');
}
*/

// void changeLanguage(BuildContext context, String selectedLanguageCode) async {
//   final locale = await setLocale(selectedLanguageCode);
//   MyApp.setLocale(context, _locale);
// }
