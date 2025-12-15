import 'package:chart_harakia/screens/bottom_nav_1_Administrator/home_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:chart_harakia/widgets/colors.dart';
import 'package:chart_harakia/services/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  final AuthService _authService = AuthService();

  Future<void> saveLoginCredentials(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  Future<String> _extractFullName() async {
    final prefs = await SharedPreferences.getInstance();
    String? cookies = prefs.getString('erpnext_cookie');

    print('Retrieved Cookies: $cookies'); // Debug output

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
            print('Decoded Full Name: $fullNameDecoded');
            return fullNameDecoded;
          } catch (e) {
            print('Decode error: $e');
            return fullNameEncoded;
          }
        }
      }
    }

    return 'No full name found';
  }

  Future<void> login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final errorMessage = await _authService.login(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (errorMessage != null) {
      setState(() {
        if (errorMessage == 'Invalid username or password') {
          _errorMessage = 'اسم المستخدم أو كلمة المرور غير صحيحة';
        } else {
          _errorMessage = 'حدث خطأ أثناء تسجيل الدخول، حاول مرة أخرى';
        }
      });
    } else {
      await saveLoginCredentials(_usernameController.text, _passwordController.text);
      String fullName = await _extractFullName();

      // Navigate to Administrator Home Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreenAdmin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBarColor = MyColors.color;

    return Scaffold(
      appBar: AppBar(
        title: Text('', style: TextStyle(color: Colors.white)),
        backgroundColor: appBarColor,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 03,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    Image.asset('assets/images/logo.png', width: 50, height: 50),
                    SizedBox(width: 10),
                    Text(
                      'Chart Harakia',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: MyColors.color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  'مرحبًا بك! 👋',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                Text(
                  'يرجى تسجيل الدخول للمتابعة',
                  style: TextStyle(color: Color.fromARGB(255, 106, 104, 104), fontSize: 15),
                ),
                SizedBox(height: 40),
                Text(
                  'اسم المستخدم',
                  style: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  style: TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: 'ادخل اسم المستخدم',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: MyColors.color),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'كلمة المرور',
                  style: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  style: TextStyle(fontSize: 12),
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: 'ادخل كلمة المرور',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: MyColors.color),
                    ),
                    suffixIcon: IconButton(
                      color: MyColors.color,
                      iconSize: 20.0,
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'هل استلمت اسم المستخدم وكلمة المرور من مؤسستك؟',
                  style: TextStyle(
                    fontSize: 12,
                    color: MyColors.color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 60),
                Center(
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: MyColors.color,
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 120.0,
                            ),
                          ),
                          child: Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
