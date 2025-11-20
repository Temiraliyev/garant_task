// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garant_task/screens/home_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.score,
    required this.allTest,
    required this.ketganVaqti,
    required this.umumiyVaqt,
    required this.percent,
  });
  final int score;
  final int allTest;
  final String ketganVaqti;
  final String umumiyVaqt;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff1f3f7),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 50,
                    percent: percent,
                    lineWidth: 7,
                    progressColor: percent >= 0.9
                        ? Colors.green
                        : percent >= 0.5 && percent < 0.9
                        ? Colors.orange
                        : Colors.red,
                    center: Text(
                      "${(percent * 100).toInt()}%",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: percent >= 0.9
                            ? Colors.green
                            : percent >= 0.5 && percent < 0.9
                            ? Colors.orange
                            : Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Yakunlandi",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),

                  Text(
                    "Afsuski sizga ball taqdim etilmadi",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "Jami toplagan gallaringiz soni: 0 ta",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Umumiy testlar soni: $allTest ta",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$score",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              "Togri javob",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${allTest - score}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              "Notogri javob",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer, color: Colors.orange),
                      Text(
                        "$umumiyVaqt/$ketganVaqti",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              return QuizScreen();
                            },
                          ),
                        );
                      },
                      color: Colors.blue,
                      child: Text(
                        "Qayta o'rinish",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
