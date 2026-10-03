import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../db/app_database.dart';
import '../features/language/domain/models/language_listing_model.dart';

class AppConstants {
  static const String title = 'Yenko';
  static const String baseUrl = 'https://yenkodrive.com/';

  static const String privacyPolicy = 'https://yenkodrive.com/privacy';
  static const String termsCondition = 'https://yenkodrive.com/terms';
  static const String officialWebsite = 'https://yenkodrive.com/';

  static LatLng currentLocations = const LatLng(0, 0);
  static List<LocaleLanguageList> languageList = [
    LocaleLanguageList(name: 'English', lang: 'en'),
    LocaleLanguageList(name: 'Arabic', lang: 'ar'),
    LocaleLanguageList(name: 'French', lang: 'fr'),
    LocaleLanguageList(name: 'Spanish', lang: 'es'),
  ];
}

Size size = const Size(0, 0);
AppDatabase db = AppDatabase();
