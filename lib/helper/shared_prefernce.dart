import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesHelper {
  static const String _userDataKey = 'userData';
  static const String _isLoggedInKey = 'isLoggedIn';
  String? username;

  // Method to store user data
  static Future<void> storeUserData(Map<String, dynamic> userData) async {
    print('this is user data $userData');
    final prefs = await SharedPreferences.getInstance();
    String userDataJson = json.encode(userData);
    await prefs.setString(_userDataKey, userDataJson);
  }

  // Method to retrieve user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userDataJson = prefs.getString(_userDataKey);
   
    if (userDataJson != null) {
      return json.decode(userDataJson);
    }
    return null;
  }

  // Method to remove user data
  static Future<void> removeUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDataKey);
  }
static Future<void> logout() async {
  removeUserData();
  setLoginState(false);
   
  }

  // Method to set login state
  static Future<void> setLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  // Method to get login state
  static Future<bool> getLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }
}
