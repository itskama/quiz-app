import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quiz_question.dart';

class QuestionRepository {
  /// Загружает вопросы из локального JSON ассета
  Future<List<QuizQuestion>> loadQuestions() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/questions.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      
      return jsonList.map((json) => QuizQuestion.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Ошибка при загрузке вопросов: $e');
    }
  }
}
