import 'package:flutter/material.dart';
import 'package:dream_pony_kentei/color_table.dart';
import 'package:dream_pony_kentei/splash_screen.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ドリポニ検定',
      theme: ThemeData(
        fontFamily: 'YuGothic',
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: ColorTable.primaryWhiteColor,
        ).copyWith(
          secondary: ColorTable.primaryBlackColor,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
