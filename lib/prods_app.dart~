import 'package:flutter/material.dart';
import 'package:prods/core/consts/app_colors.dart';
import 'package:prods/core/routes/routes_manager.dart';

class ProdsApp extends StatelessWidget {
  const ProdsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: RoutesManager.router,
      debugShowMaterialGrid: false,
      title: 'برنامج مصمم خصخيا لإجراء عمليات المتجر الأساسية',
      theme: ThemeData(
        fontFamily: "Amiri",
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appGreenColor),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
    );  }
}
