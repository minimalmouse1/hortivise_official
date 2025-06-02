import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:horti_vige/constants.dart';
import 'package:horti_vige/core/utils/helpers/preference_manager.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Environment detection
  static bool get isPhysicalDevice {
    // This is a simple check - you might want to use device_info_plus for more accurate detection
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }

  // Configure base URL based on platform and environment
  static String get baseUrl {
    // In production, use production URL
    return ApiConstants.productionBaseUrl;
  //  return ApiConstants.productionFullBaseUrl;


  }

  static Future<String?> loginAndGetToken() async {
    try {
      //final url = '$baseUrl/auth/login';
      const url = ApiConstants.productionFullBaseUrl;
      print('Attempting to connect to: $url');

      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "email": "admin@hortivise.com",
              "password": "123456",
            }),
          )
          .timeout(const Duration(seconds: 10)); // Add timeout

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['result']['token'];
        print('Login successful, token received');

        // Save token to preferences for future use
        await PreferenceManager.getInstance().saveAuthToken(token);

        return token;
      } else {
        print(
            'Login failed with status ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      print(
          'Make sure your backend server is running on port ${ApiConstants.apiPort}');
      if (Platform.isAndroid) {
        print(
            'For Android emulator, server should be accessible at 10.0.2.2:${ApiConstants.apiPort}');
      } else if (Platform.isIOS) {
        print(
            'For iOS simulator, server should be accessible at localhost:${ApiConstants.apiPort}');
      }
      return null;
    }
  }

  // Get stored authentication token
  static String? getStoredToken() {
    return PreferenceManager.getInstance().getAuthToken();
  }

  // Check if user is authenticated (has valid token)
  static bool isAuthenticated() {
    final token = getStoredToken();
    return token != null && token.isNotEmpty;
  }

  // Clear stored authentication token (for logout)
  static Future<bool> clearAuthToken() {
    return PreferenceManager.getInstance().deleteAuthToken();
  }

  // Test API connection
  static Future<bool> testApiConnection() async {
    try {
      final response = await http
          .get(Uri.parse(baseUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('API Connection successful: ${data['message']}');
        return true;
      } else {
        print('API Connection failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error testing API connection: $e');
      return false;
    }
  }
}
