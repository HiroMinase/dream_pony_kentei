// CORE
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// dart files
import 'package:dream_pony_kentei/select_game.dart';

// Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

import 'color_table.dart';

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

  // 問題をランダムに選抜
  List<dynamic> randomlySelect(List<dynamic> array, int num) {
    if (array.length < num) {
      array.shuffle();
      return array;
    }
    array.shuffle();
    return array.sublist(0, num);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ドリポニ検定", style: TextStyle(fontSize: 18)),
        centerTitle: true,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        backgroundColor: ColorTable.primaryNaturalColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: ColorTable.primaryNaturalColor,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: const Text(
                  "TBS 火曜ドラマ「ユニコーンに乗って」にまつわる、さまざまな難易度の問題を用意しました。\n全問正解できるかな？",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Image.asset("assets/images/unicorn.png", width: 200, height: 200),
              ExaminationNav(title: "ドリポニ検定に挑戦！", questionAndAnswers: randomlySelect(questionAndAnswersList, 10)),
            ]
          ),
        ),
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
          color: ColorTable.primaryNaturalColor,
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              letterSpacing: 1.5,
              fontSize: 22,
              color: Theme.of(context).colorScheme.secondary,
            )
          )
        )
      ),
    );
  }
}