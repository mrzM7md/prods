import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prods/block_observer.dart';
import 'package:prods/core/network/local/cache_helper.dart';
import 'package:prods/core/services/services_locator.dart';
import 'package:prods/firebase_cloud_services.dart';
import 'package:prods/firebase_options.dart';
import 'package:prods/prods_app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // await initializeDateFormatting('ar', ""); // تهيئة بيانات اللغة العربية

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupCheckAppService();
  Bloc.observer = MyBlocObserver();

  ServicesLocator().init();
  // configureApp();

  await CacheHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => const ProdsApp();
}
