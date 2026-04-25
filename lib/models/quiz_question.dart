class QuizQuestion {
  final String text;
  final List<String> options;
  final int correctIndex;
  final String topic;

  QuizQuestion({
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.topic,
  });

  /// Создание модели из JSON
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      text: json['text'] as String,
      options: List<String>.from(json['options']),
      correctIndex: json['correctIndex'] as int,
      topic: json['topic'] as String,
    );
  }
}
