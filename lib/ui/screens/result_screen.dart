import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/quiz_view_model.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<QuizViewModel>();
    final result = viewModel.result;

    Color feedbackColor;
    if (result.percentage < 50) {
      feedbackColor = Colors.red;
    } else if (result.percentage < 80) {
      feedbackColor = Colors.orange;
    } else {
      feedbackColor = Colors.green;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Результат'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Убираем кнопку "назад"
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${result.percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: feedbackColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                result.feedbackText,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: feedbackColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Правильных ответов: ${result.correctAnswers} из ${result.totalQuestions}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () {
                  viewModel.resetQuiz();
                  Navigator.pushReplacementNamed(context, '/quiz');
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Пройти ещё раз'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  viewModel.resetQuiz();
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                },
                icon: const Icon(Icons.home),
                label: const Text('На главную'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
