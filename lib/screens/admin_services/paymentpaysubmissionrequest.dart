
import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Paymentpaysubmissionrequest {
  final String Payment = 'https://harakia.charterp.org/api/resource/Payment Pay'; // URL encoded

  Future<bool> submitData(Map<String, dynamic> formData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cookie = prefs.getString('erpnext_cookie');

      if (cookie == null || cookie.isEmpty) {
        print("No cookie found. Please login first.");
        return false; // Or throw an exception if you prefer
      }

      HttpClient client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      IOClient ioClient = IOClient(client);

      final response = await ioClient.post(
        Uri.parse(Payment),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': cookie,
          'Expect': '',
        },
        body: json.encode(formData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) { // 201 Created is also a success code
        return true;
      } else {
        print('Failed to submit data. Status Code: ${response.statusCode} - Body: ${response.body}'); // Include body
        return false;
      }
    } catch (e) {
      print('Error submitting data: $e');
      return false;
    }
  }
}