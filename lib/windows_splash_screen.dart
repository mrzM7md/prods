import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prods/core/consts/app_images.dart';
import 'package:go_router/go_router.dart';
import 'package:prods/core/consts/app_routes.dart';

class WindowsSplashScreen extends StatefulWidget {
  const WindowsSplashScreen({super.key});

  @override
  State<WindowsSplashScreen> createState() => _WindowsSplashScreenStateState();
}

class _WindowsSplashScreenStateState extends State<WindowsSplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      context.goNamed(AppRoutes.loginRouter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(width: 60 ,AppImages.appLogo),
      ),
    );
  }
}
