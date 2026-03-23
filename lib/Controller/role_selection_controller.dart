import 'package:get/get.dart';

class RoleSelectionController extends GetxController {
  var selectedRole = ''.obs;

  void selectRole(String role) {
    selectedRole.value = role;
  }
  
  bool get isRoleSelected => selectedRole.value.isNotEmpty;
}
