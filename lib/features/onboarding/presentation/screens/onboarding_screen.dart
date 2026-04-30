import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:task_manager_app/constants/app_colors/text_style.dart';
import 'package:task_manager_app/core/routing/app_router.dart';
import '../../../../constants/api_function/api_functions.dart';
import '../widgets/slider/slider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<String> images = [];

  final PageController controller = PageController();
  int currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  void loadImages() async {
    final data = await fetchPhotos();

    if (!mounted) return;

    final imgs = data.map((e) => e.url).take(5).toList();

    setState(() {
      images = imgs;
    });

    for (final url in imgs) {
      precacheImage(CachedNetworkImageProvider(url), context);
    }

    startAutoSlide();
  }

  void startAutoSlide() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted || images.isEmpty) return;

      int nextPage = currentIndex + 1;

      if (nextPage >= images.length) {
        nextPage = 0;
      }

      controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: images.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          SizedBox(
            height: 450.h,
            width: double.infinity,
            child: CustomImageSlider(
              images: images,
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 320.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 16.h),

                  SmoothPageIndicator(
                    controller: controller,
                    count: images.length,
                    effect: WormEffect(
                      dotHeight: 6.h,
                      dotWidth: 6.w,
                      activeDotColor: Colors.blue,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  Text(
                    "Building Better\nWorkplaces",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  Text(
                    "Create a unique emotional story that describes better than words",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),

                  const Spacer(),

                  Container(
                    width: double.infinity,
                    height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                      ),
                    ),
                    child: InkWell(
                      onTap: (){
                        Navigator.pushReplacementNamed(
                          context, AppRouter.login
                        );
                      },
                      child: const Center(
                        child: Text(
                          "Get Started",
                          style:AppTextStyles.primaryText
                          ),
                        ),
                      ),
                    ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}