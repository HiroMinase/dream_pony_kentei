import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:dream_pony_kentei/home.dart';

import 'color_table.dart';

class Result extends StatefulWidget {
  const Result({
    Key? key,
    required this.correctAnswersCount,
    required this.questionCount,
  }) : super(key: key);

  final int correctAnswersCount;
  final int questionCount;

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  String certifyingExaminationResult = "";
  String resultMessage = "";

  @override
  initState() {
    super.initState();

    _judgmentResult(widget.correctAnswersCount);
  }

  Future _judgmentResult(int correctAnswersCount) async {
    if (correctAnswersCount > 8) {
      certifyingExaminationResult = "1級";
      resultMessage = "";
    } else if (correctAnswersCount > 5) {
      certifyingExaminationResult = "2級";
      resultMessage = "";
    } else {
      certifyingExaminationResult = "3級";
      resultMessage = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(-1.6, -0.1),
                end: const Alignment(1.4, 0.8),
                stops: const [0.2, 0.7],
                colors: [
                  ColorTable.gradientBeginColor.withOpacity(0.4),
                  ColorTable.gradientEndColor.withOpacity(0.4),
                ],
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 500, sigmaY: 500),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      const Text(
                        "\\ 結果発表 /",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "ドリポニ検定",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (certifyingExaminationResult != "1級") Text(
                              certifyingExaminationResult,
                              style: const TextStyle(
                                fontSize: 38,
                                letterSpacing: 1,
                              ),
                            ),
                            if (certifyingExaminationResult == "1級") Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  'assets/lotties/trophy.json',
                                  width: 100,
                                  height: 100,
                                  repeat: false,
                                ),
                                Text(
                                  certifyingExaminationResult,
                                  style: const TextStyle(
                                    fontSize: 38,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]
                            ),
                          ]
                        ),
                      ),
                    ]
                  ),
                ),
                Lottie.asset('assets/lotties/unicorn.json', repeat: false),
                Column(
                  children: [
                    Text(
                      "正解数\n${widget.correctAnswersCount} / ${widget.questionCount}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                            builder: (BuildContext context) => const Home(),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 10,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: ColorTable.primaryBlackColor.withOpacity(0.8),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "トップへ戻る",
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorTable.primaryBlackColor.withOpacity(0.8),
                            )
                          )
                        )
                      ),
                    ),
                  ]
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}
