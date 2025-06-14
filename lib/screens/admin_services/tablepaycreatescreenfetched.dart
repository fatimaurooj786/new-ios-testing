import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tablepaycreatescreenfetched {
  final String tableaccount = 'https://harakia.charterp.org/api/method/Group_zero';

  /// Fetches the list of Party Types from the backend.
  /// Returns a list of maps like: [{ "name": "Donor" }, { "name": "Student" }, ...]
  Future<List<Map<String, dynamic>>?> fetcbAccounttable() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? cookies = prefs.getString('erpnext_cookie');

      if (cookies == null) {
        print("No session cookie found. Please log in again.");
        return null;
      }

      HttpClient client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      IOClient ioClient = IOClient(client);

      final response = await ioClient.get(
        Uri.parse(tableaccount),
        headers: {
          'Cookie': cookies,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        print('Failed to fetch party types. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching party types: $e');
      return null;
    }
  }
}
