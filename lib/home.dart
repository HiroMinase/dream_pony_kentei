// CORE
import 'dart:core';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// dart files
import 'package:dream_pony_kentei/select_game.dart';

// Firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

import 'color_table.dart';
import 'custom_box_shadow.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> questionAndAnswersList = [];

  @override
  initState() {
    super.initState();

    if (questionAndAnswersList.isEmpty) {
      _fetchQuestionAndAnswers();
    }
  }

  Future _fetchQuestionAndAnswers() async {
    final notificationsSnapshot = await FirebaseFirestore.instance.collection("question_and_answers").get();
    final notifications = notificationsSnapshot.docs.toList();

    // question = String
    // answer = String
    // explanationOfAnswer = String
    // choices = List<String>

    setState(() {
      for (var i = 0; notifications.length > i; i++) {
        questionAndAnswersList.add(
          {
            "question": notifications[i]["question"],
            "answer": notifications[i]["answer"],
            "explanationOfAnswer": notifications[i]["explanationOfAnswer"],
            "choices": notifications[i]["choices"],
          }
        );
      }
    });
  }

  // 問題Listからランダムに num個 選ぶ
  List<dynamic> randomlySelect(List<dynamic> array, int num) {
    array.shuffle();

    // 求められた個数に満たない場合
    if (array.length < num) {
      return array;
    }

    // 先頭から num個 切り出す
    return array.sublist(0, num);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 透明なAppbar
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   title: const Text("ドリポニ検定", style: TextStyle(fontSize: 18)),
      //   centerTitle: true,
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      // ),
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
            // child: Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white.withOpacity(0.4),
            //   ),
            // ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    border: Border.all(
                      color: Colors.white,
                      width: 0.8,
                    ),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      CustomBoxShadow(
                        color: Colors.white,
                        offset: Offset(1.0, 1.0),
                        blurRadius: 0.5,
                        blurStyle: BlurStyle.outer
                      ),
                    ],
                  ),
                  child: const Text(
                    "「ユニコーンに乗って」に関わる\nさまざまな問題を用意しました。\n\n全問正解できるかな？",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorTable.primaryBlackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Lottie.asset('assets/lotties/unicorn.json', repeat: false),
                ExaminationNav(title: "ドリポニ検定に挑戦！", questionAndAnswers: randomlySelect(questionAndAnswersList, 10)),
              ]
            ),
          ),
        ]
      ),
    );
  }
}

class ExaminationNav extends StatelessWidget {
  const ExaminationNav({
    Key? key,
    required this.title,
    required this.questionAndAnswers,
  }) : super(key: key);

  final String title;
  final List questionAndAnswers;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute<void>(
            builder: (BuildContext context) => SelectGame(title: title, questionAndAnswers: questionAndAnswers),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.width* 0.15,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          border: Border.all(
            color: Colors.white,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            CustomBoxShadow(
              color: Colors.white,
              offset: Offset(1.0, 1.0),
              blurRadius: 0.5,
              blurStyle: BlurStyle.outer
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              letterSpacing: 1.5,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorTable.primaryBlackColor,
            )
          )
        )
      ),
    );
  }
}