import 'package:flutter/material.dart';
import 'models.dart';
import 'language_provider.dart';
import 'timer_settings.dart';
import 'screens/language_selection_screen.dart';
import 'screens/home_screen.dart';
import 'screens/set_selection_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/results_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TimerSettingsProvider.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shastra Quiz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const HomeScreen(
                onShastraSelected: _dummyCallback,
              ),
            );
          case '/language-selection':
            return MaterialPageRoute(
              builder: (context) => const LanguageSelectionScreen(),
            );
          case '/set-selection':
            final shastra = settings.arguments as Shastra;
            return MaterialPageRoute(
              builder: (context) => SetSelectionScreen(shastra: shastra),
            );
          case '/quiz':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => QuizScreen(
                set: args['set'] as QuestionSet,
                difficulty: args['difficulty'] as String,
                shastraName: args['shastraName'] as String,
              ),
              settings: const RouteSettings(name: '/quiz'),
            );
          case '/results':
            final result = settings.arguments as QuizAttempt;
            return MaterialPageRoute(
              builder: (context) => ResultsScreen(result: result),
              settings: const RouteSettings(name: '/results'),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const LanguageSelectionScreen(),
            );
        }
      },
      initialRoute: '/language-selection',
    );
  }

  static void _dummyCallback(Shastra shastra) {}
}
