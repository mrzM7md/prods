import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prods/core/network/local/cache_helper.dart';
import 'package:prods/core/services/services_locator.dart';
import 'package:prods/features/control_panel/business/sections/carts_cubit.dart';
import 'package:prods/firebase_cloud_services.dart';
import 'package:prods/firebase_options.dart';
import 'package:prods/prods_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await initializeDateFormatting('ar', ""); // تهيئة بيانات اللغة العربية

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupCheckAppService();
  // Bloc.observer = MyBlocObserver();

  ServicesLocator().init();
  // configureApp();

  FlutterStatusbarcolor.setStatusBarColor(Colors.white);
  FlutterStatusbarcolor.setStatusBarWhiteForeground(false);


  await CacheHelper.init();

  if (Platform.isAndroid || Platform.isIOS) {
    await Permission.photos.request();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) =>
      BlocProvider(
        create: (context) => sl<CartsCubit>(),
        child: const ProdsApp(),
      );
}
