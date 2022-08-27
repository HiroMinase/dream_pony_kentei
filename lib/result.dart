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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: ColorTable.primaryNaturalColor,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    Column(
                      children: [
                        const Text(
                          "\\ 結果発表 /",
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        Image.asset("assets/images/unicorn.png", width: 120, height: 120),
                      ]
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "ドリポニ検定",
                          style: TextStyle(
                            fontSize: 28,
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
                              ),
                            ),
                          ]
                        ),
                        const Text(
                          "",
                          style: TextStyle(
                            fontSize: 28,
                          ),
                        ),
                      ]
                    ),
                  ]
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 0),
                child: Column(
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
                          color: ColorTable.primaryNaturalColor,
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "トップへ戻る",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey
                            )
                          )
                        )
                      ),
                    ),
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
