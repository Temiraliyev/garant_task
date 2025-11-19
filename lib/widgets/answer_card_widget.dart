import 'package:flutter/material.dart';

class AnswerCardWidget extends StatelessWidget {
  const AnswerCardWidget({
    super.key,
    required this.question,
    required this.isSelected,
    required this.currentIndex,
    required this.correctAnswerIndex,
    required this.selectedAnswerIndex,
    required this.optionLabel,
  });

  final String question;
  final bool isSelected;
  final int? correctAnswerIndex;
  final int? selectedAnswerIndex;
  final int currentIndex;
  final String optionLabel;

  @override
  Widget build(BuildContext context) {
    bool isCorrectAnswer = currentIndex == correctAnswerIndex;
    bool isWrongAnswer = !isCorrectAnswer && isSelected;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: selectedAnswerIndex != null
          ? Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: isCorrectAnswer
                    ? Colors.green
                    : isWrongAnswer
                    ? Colors.red
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    optionLabel,
                    style: TextStyle(
                      color: isCorrectAnswer
                          ? Colors.white
                          : isWrongAnswer
                          ? Colors.white
                          : Colors.blue,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      question,
                      style: TextStyle(
                        fontSize: 16,
                        color: isCorrectAnswer
                            ? Colors.white
                            : isWrongAnswer
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: [
                  Text(
                    optionLabel,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(question, style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
    );
  }
}
