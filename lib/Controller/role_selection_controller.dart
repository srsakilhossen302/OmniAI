import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoleSelectionController extends GetxController {
  var selectedRole = ''.obs;
  var selectedClass = ''.obs;
  var customClass = ''.obs;
  var selectedSemester = ''.obs;
  var selectedDepartment = ''.obs;
  var selectedGroup = ''.obs;
  var profession = ''.obs;
  var countryCode = ''.obs; // Start empty to force update

  @override
  void onInit() {
    super.onInit();
    print("RoleSelectionController initialized");
    // Worker to react to country changes
    ever(countryCode, (_) => updateClassOptions());
    _loadCountry();
  }

  Future<void> _loadCountry() async {
    final prefs = await SharedPreferences.getInstance();
    String savedCode = prefs.getString('selected_country_code') ?? 'BD';
    print("Loaded Country Code: $savedCode");
    countryCode.value = savedCode.toUpperCase();
    updateClassOptions();
  }

  var classOptions = <String>[].obs;

  void updateClassOptions() {
    final code = countryCode.value;
    print("Updating class options for: $code");
    if (code == 'BD') {
      classOptions.assignAll([
        'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10',
        'Class 11 (HSC 1st Year)', 'Class 12 (HSC 2nd Year)',
        'Honors', 'Masters', 'diploma', 'others'
      ]);
    } else if (code == 'US') {
      classOptions.assignAll([
        'Elementary School (Grade 1-5)',
        'Middle School (Grade 6-8)',
        'High School (Grade 9-12)',
        'College / University',
        'others'
      ]);
    } else {
      // Default / International (covering other countries like India, UK, etc.)
      classOptions.assignAll([
        'Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5',
        'Grade 6', 'Grade 7', 'Grade 8', 'Grade 9', 'Grade 10',
        'Grade 11', 'Grade 12', 'Bachelor', 'Master', 'others'
      ]);
    }
  }

  final List<String> groupOptions = ['science', 'commerce', 'humanities'];

  final List<String> departmentOptions = [
    'Computer', 'Civil', 'Electrical', 'Mechanical', 'Electronics',
    'Power', 'Textile', 'Architecture', 'Automobile', 'others'
  ];

  final List<String> semesterOptions = [
    '1st Semester', '2nd Semester', '3rd Semester', '4th Semester',
    '5th Semester', '6th Semester', '7th Semester', '8th Semester',
  ];

  void selectRole(String role) {
    selectedRole.value = role;
    if (role != 'student') {
      _resetStudentFields();
    }
  }

  void selectClass(String? className) {
    selectedClass.value = className ?? '';
    _resetStudentFields(exceptClass: true);
  }

  void _resetStudentFields({bool exceptClass = false}) {
    if (!exceptClass) selectedClass.value = '';
    selectedSemester.value = '';
    selectedDepartment.value = '';
    selectedGroup.value = '';
    customClass.value = '';
    profession.value = '';
  }

  void selectDepartment(String? dept) {
    selectedDepartment.value = dept ?? '';
    selectedSemester.value = '';
  }

  void selectSemester(String? semester) {
    selectedSemester.value = semester ?? '';
  }

  void selectGroup(String? group) {
    selectedGroup.value = group ?? '';
  }

  bool get isRoleSelected => selectedRole.value.isNotEmpty;
  bool get isStudent => selectedRole.value == 'student';
  bool get isOthersSelected => selectedClass.value.toLowerCase() == 'others';
  bool get isDiplomaSelected => selectedClass.value.toLowerCase() == 'diploma';
  
  bool get showGroupSelection {
    if (countryCode.value != 'BD') return false;
    final sc = selectedClass.value;
    return sc == 'Class 9' || sc == 'Class 10' || 
           sc == 'Class 11 (HSC 1st Year)' || sc == 'Class 12 (HSC 2nd Year)';
  }

  bool get canContinue {
    if (!isRoleSelected) return false;
    if (selectedRole.value == 'job_holder') {
      return profession.value.isNotEmpty;
    }
    if (isStudent) {
      if (selectedClass.value.isEmpty) return false;
      if (isOthersSelected && customClass.value.isEmpty) return false;
      if (isDiplomaSelected) {
        if (selectedDepartment.value.isEmpty) return false;
        if (selectedSemester.value.isEmpty) return false;
      }
      if (showGroupSelection && selectedGroup.value.isEmpty) return false;
    }
    return true;
  }
}
