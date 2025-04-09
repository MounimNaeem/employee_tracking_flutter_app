import 'dart:convert';
import 'package:employee_location_tracking_app/screens/auth/signup/models/user_model.dart';
import 'package:employee_location_tracking_app/utils/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static final SharedPrefsService _instance = SharedPrefsService._internal();
  
  factory SharedPrefsService() {
    return _instance;
  }

  SharedPrefsService._internal();

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // Store complete user model
  Future<void> setUserData(UserModel userData) async {
    final prefs = await _prefs;
    await prefs.setString(AppConstants.keyUserData, jsonEncode(userData.toJson()));
  }

  // Get complete user model
  Future<UserModel?> getUserData() async {
    final prefs = await _prefs;
    final userDataString = prefs.getString(AppConstants.keyUserData);
    if (userDataString != null) {
      return UserModel.fromJson(jsonDecode(userDataString));
    }
    return null;
  }

  // Check if user is logged in based on user model existence
  Future<bool> isLoggedIn() async {
    final userData = await getUserData();
    return userData != null;
  }

  // Clear user data
  Future<void> clearUserData() async {
    final prefs = await _prefs;
    await prefs.remove(AppConstants.keyUserData);
  }

  // Clear all data if needed
  Future<void> clearAllData() async {
    final prefs = await _prefs;
    await prefs.clear();
  }

  Future<void> setisUserOnline(bool isOnline) async {
    final prefs = await _prefs;
    await prefs.setBool(AppConstants.keyIsUserOnline, isOnline);
  }

  Future<bool> getisUserOnline() async {
    final prefs = await _prefs;
    return prefs.getBool(AppConstants.keyIsUserOnline) ?? false;
  }


   Future<void> setIsAdminBackgroundServiceOn(bool isActive) async {
    final prefs = await _prefs;
    await prefs.setBool(AppConstants.keyIsAdminBackgroundServiceOn, isActive);
  }

  Future<bool> getIsAdminBackgroundServiceOn() async {
    final prefs = await _prefs;
    return prefs.getBool(AppConstants.keyIsAdminBackgroundServiceOn) ?? false;
  }
}
