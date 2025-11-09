import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_logged_data.dart';

/// Service to handle authentication and user session management
class AuthService {
  static const String _userDataKey = 'userloggeddata';

  /// Save user data to shared preferences
  static Future<bool> saveUserData(UserLoggedData userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(userData.toJson());
      return await prefs.setString(_userDataKey, jsonString);
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }

  /// Get user data from shared preferences
  static Future<UserLoggedData?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_userDataKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return null;
      }

      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserLoggedData.fromJson(jsonMap);
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final userData = await getUserData();
    return userData != null && userData.accessToken.isNotEmpty;
  }

  /// Clear user data (logout)
  static Future<bool> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_userDataKey);
    } catch (e) {
      print('Error clearing user data: $e');
      return false;
    }
  }

  /// Clear all caches (user data, roadmap, mentors, profile, requests)
  static Future<void> clearAllCaches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Clear user authentication data
      await prefs.remove(_userDataKey);
      
      // Clear roadmap cache
      await prefs.remove('roadmap_cache');
      await prefs.remove('roadmap_cache_timestamp');
      
      // Clear mentors cache
      await prefs.remove('mentors_cache');
      await prefs.remove('mentors_cache_timestamp');
      
      // Clear profile cache
      await prefs.remove('profile_cache');
      await prefs.remove('profile_cache_timestamp');
      
      // Clear received requests cache (for mentors)
      await prefs.remove('received_requests_cache');
      await prefs.remove('received_requests_cache_timestamp');
      
      print('All caches cleared successfully');
    } catch (e) {
      print('Error clearing all caches: $e');
    }
  }

  /// Get access token
  static Future<String?> getAccessToken() async {
    final userData = await getUserData();
    return userData?.accessToken;
  }

  /// Get authorization header
  static Future<String?> getAuthorizationHeader() async {
    final userData = await getUserData();
    if (userData == null) return null;
    
    return '${userData.tokenType} ${userData.accessToken}';
  }
}

