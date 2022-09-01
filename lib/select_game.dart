import 'dart:ui';

import 'package:dream_pony_kentei/custom_box_shadow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dream_pony_kentei/se_sound.dart';
import 'dart:async';

import 'package:dream_pony_kentei/result.dart';

import 'color_table.dart';

class SelectGame extends StatefulWidget {
  const SelectGame({
    Key? key,
    required this.title,
    required this.questionAndAnswers,
  }) : super(key: key);

  final String title;
  final List<dynamic> questionAndAnswers;

  @override
  State<SelectGame> createState() => _SelectGameState();
}

class _SelectGameState extends State<SelectGame> {
  int currentQuestionNumber = 0;
  int correctAnswersCount = 0;
  late List<int> questionNumbers = List.generate(widget.questionAndAnswers.length, (i)=> i);
  String finishMessage = "";
  Timer? _timer;
  SeSound se = SeSound();

  nextQuestion() {
    questionNumbers.removeAt(0);

    if (questionNumbers.isEmpty) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (BuildContext context) => Result(correctAnswersCount: correctAnswersCount, questionCount: widget.questionAndAnswers.length),
        ),
      );
    } else {
      setState(() {
        questionNumbers.shuffle();
        currentQuestionNumber = questionNumbers[0];
      });
    }
  }

  makeChoice(choice) async {
    final String answer = widget.questionAndAnswers[currentQuestionNumber]["answer"];
    final String explanationOfAnswer = widget.questionAndAnswers[currentQuestionNumber]["explanationOfAnswer"];

    _timer = Timer(
      const Duration(seconds: 2),
      () {
        Navigator.pop(context);
      },
    );

    if (answer == choice) {
      se.playSe(SeSoundIds.correct);

      await showDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        builder: (_) {
          return ResultDialog(
            context: context,
            answer: answer,
            explanationOfAnswer: explanationOfAnswer,
            resultImage: "assets/images/circle.png",
          );
        }
      );

      setState(() {
        correctAnswersCount++;
      });
    } else {
      se.playSe(SeSoundIds.incorrect);

      await showDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        builder: (_) {
          return ResultDialog(
            context: context,
            answer: answer,
            explanationOfAnswer: explanationOfAnswer,
            resultImage: "assets/images/cross.png",
          );
        }
      );
    }

    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    nextQuestion();
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
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "${widget.questionAndAnswers.length - questionNumbers.length + 1} / ${widget.questionAndAnswers.length} 問目",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: ColorTable.primaryBlackColor,
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    widget.questionAndAnswers[currentQuestionNumber]["question"],
                    style: const TextStyle(
                      fontSize: 20,
                      color: ColorTable.primaryBlackColor,
                      height: 1.5,
                      letterSpacing: 1,
                    )
                  ),
                ),

                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // スクロールさせない
                  itemCount: widget.questionAndAnswers[currentQuestionNumber]["choices"].length,
                  itemBuilder: (BuildContext context, int i) {
                    return choiceTile(widget.questionAndAnswers[currentQuestionNumber]["choices"][i]);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.width / 10,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: ColorTable.primaryBlackColor.withOpacity(0.8),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "トップへ戻る",
                            style: TextStyle(
                              fontSize: 16,
                              color: ColorTable.primaryBlackColor.withOpacity(0.8),
                            )
                          )
                        )
                      ),
                    )
                  ]
                )
              ],
            ),
          ),
        ]
      ),
    );
  }

  // 選択肢のタイルを生成
  Widget choiceTile(String choice) {
    return GestureDetector(
      onTap: () {
        makeChoice(choice);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        height: MediaQuery.of(context).size.width / 8,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          border: Border.all(
            color: Colors.white,
            width: 0.8,
          ),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            CustomBoxShadow(
              color: Colors.white.withOpacity(0.5),
              offset: const Offset(1.0, 1.0),
              blurRadius: 3.0,
              blurStyle: BlurStyle.outer
            ),
          ],
        ),
        child: Center(
          child: Text(
            choice,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorTable.primaryBlackColor,
              letterSpacing: 1.5,
            )
          )
        )
      ),
    );
  }
}

class ResultDialog extends StatelessWidget {
  const ResultDialog({
    Key? key,
    required this.context,
    required this.answer,
    required this.explanationOfAnswer,
    required this.resultImage,
  }) : super(key: key);

  final BuildContext context;
  final String answer;
  final String explanationOfAnswer;
  final String resultImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(resultImage, width: 200, height: 200),
        Container(
          height: MediaQuery.of(context).size.height / 3,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: ColorTable.primaryWhiteColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: Text(
                    "正解: $answer",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                      decoration: TextDecoration.none,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                Text(
                  explanationOfAnswer,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 16,
                    letterSpacing: 1.5,
                    height: 2.0,
                    decoration: TextDecoration.none,
                  ),
                ),
              ]
            ),
          ),
        ),
      ],
    );
  }
}
