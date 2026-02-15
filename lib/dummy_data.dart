import 'dart:convert';
import 'package:flutter/services.dart';
import 'models.dart';

class DummyDataProvider {
  static final DummyDataProvider _instance = DummyDataProvider._internal();
  late Map<String, dynamic> _quizData;
  bool _isInitialized = false;

  factory DummyDataProvider() {
    return _instance;
  }

  DummyDataProvider._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final jsonString = await rootBundle
          .loadString('quiz_questions_cleaned_flutter_safe.json');
      _quizData = jsonDecode(jsonString);
      _isInitialized = true;
    } catch (e) {
      print('Error loading quiz data: $e');
      rethrow;
    }
  }

  static Future<List<Shastra>> getAllShastras() async {
    final provider = DummyDataProvider();
    await provider.initialize();

    // Define shastra metadata
    final shastraMetadata = {
      'Shikshapatri': {
        'nameEnglish': 'Shikshapatri',
        'nameGujarati': 'શિક્ષાપત્રી',
        'descriptionEnglish': 'The letter of instruction for conduct',
        'descriptionGujarati': 'આચારની શિક્ષા આપતું પત્ર',
      },
      'Satsangi Jivan': {
        'nameEnglish': 'Satsangi Jivan',
        'nameGujarati': 'સત્સંગી જીવન',
        'descriptionEnglish': 'The life of a true devotee',
        'descriptionGujarati': 'સત્સંગીનું જીવન',
      },
      'Vachnamrut': {
        'nameEnglish': 'Vachnamrut',
        'nameGujarati': 'વચનામૃત',
        'descriptionEnglish': 'Nectar of sermons',
        'descriptionGujarati': 'પ્રવચનોનું અમૃત',
      },
      'Religious': {
        'nameEnglish': 'Religious Studies',
        'nameGujarati': 'ધાર્મિક જ્ઞાન',
        'descriptionEnglish': 'General religious knowledge',
        'descriptionGujarati': 'સામાન્ય ધાર્મિક જ્ઞાન',
      },
    };

    // Parse all questions organized by category and difficulty
    final allQuestions = <String, Map<DifficultyLevel, List<Question>>>{};
    final questionsList = provider._quizData['questions'] as List<dynamic>;

    for (var i = 0; i < questionsList.length; i++) {
      final q = questionsList[i] as Map<String, dynamic>;
      final question = _parseQuestion(i, q);
      final category = q['category'] as String;

      if (!allQuestions.containsKey(category)) {
        allQuestions[category] = {
          DifficultyLevel.easy: [],
          DifficultyLevel.medium: [],
          DifficultyLevel.hard: [],
        };
      }
      allQuestions[category]![question.difficulty]!.add(question);
    }

    // Create Shastra objects with separate sets for each difficulty level
    final shastras = <Shastra>[];
    shastraMetadata.forEach((categoryKey, metadata) {
      final questionsByDifficulty = allQuestions[categoryKey] ?? {
        DifficultyLevel.easy: [],
        DifficultyLevel.medium: [],
        DifficultyLevel.hard: [],
      };

      final sets = <QuestionSet>[];

      // Create a set for each difficulty level
      final difficultyLabels = {
        DifficultyLevel.easy: 'Easy',
        DifficultyLevel.medium: 'Medium',
        DifficultyLevel.hard: 'Hard',
      };

      questionsByDifficulty.forEach((difficulty, questions) {
        if (questions.isNotEmpty) {
          final difficultyLabel = difficultyLabels[difficulty]!;
          final questionSet = QuestionSet(
            id: '${categoryKey}_${difficultyLabel.toLowerCase()}',
            nameEnglish: '${metadata['nameEnglish']} - $difficultyLabel',
            nameGujarati: '${metadata['nameGujarati']} - $difficultyLabel',
            descriptionEnglish:
                '${metadata['descriptionEnglish']} ($difficultyLabel Questions)',
            descriptionGujarati:
                '${metadata['descriptionGujarati']} ($difficultyLabel પ્રશ્નો)',
            questions: questions,
          );
          sets.add(questionSet);
        }
      });

      if (sets.isNotEmpty) {
        final shastra = Shastra(
          id: categoryKey,
          nameEnglish: metadata['nameEnglish'] as String,
          nameGujarati: metadata['nameGujarati'] as String,
          descriptionEnglish: metadata['descriptionEnglish'] as String,
          descriptionGujarati: metadata['descriptionGujarati'] as String,
          sets: sets,
        );

        shastras.add(shastra);
      }
    });

    return shastras;
  }

  static Question _parseQuestion(int index, Map<String, dynamic> json) {
    final question = json['question'] as Map<String, dynamic>? ?? {};
    final questionEnglish = question['en'] as String? ?? '';
    final questionGujarati = question['gu'] as String? ?? '';

    final options = json['options'] as List<dynamic>? ?? [];
    final optionsEnglish = <String>[];
    final optionsGujarati = <String>[];
    final optionIds = <String>[];

    for (var option in options) {
      final opt = option as Map<String, dynamic>;
      optionIds.add(opt['id'] as String? ?? '');
      optionsEnglish.add(opt['en'] as String? ?? '');
      optionsGujarati.add(opt['gu'] as String? ?? '');
    }

    final correctAnswerId = json['correctAnswer'] as String?;
    int correctOptionIndex = 0;
    String correctAnswerEnglish = '';
    String correctAnswerGujarati = '';

    if (correctAnswerId != null && correctAnswerId.isNotEmpty) {
      final indexOfCorrect = optionIds.indexOf(correctAnswerId);
      if (indexOfCorrect >= 0) {
        correctOptionIndex = indexOfCorrect;
        correctAnswerEnglish = optionsEnglish[indexOfCorrect];
        correctAnswerGujarati = optionsGujarati[indexOfCorrect];
      }
    }

    // Parse difficulty level
    final level = json['level'] as String? ?? '1.0';
    DifficultyLevel difficulty;
    if (level.contains('1')) {
      difficulty = DifficultyLevel.easy;
    } else if (level.contains('2')) {
      difficulty = DifficultyLevel.medium;
    } else {
      difficulty = DifficultyLevel.hard;
    }

    final id = json['id'] as String? ?? 'q_$index';

    return Question(
      id: id,
      textEnglish: questionEnglish,
      textGujarati: questionGujarati,
      answerEnglish: correctAnswerEnglish,
      answerGujarati: correctAnswerGujarati,
      difficulty: difficulty,
      options: optionsEnglish,
      optionsGujarati: optionsGujarati,
      correctOptionIndex: correctOptionIndex,
    );
  }
}
