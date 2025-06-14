import 'package:chart_harakia/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreenDoners extends StatefulWidget {
  @override
  _ProfileScreenDonersState createState() => _ProfileScreenDonersState();
}

class _ProfileScreenDonersState extends State<ProfileScreenDoners> {
  String? _username;
  String? _password;

  // Method to get saved login credentials from SharedPreferences
  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
      _password = prefs.getString('password');
    });
  }

  // Method to clear the saved credentials
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');

    // Navigate to the main screen
    Navigator.pushReplacementNamed(context, '/'); // Assuming '/' is your main screen route
  }

  @override
  void initState() {
    super.initState();
    _loadCredentials(); // Load credentials when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _username == null || _password == null
            ? Center(child: CircularProgressIndicator()) // Show loading indicator if credentials are not loaded yet
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Increased padding from the top
                  SizedBox(height: 200), // Increase padding here for more space
                  
                  // Profile Icon at the top of the body
                  CircleAvatar(
                    radius: 50, // Adjust the size of the icon
                    backgroundColor: MyColors.color, // Icon background color
                    child: Icon(
                      Icons.account_circle,
                      size: 60, // Icon size
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 40), // Add space between the icon and the fields

                  // Read-only TextFormField for username
                  TextFormField(
                    initialValue: _username,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Read-only TextFormField for password
                  TextFormField(
                    initialValue: _password,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 60),
                  // Logout button with custom text and background color
                  ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.color, // Set button background color
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white), // Set text color to white
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
