// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    pageController.dispose();
    indicatorScrollController.dispose();
    super.dispose();
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

  void finishQuiz() {
    if (!areAllQuestionsAnswered()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Diqqat!'),
          content: Text(
            'Hamma savollarga javob berilmadi. Birinchi javobsiz savolga o\'tishni xohlaysizmi?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Yo\'q'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                goToFirstUnansweredQuestion();
              },
              child: Text('Ha'),
            ),
          ],
        ),
      );
    } else {
      // natijaga otish
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F3F7),
      appBar: AppBar(
        title: const Text('Quiz App'),
        backgroundColor: Color(0xffF1F3F7),

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
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
                    child: Stack(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: indicatorColor,
                            border: Border.all(
                              color: isCurrent
                                  ? Colors.blue
                                  : Colors.grey[300]!,
                              width: isCurrent ? 3 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: isCurrent
                                ? [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.3),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: indicatorColor == Colors.white
                                    ? Colors.black
                                    : Colors.white,
                                fontWeight: isCurrent
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: isCurrent ? 16 : 14,
                              ),
                            ),
                          ),
                        ),
                        // Positioned(child: Icon(Icons.abc), top: -15),
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

            return Column(
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
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: currentQuestion.answers.length,
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
                ),
              ],
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
                  finishQuiz();
                },
                color: Colors.blue,
                child: Text("Yakunlash"),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
