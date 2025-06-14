import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentRecieveGet {
  final String Payment_recieve_get= 'https://harakia.charterp.org/api/method/get_payment_recieve';

  // Helper function to make GET requests
  Future<List<dynamic>?> fetchpaymentrecievegetservice() async {
    final prefs = await SharedPreferences.getInstance();
    String? cookies = prefs.getString('erpnext_cookie');

    if (cookies != null) {
      try {
        HttpClient client = HttpClient();
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        IOClient ioClient = IOClient(client);

        final response = await ioClient.get(
          Uri.parse(Payment_recieve_get),
          headers: {
            'Cookie': cookies,
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> data = json.decode(response.body);
          return data['data'];  // Assuming 'data' contains the beneficiary list
        } else {
          print('Failed to fetch beneficiaries data from $Payment_recieve_get.');
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
