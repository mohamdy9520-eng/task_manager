import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/routing/app_router.dart';

class SignupTextWidget extends StatelessWidget {
  const SignupTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Don't have an account? ",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.sp,
        ),
        children: [
          TextSpan(
            text: "Sign Up",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRouter.signup,
                );
              },
          ),
        ],
      ),
    );
  }
}