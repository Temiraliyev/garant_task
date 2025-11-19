class QuestionModel {
  final String question;
  final List<String> answers;
  final int correctAnswerIndex;

  QuestionModel({
    required this.question,
    required this.answers,
    required this.correctAnswerIndex,
  });
}
