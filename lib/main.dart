import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omniai/View/Screen/SplashScreen/splash_screen.dart';
import 'package:omniai/Utils/StaticString/static_string.dart';
import 'package:omniai/Utils/Localization/translations.dart';
import 'package:omniai/View/Screen/LanguageSelection/Controller/language_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(LanguageController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: StaticStrings.appName,
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: const Locale('en', 'US'), // Default locale
      fallbackLocale: const Locale('en', 'US'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
