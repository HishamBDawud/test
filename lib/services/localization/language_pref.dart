import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String LAGUAGE_CODE = 'languageCode';
const String ENGLISH = 'en';
const String ARABIC = 'ar';
Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode = prefs.getString(LAGUAGE_CODE) ?? ENGLISH;
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, 'EN');
    case ARABIC:
      return const Locale(ARABIC, "AR");
    default:
      return const Locale(ENGLISH, 'EN');
  }
}
