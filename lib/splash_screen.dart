// CORE
import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';

// dart files
import 'package:dream_pony_kentei/home.dart';

// Lottie アニメーション
import 'package:lottie/lottie.dart';

import 'color_table.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const Home();
            },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const double begin = 0.0;
              const double end = 1.0;
              final Animatable<double> tween = Tween(begin: begin, end: end)
                  .chain(CurveTween(curve: Curves.easeInOut));
              final Animation<double> doubleAnimation = animation.drive(tween);
              return FadeTransition(
                opacity: doubleAnimation,
                child: child,
              );
            },
            transitionDuration: const Duration(seconds: 1),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        decoration: const BoxDecoration(
          color: ColorTable.primaryNaturalColor,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/lotties/unicorn.json'),
              Text(
                "ドリポニ検定",
                style: TextStyle(
                  fontSize: 26,
                  letterSpacing: 1,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.secondary),
                    bottom: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
                child: Text(
                  "from ユニコーンに乗って",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    height: 1.6,
                    letterSpacing: 3,
                    color: Theme.of(context).colorScheme.secondary,
                    shadows: [
                      Shadow(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                        offset: const Offset(1, 2),
                        blurRadius: 15.0,
                      ),
                    ],
                  ),
                  // line-heightに対して上下中央に配置するため
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                  ),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}