import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardService {
  final String totalUrl = 'https://harakia.charterp.org/api/method/total'; // URL to fetch data

  Future<Map<String, dynamic>?> fetchBeneficiariesCount() async {
    final prefs = await SharedPreferences.getInstance();
    String? cookies = prefs.getString('erpnext_cookie'); // Get the saved session cookie

    if (cookies != null) {
      try {
        HttpClient client = HttpClient();
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        IOClient ioClient = IOClient(client);

        final response = await ioClient.get(
          Uri.parse(totalUrl),
          headers: {'Cookie': cookies}, // Pass the cookies to authenticate the request
        );

        if (response.statusCode == 200) {
          return json.decode(response.body); // Parse and return the response body
        } else {
          return null; // Return null in case of failed request
        }
      } catch (e) {
        print('Error fetching beneficiaries count: $e');
        return null;
      }
    } else {
      print("No session cookie found. Please log in again.");
      return null;
    }
  }
}
