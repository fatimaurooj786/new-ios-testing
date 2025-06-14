import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PartyService {
  final String customer = 'https://harakia.charterp.org/api/method/a_customer';
  final String donor = 'https://harakia.charterp.org/api/method/a_donor';
  final String students    =   'https://harakia.charterp.org/api/method/a_student';
 final String supplier    =   'https://harakia.charterp.org/api/method/a_supplier';
 final String employee    =   'https://harakia.charterp.org/api/method/a_employee';
 final String public_party    =   'https://harakia.charterp.org/api/method/p_party';
 final String shareholder    =   'https://harakia.charterp.org/api/method/a_share';
 final String member    =   'https://harakia.charterp.org/api/method/a_member';


  /// Fetches the list of Party Types from the backend.
  /// Returns a list of maps like: [{ "name": "Donor" }, { "name": "Student" }, ...]
  Future<List<Map<String, dynamic>>?> fetchParty() async {
    return _fetchDataFromApi(customer);
  }

  Future<List<Map<String, dynamic>>?> fetchstudents() async {
    return _fetchDataFromApi(students);
  }

  /// Fetches the list of Donors from the backend.
  /// Returns a list of maps like: [{ "name": "الشيخ فهد بن سيبان السلمي" }, ...]
  Future<List<Map<String, dynamic>>?> fetchDonors() async {
    return _fetchDataFromApi(donor);
  }


Future<List<Map<String, dynamic>>?> fetchsupplier() async {
    return _fetchDataFromApi(supplier);
  }

  Future<List<Map<String, dynamic>>?> fetchempployee() async {
    return _fetchDataFromApi(employee);
  }

   Future<List<Map<String, dynamic>>?> fetchpublicparty() async {
    return _fetchDataFromApi(public_party);
  }
   Future<List<Map<String, dynamic>>?> fetchpublicshareholder() async {
    return _fetchDataFromApi(shareholder);
  }
  Future<List<Map<String, dynamic>>?> fetchmember() async {
    return _fetchDataFromApi(member);
  }

  /// Shared method to fetch data from a given API endpoint.
  Future<List<Map<String, dynamic>>?> _fetchDataFromApi(String url) async {
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
        Uri.parse(url),
        headers: {
          'Cookie': cookies,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        print('Failed to fetch data from $url. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching data from $url: $e');
      return null;
    }
  }
}
