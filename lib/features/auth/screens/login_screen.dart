import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_manager_app/features/auth/widgets/SignUpTextWidget.dart';

import '../../../constants/app_colors/text_style.dart';
import '../../../core/routing/app_router.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),

      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Login Success")),
            );

            Navigator.pushReplacementNamed(context, AppRouter.main);
          }

          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },

        builder: (context, state) {
          final isLoadingCubit = state is AuthLoading;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(height: 40.h),

                  SvgPicture.asset(
                    'assets/images/pictures/vecteezy_man-entering-security-password_4689193.svg',
                    width: 190.w,
                  ),

                  SizedBox(height: 20.h),

                  const Text(
                    "𝓦𝓮𝓵𝓬𝓸𝓶𝓮 𝓑𝓪𝓬𝓴",
                    style: AppTextStyles.headers,
                  ),

                  SizedBox(height: 10.h),

                  const Text(
                    "𝓛𝓸𝓰𝓲𝓷",
                    style: AppTextStyles.title,
                  ),

                  SizedBox(height: 30.h),

                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoadingCubit
                          ? null
                          : () {
                        context.read<AuthCubit>().login(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                      },
                      child: isLoadingCubit
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Login"),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  const Text("OR", style: AppTextStyles.small),

                  SizedBox(height: 20.h),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: isLoadingCubit
                              ? null
                              : () {
                            context.read<AuthCubit>().signInWithGoogle();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xff9E9E9E)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/icons/icons8-google.svg',
                                  width: 25.w,
                                ),
                                SizedBox(width: 10.w),
                                const Text("Google"),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 15.w),

                      Expanded(
                        child: GestureDetector(
                          onTap: isLoadingCubit
                              ? null
                              : () {
                            context.read<AuthCubit>().signInWithFacebook();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1877F2),
                              border: Border.all(color: const Color(0xff9E9E9E)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/icons/icons8-facebook96.svg',
                                  width: 25.w,
                                ),
                                SizedBox(width: 10.w),
                                const Text(
                                  "Facebook",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40.h),

                  const SignupTextWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}