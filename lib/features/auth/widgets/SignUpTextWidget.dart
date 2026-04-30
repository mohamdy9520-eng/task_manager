import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../core/routing/app_router.dart';

class SignupTextWidget extends StatelessWidget {
  const SignupTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Don't have an account? ",
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        children: [
          TextSpan(
            text: "Sign Up",
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 14,
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