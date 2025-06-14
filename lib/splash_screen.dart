import 'package:chart_harakia/screens/login_screen.dart';
import 'package:chart_harakia/widgets/colors.dart';
import 'package:chart_harakia/widgets/my_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _logoSlideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Slide from bottom to top: Offset(0, 0.5) to Offset(0, 0)
    _logoSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();

    // Navigate to LoginScreen after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      Get.off(() => LoginScreen());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background Image with fade transition
          SizedBox.expand(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                MyImages.splashBackground,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🔹 White semi-transparent overlay
          Container(
            color: Colors.white.withOpacity(0.6),
          ),

          // 🔹 Centered animated logo and animated text
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Slide the logo from bottom to center
                SlideTransition(
                  position: _logoSlideAnimation,
                  child: Image.asset(
                    MyImages.logo,
                    width: 200,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 20),
                const ScaleText(
                  text: 'تشارت حركية',
                  duration: Duration(milliseconds: 500),
                  type: AnimationType.letter,
                  textStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: MyColors.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
