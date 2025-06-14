import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Costcenterpayrecieve {
  final String mode_of_payment = 'https://harakia.charterp.org/api/method/a_costcenter';

  // Helper function to make GET requests
  Future<List<dynamic>?> fetchcostcenterservice() async {
    final prefs = await SharedPreferences.getInstance();
    String? cookies = prefs.getString('erpnext_cookie');

    if (cookies != null) {
      try {
        HttpClient client = HttpClient();
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        IOClient ioClient = IOClient(client);

        final response = await ioClient.get(
          Uri.parse(mode_of_payment),
          headers: {
            'Cookie': cookies,
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> data = json.decode(response.body);
          return data['data'];  // Assuming 'data' contains the beneficiary list
        } else {
          print('Failed to fetch beneficiaries data from $mode_of_payment.');
          return null;
        }
      } catch (e) {
        print('Error fetching beneficiaries data: $e');
        return null;
      }
    } else {
      print("No session cookie found. Please log in again.");
      return null;
    }
  }
}
