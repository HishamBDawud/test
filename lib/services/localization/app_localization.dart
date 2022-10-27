import 'dart:convert';
import 'dart:developer';

import 'package:cleanapp/services/authintication/domain/usecases/read_storage.dart';
import 'package:cleanapp/services/authintication/domain/usecases/write_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';

class Applocalizations {
  final Locale? locale;
  Applocalizations({this.locale});

  static Applocalizations? of(BuildContext context) {
    return Localizations.of<Applocalizations>(context, Applocalizations);
  }

  static LocalizationsDelegate<Applocalizations> delegate =
      _AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  Future loadJsonLanguage() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    final token = await storage.read(key: "accessToken");
    log(token.toString());
    if (token != null) {
      var headers = {
        "LangId": locale!.languageCode,
        'Authorization': 'Bearer $token'
      };

      var url = Uri.https(base, path4);
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        if (locale!.languageCode == 'en') {
          final value = json.decode(response.body);
          List<dynamic> responseList;
          responseList = value;
          Map<String, String> myMap1 = {};
          for (var x = 0; x < responseList.length; x++) {
            var key = responseList[x]['resourceName'].toString();
            var value = responseList[x]['textEn'].toString();
            myMap1[key] = value;
          }
          _localizedStrings = myMap1;
        } else {
          final value = json.decode(response.body);
          List<dynamic> responseList;
          responseList = value;
          Map<String, String> myMap1 = {};
          for (var x = 0; x < responseList.length; x++) {
            var key = responseList[x]['resourceName'].toString();
            var value = responseList[x]['textAr'].toString();
            myMap1[key] = value;
          }
          _localizedStrings = myMap1;
        }
      } else {
        log('error');
      }
    } else {
      String jsonString = await rootBundle
          .loadString("assets/lang/${locale!.languageCode}.json");
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
    }

    log(_localizedStrings.toString());
    return true;
  }

  String translate(String key) => _localizedStrings[key] ?? "";
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<Applocalizations> {
  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<Applocalizations> load(Locale locale) async {
    Applocalizations localizations = Applocalizations(locale: locale);
    await localizations.loadJsonLanguage();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<Applocalizations> old) =>
      false;
}

extension TranslateX on String {
  String tr(BuildContext context) {
    return Applocalizations.of(context)!.translate(this);
  }
}
