// ignore_for_file: deprecated_member_use
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garant_task/screens/result_screen.dart';
import 'package:garant_task/services/data/questions_data.dart';
import 'package:garant_task/widgets/answer_card_widget.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Map<int, int> selectedAnswers = {};
  Map<int, bool> answerResults = {};
  int questionIndex = 0;
  int score = 0;
  PageController pageController = PageController();
  ScrollController indicatorScrollController = ScrollController();
  int second = 1200;
  int secondtimer = 0;
  bool isFinished = false;
  bool isRunning = false;
  Timer? timer;
  double percent = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    pageController.dispose();
    indicatorScrollController.dispose();
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    secondtimer = second;
    if (isRunning) return;

    setState(() {
      isRunning = true;
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (secondtimer > 0) {
          secondtimer--;
        } else {
          isFinished = true;
          isRunning = false;
          timer.cancel();
          setState(() {
            percent = score / questions.length;
          });
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return ResultScreen(
                  score: score,
                  allTest: questions.length,
                  ketganVaqti: formatTime(secondtimer),
                  umumiyVaqt: formatTime(second),
                  percent: percent,
                );
              },
            ),
          );
        }
      });
    });
  }

  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void scrollIndicatorToCurrentIndex() {
    if (indicatorScrollController.hasClients) {
      double indicatorWidth = 58.0;
      double screenWidth = MediaQuery.of(context).size.width;
      double targetScroll =
          (questionIndex * indicatorWidth) -
          (screenWidth / 2) +
          (indicatorWidth / 2);

      indicatorScrollController.animateTo(
        targetScroll.clamp(
          0.0,
          indicatorScrollController.position.maxScrollExtent,
        ),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void pickAnswer(int value) {
    if (selectedAnswers[questionIndex] == null) {
      setState(() {
        selectedAnswers[questionIndex] = value;
        final question = questions[questionIndex];
        bool isCorrect = value == question.correctAnswerIndex;
        answerResults[questionIndex] = isCorrect;

        if (isCorrect) {
          score++;
        }
      });
    }
  }

  void goToNextQuestion() {
    if (questionIndex < questions.length - 1) {
      questionIndex++;
      pageController.animateToPage(
        questionIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {});

      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollIndicatorToCurrentIndex();
      });
    }
  }

  void goToPreviousQuestion() {
    if (questionIndex > 0) {
      questionIndex--;
      pageController.animateToPage(
        questionIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {});

      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollIndicatorToCurrentIndex();
      });
    }
  }

  void goToFirstUnansweredQuestion() {
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == null) {
        questionIndex = i;
        pageController.animateToPage(
          questionIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {});

        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollIndicatorToCurrentIndex();
        });
        return;
      }
    }
  }

  bool areAllQuestionsAnswered() {
    return selectedAnswers.length == questions.length;
  }

  void finishDialog() {
    showDialog(
      context: context,

      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.question_mark, color: Colors.blue, size: 30),
              SizedBox(height: 16),
              Text(
                "Haqiqatda ham testni yakunlashni xohlaysizmi?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 18),
              ),
              SizedBox(height: 12),
              Text(
                "Belgilanmagan test javoblari xato deb hisobga olinadi",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.pop(context);
                        goToFirstUnansweredQuestion();
                      },
                      color: Color(0xfff1f3f7),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "Qaytish",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          percent = score / questions.length;
                        });
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              return ResultScreen(
                                score: score,
                                allTest: questions.length,
                                ketganVaqti: formatTime(secondtimer),
                                umumiyVaqt: formatTime(second),
                                percent: percent,
                              );
                            },
                          ),
                        );
                      },
                      color: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "Yakunlash",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void hammaJavobBelgilangandagiFinish() {
    setState(() {
      percent = score / questions.length;
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return ResultScreen(
            score: score,
            allTest: questions.length,
            ketganVaqti: formatTime(secondtimer),
            umumiyVaqt: formatTime(second),
            percent: percent,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F3F7),
      appBar: AppBar(
        flexibleSpace: Container(
          margin: EdgeInsets.only(top: 25, right: 12, left: 12),
          padding: EdgeInsets.symmetric(horizontal: 12),
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  finishDialog();
                },
                child: Icon(Icons.logout, color: Colors.grey),
              ),
              Container(
                alignment: Alignment.center,
                height: 40,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xfff1f3f7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.timer, color: Colors.blue),
                    Text(formatTime(secondtimer)),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Color(0xffF1F3F7),

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              controller: indicatorScrollController,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: List.generate(questions.length, (index) {
                  Color indicatorColor;

                  if (selectedAnswers.containsKey(index)) {
                    if (answerResults[index] == true) {
                      indicatorColor = Colors.green;
                    } else {
                      indicatorColor = Colors.red;
                    }
                  } else {
                    indicatorColor = Colors.white;
                  }

                  bool isCurrent = index == questionIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        questionIndex = index;
                      });
                      pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        scrollIndicatorToCurrentIndex();
                      });
                    },
                    child: Column(
                      children: [
                        isCurrent
                            ? Icon(
                                Icons.arrow_drop_down,
                                color: Colors.blue,
                                size: 30,
                              )
                            : SizedBox(height: 30),
                        Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: indicatorColor,

                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: indicatorColor == Colors.white
                                    ? Colors.black
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: PageView.builder(
          itemCount: questions.length,
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              questionIndex = index;
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              scrollIndicatorToCurrentIndex();
            });
          },
          itemBuilder: (context, index) {
            final currentQuestion = questions[index];
            final currentSelectedAnswer = selectedAnswers[index];

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Savol ${index + 1}:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          currentQuestion.question,
                          style: const TextStyle(fontSize: 21),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: currentQuestion.answers.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, answerIndex) {
                      String label = String.fromCharCode(65 + answerIndex);
                      return GestureDetector(
                        onTap: currentSelectedAnswer == null
                            ? () => pickAnswer(answerIndex)
                            : null,
                        child: AnswerCardWidget(
                          currentIndex: answerIndex,
                          question: currentQuestion.answers[answerIndex],
                          isSelected: currentSelectedAnswer == answerIndex,
                          selectedAnswerIndex: currentSelectedAnswer,
                          correctAnswerIndex:
                              currentQuestion.correctAnswerIndex,
                          optionLabel: label,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 36),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: questionIndex + 1 != questions.length
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  onPressed: questionIndex > 0 ? goToPreviousQuestion : null,
                  child: Icon(
                    Icons.arrow_back,
                    color: questionIndex > 0 ? Colors.black45 : Colors.grey,
                  ),
                ),
                Text(
                  "${questionIndex + 1}/${questions.length}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                CupertinoButton(
                  onPressed: questionIndex < questions.length - 1
                      ? goToNextQuestion
                      : null,
                  child: Icon(
                    Icons.arrow_forward,
                    color: questionIndex < questions.length - 1
                        ? Colors.black45
                        : Colors.grey,
                  ),
                ),
              ],
            )
          : Container(
              margin: EdgeInsets.all(12),
              width: double.infinity,
              height: 50,
              child: CupertinoButton(
                onPressed: () {
                  areAllQuestionsAnswered()
                      ? hammaJavobBelgilangandagiFinish()
                      : null;
                },
                color: areAllQuestionsAnswered()
                    ? Colors.blue
                    : Colors.blue.withOpacity(0.3),
                child: Text("Yakunlash", style: TextStyle(color: Colors.white)),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
