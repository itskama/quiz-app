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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizViewModel>().resetQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Вопросы', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
          ),
        ),
        child: SafeArea(
          child: Consumer<QuizViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)));
              }

              if (viewModel.errorMessage != null) {
                return Center(child: Text(viewModel.errorMessage!, style: const TextStyle(color: Colors.redAccent)));
              }

              if (viewModel.questions.isEmpty) {
                return const Center(child: Text('Нет доступных вопросов', style: TextStyle(color: Colors.white)));
              }

              if (viewModel.isFinished) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(context, '/result');
                });
                return const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)));
              }

              final question = viewModel.questions[viewModel.currentIndex];
              final progress = (viewModel.currentIndex + 1) / viewModel.questions.length;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Прогресс бар
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Вопрос ${viewModel.currentIndex + 1}/${viewModel.questions.length}',
                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.bold),
                        ),
                        Text(
                          question.topic,
                          style: const TextStyle(color: Color(0xFF818CF8), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Текст вопроса
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        question.text,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Варианты ответов
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: question.options.length,
                        itemBuilder: (context, index) {
                          final isSelected = viewModel.selectedAnswer == index;
                          final isCorrect = viewModel.selectedAnswer != null && index == question.correctIndex;
                          final isWrong = isSelected && index != question.correctIndex;
                          final hasAnswered = viewModel.selectedAnswer != null;

                          return OptionCard(
                            text: question.options[index],
                            isSelected: isSelected,
                            isCorrect: isCorrect,
                            isWrong: isWrong,
                            onTap: () {
                              if (!hasAnswered) {
                                viewModel.selectAnswer(index);
                              }
                            },
                          );
                        },
                      ),
                    ),
                    
                    // Кнопка далее
                    const SizedBox(height: 16),
                    AnimatedOpacity(
                      opacity: viewModel.selectedAnswer != null ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: ElevatedButton(
                        onPressed: viewModel.selectedAnswer != null ? viewModel.nextQuestion : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF14B8A6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          viewModel.currentIndex == viewModel.questions.length - 1 
                              ? 'Узнать результат' 
                              : 'Следующий вопрос',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
