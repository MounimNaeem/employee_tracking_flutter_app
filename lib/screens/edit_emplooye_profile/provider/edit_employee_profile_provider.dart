import 'package:employee_location_tracking_app/screens/admin_dashboard/models/employee_list_model.dart';
import 'package:employee_location_tracking_app/screens/edit_emplooye_profile/services/edit_employee_service.dart';
import 'package:employee_location_tracking_app/utils/app_utils/app_utils.dart';
import 'package:employee_location_tracking_app/utils/enums/enums.dart';
import 'package:flutter/material.dart';

class EditEmployeeProfileProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  UserType? selectedUserType;

  bool isLoading = false;
  // bool get isLoading => _isLoading;

  void initialization(EmployeeListModel employee) {
    firstNameController.text = employee.firstName ?? '';
    lastNameController.text = employee.lastName ?? '';
    emailController.text = employee.email ?? '';
    phoneController.text = employee.phone ?? '';
    selectedUserType = employee.userType;
    notifyListeners();
  }

  void updateSelectedUserType(UserType? userType) {
    selectedUserType = userType;
    notifyListeners();
  }

  Future<void> updateEmployeeData(
      {required String userUid,
      required BuildContext context,
      required Function() onSuccess}) async {
    if (!formKey.currentState!.validate()) return;
    isLoading = true;
    notifyListeners();
    print('updateEmployeeData   ${selectedUserType?.name}');
    try {
      Map<String, dynamic> employee = {
        'firstName': firstNameController.text.trim(),
        'phone': phoneController.text.trim(),
        'user_type': selectedUserType?.name,
      };
      await EditEmployeeService().updateUserData(userUid, employee);
      await onSuccess();
      Navigator.pop(context);
      Navigator.pop(context);
      AppUtils.showSnackBar(
        context,
        message: 'Employee data updated successfully!',
      );
    } catch (e) {
      print('Error updating employee data: $e');
      AppUtils.showSnackBar(
        context,
        message: 'Failed to update employee data, please try again',
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteEmployee(BuildContext context, String userUid) async {
    isLoading = true;
    notifyListeners();
    try {
      await EditEmployeeService().deleteUserAccount(userUid: userUid);
      AppUtils.showSnackBar(
        context,
        message: 'Employee deleted successfully!',
      );
      isLoading = false;
      notifyListeners();
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      print('Error deleting employee: $e');
      AppUtils.showSnackBar(
        context,
        message: 'Failed to delete employee, please try again',
        isError: true,
      );
      isLoading = false;
      notifyListeners();
    }
  }
}
