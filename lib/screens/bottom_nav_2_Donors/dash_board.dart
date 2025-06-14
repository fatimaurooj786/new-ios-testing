import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chart_harakia/services/user_profile_service.dart';

class DashboardScreenDoners extends StatefulWidget {
  @override
  _DashboardScreenDonersState createState() => _DashboardScreenDonersState();
}

class _DashboardScreenDonersState extends State<DashboardScreenDoners> {
  String _fullName = 'Loading...';
  List<dynamic> _beneficiaries = [];

  @override
  void initState() {
    super.initState();
    _loadFullName();
    _fetchBeneficiaries();
  }

  Future<void> _loadFullName() async {
    String fullName = await _extractFullName();
    if (!mounted) return; // Prevent setState after dispose
    setState(() {
      _fullName = fullName;
    });
  }

  Future<String> _extractFullName() async {
    final prefs = await SharedPreferences.getInstance();
    String? cookies = prefs.getString('erpnext_cookie');

    print('Retrieved Cookies: $cookies');

    if (cookies != null) {
      List<String> cookieParts = cookies.split(';');

      for (var part in cookieParts) {
        part = part.trim();

        if (part.contains('full_name=')) {
          int index = part.indexOf('full_name=');
          String fullNameSegment = part.substring(index);
          String fullNameEncoded = fullNameSegment.substring('full_name='.length);

          try {
            String fullNameDecoded = Uri.decodeComponent(fullNameEncoded);
            print('Full Name (URI Decoded): $fullNameDecoded');
            return fullNameDecoded;
          } catch (e) {
            print('URI Decode Error: $e');
            return fullNameEncoded;
          }
        }
      }
    }

    return 'No full name found';
  }

  Future<void> _fetchBeneficiaries() async {
    UserprofileService userProfileService = UserprofileService();
    List<dynamic>? beneficiaries = await userProfileService.fetchprofilegetservice();
    if (!mounted) return; // Prevent setState after dispose
    setState(() {
      _beneficiaries = beneficiaries ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredBeneficiaries = _beneficiaries.where((beneficiary) {
      return beneficiary['name1'] == _fullName;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Beneficiaries Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Full Name: $_fullName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Beneficiaries:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: filteredBeneficiaries.isEmpty
                  ? Center(child: Text('No beneficiaries found.'))
                  : ListView.builder(
                      itemCount: filteredBeneficiaries.length,
                      itemBuilder: (context, index) {
                        var beneficiary = filteredBeneficiaries[index];
                        String name = beneficiary['name'] ?? 'N/A';
                        String name1 = beneficiary['name1'] ?? 'N/A';
                        String contactNo = beneficiary['contact_no_1'] ?? 'N/A';
                        String email = beneficiary['email'] ?? 'N/A';

                        return Card(
                          child: ListTile(
                            title: Text(name1),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: $name'),
                                Text('Contact: $contactNo'),
                                Text('Email: $email'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
