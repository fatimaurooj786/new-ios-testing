import 'dart:math';
import 'package:chart_harakia/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreenAdmin extends StatefulWidget {
  @override
  _ProfileScreenAdminState createState() => _ProfileScreenAdminState();
}

class _ProfileScreenAdminState extends State<ProfileScreenAdmin> {
  String? _username;
  String? _password;
  Color _profilePicBorderColor = MyColors.color;
  Color _cardBorderColor = MyColors.color;

  // Method to get saved login credentials from SharedPreferences
  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final loginTimeStr = prefs.getString('loginTime');

    if (loginTimeStr != null) {
      final loginTime = DateTime.parse(loginTimeStr);
      final now = DateTime.now();

      // Check if 24 hours have passed since login
      if (now.difference(loginTime).inHours >= 24) {
        await _logout(); // Auto logout
        return;
      }
    }

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
    await prefs.remove('loginTime'); // Remove timestamp

    Navigator.pushReplacementNamed(context, '/'); // Navigate to login/main screen
  }

  // Method to generate a random color
  Color _generateRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  // Method to change border colors periodically
  void _changeBorderColors() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _profilePicBorderColor = _generateRandomColor();
          _cardBorderColor = _generateRandomColor();
        });
        _changeBorderColors(); // Keep changing the colors
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCredentials(); // Load credentials when the screen is initialized
    _changeBorderColors(); // Start changing border colors
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(10.0),
        child: AppBar(
          backgroundColor: MyColors.color,
          centerTitle: true,
          title: Text(
            '',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          elevation: 4,
        ),
      ),
      body: _username == null || _password == null
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 80),

                    // Profile picture
                    Center(
                      child: AnimatedContainer(
                        duration: Duration(seconds: 1),
                        curve: Curves.easeInOut,
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _profilePicBorderColor,
                            width: 4.0,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/king.jpg',
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 40),

                    // Biography card
                    AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: _cardBorderColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'الشيخ سعد بن فهد بن صالح الكريديس',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 30),
                          Text(
                            ''' ولد الشيخ سعد بن فهد الكريديس في مدينة الرياض عام 1351 هجري، حيث نشأ وتلقى تعليمه الأولي، متعلماً القرآن الكريم على يد الشيخ محمد بن جابر وكان مرافقاً لوالده، الشيخ فهد بن صالح الكريديس، الذي شغل منصب رئيس ديوان ولي العهد الملك سعود خلال عهد الملك عبدالعزيز، وبعد تولي الملك سعود الحكم أصبح والده رئيساً للخاصة الملكية.

بعد وفاة والده عام 1387 هجري، اتجه الشيخ سعد إلى عالم الأعمال، حيث أسس عدداً من الشركات والمؤسسات التجارية. كما أسس مع أخويه، الشيخ عبدالرحمن الكريديس والشيخ عبدالله الكريديس، أول مطعم ومقهى في مدينة الرياض، والذي كان يُعرف بـ "كازينو الرياض" في حديقة المربع. وكانوا أيضًا أول وكلاء لسيارات مرسيدس في المملكة قبل انتقال الوكالة إلى عائلة الجفالي.

بعد تقاعده من الأعمال التجارية، تفرغ الشيخ سعد للعمل الخيري، حيث أسس جمعية البر الخيرية في حي العريجاء، وكان يرأسها حتى ضمت إلى جمعية البر بالرياض التي يرأسها أمير منطقة الرياض، كما ساهم في بناء العديد من المساجد في مدينة الرياض ومكة المكرمة بالإضافة إلى مساجد أخرى خارج المملكة.

انتقل الشيخ سعد بن فهد الكريديس إلى رحمة الله في مدينة الرياض في 12/2/1435 هجري. وله من الأبناء: عبدالعزيز، الدكتور منصور، عبدالمجيد، أحمد، سلمان، كريديس، الدكتور صالح، وفهد. ومن البنات: هيا، مشاعل، جواهر، سعاد، منيرة.
                            ''',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 15, height: 1.6),
                          ),
                        ],
                      ),
                    ),

                    

                    

                    SizedBox(height: 60),

                    ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: MyColors.color,
                        padding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 120.0,
                        ),
                      ),
                      child: Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
    );
  }
}
