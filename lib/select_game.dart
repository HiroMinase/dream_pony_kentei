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
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        backgroundColor: ColorTable.primaryNaturalColor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: ColorTable.primaryNaturalColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "正解数\n${correctAnswersCount.toString()} / ${widget.questionAndAnswers.length}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16
              ),
            ),

            const Text("正しいものを選んでね！", style: TextStyle(fontSize: 16)),

            Container(
              margin: const EdgeInsets.all(30),
              child: Text(
                widget.questionAndAnswers[currentQuestionNumber]["question"],
                style: const TextStyle(fontSize: 20, color: Colors.black)
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
                          fontSize: 16,
                          color: Colors.grey
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
          color: ColorTable.primaryNaturalColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            CustomBoxShadow(
              color: Colors.black.withOpacity(0.5),
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
              color: Colors.black,
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
        Image.asset(resultImage),
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ColorTable.primaryNaturalColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "正解: $answer",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Text(
                explanationOfAnswer,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16,
                  letterSpacing: 1.5,
                  decoration: TextDecoration.none,
                ),
              ),
            ]
          ),
        )
      ],
    );
  }
}
