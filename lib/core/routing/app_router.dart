import 'package:flutter/material.dart';
import 'package:task_manager_app/features/auth/screens/login_screen.dart';
import 'package:task_manager_app/features/onboarding/presentation/screens/home_Screen.dart';
import 'package:task_manager_app/features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/auth/screens/signUp_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../main_screen.dart';

class AppRouter {
  static const String onboarding = '/onboarding';
  static const String main = '/main';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String splash='/splash';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {


      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );



      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case signup:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );

      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );



      case main:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
        );




      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("No Route Found")),
          ),
        );
    }
  }
}

//الكود ده مسؤول عن:
//  التحكم في التنقل بين الشاشات في التطبيق
//  بدل ما تستخدم Navigator.push() في كل حتة بطريقة عشوائية
//  بيخلي كل الـ routes في مكان واحد