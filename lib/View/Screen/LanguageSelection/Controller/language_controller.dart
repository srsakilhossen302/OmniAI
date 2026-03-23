import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  static const String languageKey = 'language_code';
  static const String countryKey = 'country_code';

  var selectedLanguage = 'English'.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedLanguage();
  }

  void changeLanguage(String langCode, String countryCode, String langName) async {
    var locale = Locale(langCode, countryCode);
    Get.updateLocale(locale);
    selectedLanguage.value = langName;
    
    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageKey, langCode);
    await prefs.setString(countryKey, countryCode);
  }

  void loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString(languageKey);
    String? countryCode = prefs.getString(countryKey);

    if (langCode != null && countryCode != null) {
      Get.updateLocale(Locale(langCode, countryCode));
      
      // Update the display name accordingly
      if (langCode == 'bn') {
        selectedLanguage.value = 'বাংলা';
      } else if (langCode == 'hi') {
        selectedLanguage.value = 'हिन्दी';
      } else {
        selectedLanguage.value = 'English';
      }
    }
  }
}
