import 'package:employee_location_tracking_app/screens/employee_history/models/employee_location_history_model.dart';
import 'package:employee_location_tracking_app/screens/employee_history/services/employee_history_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmployeeHistoryProvider extends ChangeNotifier {
  EmployeeHistoryService _employeeHistoryService = EmployeeHistoryService();
  List<DateHistory> userHistories = [];
  List<Location> filterLocationsByDate = [];
  String targetDate = '';

  bool isLoading = false;

  void loadHistories({required String userId}) async {
    showLoader(true);
    userHistories = await _employeeHistoryService.fetchAllHistories(userId);

    for (var history in userHistories) {
      print('Date: ${history.date}');
      for (var location in history.locations) {
        print('  Address: ${location.address}');
        print('  Lat/Lng: ${location.latitude}, ${location.longitude}');
        print('  Timestamp: ${location.timestamp}');
      }
    }
    filterLocations();
  }

  void filterLocations({String? selectedDate}) {
    showLoader(true);
    // Get today's date in YYYY-MM-DD format if no date is provided
    targetDate = selectedDate ?? DateTime.now().toIso8601String().split('T')[0];
    filterLocationsByDate.clear();
    // Find the history for the selected date
    final dateHistory = userHistories.firstWhere(
      (history) => history.date == targetDate,
      orElse: () => DateHistory(
          date: targetDate, locations: []), // Return empty if not found
    );
    filterLocationsByDate.addAll(dateHistory.locations);
    showLoader(false);
  }

  String formatDateTimeToTime(DateTime dateTime) {
    // Format the DateTime into "4:30 pm"
    return DateFormat.jm().format(dateTime);
  }

  void showLoader(bool loader) {
    isLoading = loader;
    notifyListeners();
  }
}
