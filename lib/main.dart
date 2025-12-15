
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:chart_harakia/screens/bottom_nav_1_Administrator/home_screen_widget.dart';
import 'package:chart_harakia/screens/login_screen.dart';
import 'package:chart_harakia/splash_screen.dart';
import 'package:chart_harakia/widgets/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chart Harakia',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: MyColors.color),
        useMaterial3: true,
        cardTheme: CardTheme(
          surfaceTintColor: MyColors.listContainerColor,
          color: MyColors.listContainerColor,
          shadowColor: MyColors.listContainerColor,
          elevation: 10,
        ),
        appBarTheme: AppBarTheme(
          color: MyColors.color.withOpacity(0.9),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      // ✅ Add these for localization
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [
        Locale('en'),
        Locale('ar', 'SA'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/adminHome', page: () => HomeScreenAdmin()),
        
      ],
    );
  }
}
