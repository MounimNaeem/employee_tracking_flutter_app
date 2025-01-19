import 'package:employee_location_tracking_app/screens/admin_dashboard/models/employee_list_model.dart';
import 'package:employee_location_tracking_app/utils/enums/enums.dart';
import 'package:flutter/material.dart';
import '../service/admin_dashboard_service.dart';

class AdminDashboardNotifier extends ChangeNotifier {
  final AdminDashboardService _service = AdminDashboardService();
  List<Map<String, dynamic>> _users = [];
  List<EmployeeListModel> employeeList = []; // <EmployeeList>
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Map<String, dynamic>> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAllUsers() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      employeeList.clear();
      _users = await _service.getAllUsers();
      if (_users != null && _users.isNotEmpty) {
        print(
            '*************************************************************** ');
        debugPrint(_users.toString());
        employeeList =
            _users.map((user) => EmployeeListModel.fromJson(user)).toList();
        employeeList.removeWhere((user) {
          return user.userType == UserType.admin;
        });
        // employeeList.addAll(rawEmployeeList);
        debugPrint(employeeList.length.toString());
        print(
            '***************************************************************');
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
