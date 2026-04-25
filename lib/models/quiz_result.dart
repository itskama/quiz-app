class QuizResult {
  final int correctAnswers;
  final int totalQuestions;

  QuizResult({
    required this.correctAnswers,
    required this.totalQuestions,
  });

  /// Процент правильных ответов
  double get percentage => 
      totalQuestions == 0 ? 0 : (correctAnswers / totalQuestions) * 100;

  /// Текстовая оценка на основе процента
  String get feedbackText {
    if (percentage < 50) {
      return "Нужно подтянуть";
    } else if (percentage < 80) {
      return "Хорошо";
    } else {
      return "Отлично";
    }
  }
}
