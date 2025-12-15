import 'dart:convert';
import 'dart:io';
import 'package:chart_harakia/models/DashBoard.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String loginUrl = 'https://demoharakia.charterp.org/api/method/login';
  

  // Method to handle user login
  Future<String?> login(String username, String password) async {
    try {
      HttpClient client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      IOClient ioClient = IOClient(client);

      final response = await ioClient.post(
        Uri.parse(loginUrl),
        body: {'usr': username, 'pwd': password},
      );

      if (response.statusCode == 200) {
        final cookies = response.headers['set-cookie'];
        if (cookies != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('erpnext_cookie', cookies); // Save the cookie
          return null; // Successful login, no error
        } else {
          return 'Failed to retrieve session cookie.';
        }
      } else {
        return 'Failed to login. Please check your credentials.';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
