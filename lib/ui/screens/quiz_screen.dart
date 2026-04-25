import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/quiz_view_model.dart';
import '../widgets/option_card.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  
  @override
  void initState() {
    super.initState();
    // При входе сбрасываем тест
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizViewModel>().resetQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вопросы'),
        centerTitle: true,
      ),
      body: Consumer<QuizViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage!));
          }

          if (viewModel.questions.isEmpty) {
            return const Center(child: Text('Нет доступных вопросов'));
          }

          // Если тест закончен, переходим на экран результатов
          if (viewModel.isFinished) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/result');
            });
            return const Center(child: CircularProgressIndicator());
          }

          final question = viewModel.questions[viewModel.currentIndex];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Вопрос ${viewModel.currentIndex + 1} из ${viewModel.questions.length}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'Тема: ${question.topic}',
                  style: const TextStyle(fontSize: 14, color: Colors.blueAccent),
                ),
                const SizedBox(height: 24),
                Text(
                  question.text,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView.builder(
                    itemCount: question.options.length,
                    itemBuilder: (context, index) {
                      final isSelected = viewModel.selectedAnswer == index;
                      final isCorrect = viewModel.selectedAnswer != null && index == question.correctIndex;
                      final isWrong = isSelected && index != question.correctIndex;

                      return OptionCard(
                        text: question.options[index],
                        isSelected: isSelected,
                        isCorrect: isCorrect,
                        isWrong: isWrong,
                        onTap: () {
                          viewModel.selectAnswer(index);
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: viewModel.selectedAnswer != null ? viewModel.nextQuestion : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    viewModel.currentIndex == viewModel.questions.length - 1 
                        ? 'Завершить' 
                        : 'Далее',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
