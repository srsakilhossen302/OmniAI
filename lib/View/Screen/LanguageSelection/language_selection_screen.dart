import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Utils/AppColors/app_colors.dart';
import '../CountrySelection/country_selection_screen.dart';
import 'Controller/language_controller.dart';

class LanguageSelectionScreen extends GetView<LanguageController> {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.splashGradientStart,
              AppColors.splashGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Icon(
                Icons.language_outlined,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              Text(
                'choose_language'.tr,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'আপনার ভাষা নির্বাচন করুন', // Always Bangla for clarity
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 50),
              _buildLanguageCard(context, 'বাংলা', 'bn', 'BD', '🇧🇩'),
              _buildLanguageCard(context, 'English', 'en', 'US', '🇺🇸'),
              _buildLanguageCard(context, 'हिन्दी', 'hi', 'IN', '🇮🇳'),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CountrySelectionScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryColor,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'get_started'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(
    BuildContext context,
    String langName,
    String langCode,
    String countryCode,
    String flag,
  ) {
    return Obx(() {
      bool isSelected = controller.selectedLanguage.value == langName;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.3)
              : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white24,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 8,
          ),
          leading: Text(flag, style: const TextStyle(fontSize: 32)),
          title: Text(
            langName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            langName == 'বাংলা'
                ? 'Bangla'
                : (langName == 'हिन्दी' ? 'Hindi' : 'English'),
            style: const TextStyle(color: Colors.white70),
          ),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: Colors.white)
              : const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 16,
                ),
          onTap: () {
            controller.changeLanguage(langCode, countryCode, langName);
          },
        ),
      );
    });
  }
}
