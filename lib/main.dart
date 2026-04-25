import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/question_repository.dart';
import 'viewmodels/quiz_view_model.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/quiz_screen.dart';
import 'ui/screens/result_screen.dart';

void main() {
  runApp(const FlutterQuizApp());
}

class FlutterQuizApp extends StatelessWidget {
  const FlutterQuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Внедрение зависимости: Репозиторий
        Provider<QuestionRepository>(
          create: (_) => QuestionRepository(),
        ),
        // Внедрение ViewModel, которая зависит от Репозитория
        ChangeNotifierProvider<QuizViewModel>(
          create: (context) => QuizViewModel(
            repository: context.read<QuestionRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Quiz',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/quiz': (context) => const QuizScreen(),
          '/result': (context) => const ResultScreen(),
        },
      ),
    );
  }
}
