import 'package:flutter/foundation.dart';
import '../models/quiz_question.dart';
import '../models/quiz_result.dart';
import '../data/question_repository.dart';

class QuizViewModel extends ChangeNotifier {
  final QuestionRepository _repository;
  
  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  int? _selectedAnswer;
  int _score = 0;
  bool _isLoading = true;
  String? _errorMessage;

  QuizViewModel({required QuestionRepository repository}) : _repository = repository {
    _init();
  }

  List<QuizQuestion> get questions => _questions;
  int get currentIndex => _currentIndex;
  int? get selectedAnswer => _selectedAnswer;
  int get score => _score;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Флаг завершения теста
  bool get isFinished => _questions.isNotEmpty && _currentIndex >= _questions.length;
  
  /// Получение результата прохождения
  QuizResult get result => QuizResult(
    correctAnswers: _score, 
    totalQuestions: _questions.length,
  );

  /// Инициализация: загрузка вопросов
  Future<void> _init() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _questions = await _repository.loadQuestions();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Выбор ответа пользователем
  void selectAnswer(int index) {
    if (_selectedAnswer == null) {
      _selectedAnswer = index;
      if (_selectedAnswer == _questions[_currentIndex].correctIndex) {
        _score++;
      }
      notifyListeners();
    }
  }

  /// Переход к следующему вопросу
  void nextQuestion() {
    if (_selectedAnswer != null) {
      _currentIndex++;
      _selectedAnswer = null;
      notifyListeners();
    }
  }

  /// Сброс теста для повторного прохождения
  void resetQuiz() {
    _currentIndex = 0;
    _selectedAnswer = null;
    _score = 0;
    notifyListeners();
  }
}
