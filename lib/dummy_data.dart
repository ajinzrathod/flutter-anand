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
          .loadString('assets/quiz_questions_cleaned_flutter_safe.json');
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
      'Satsangijivan': {
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

    // Parse all questions organized by category, language, and level
    final allQuestions = <String, Map<String, Map<String, List<Question>>>>{};
    final questionsList = provider._quizData['questions'] as List<dynamic>;

    for (var i = 0; i < questionsList.length; i++) {
      final q = questionsList[i] as Map<String, dynamic>;
      var category = q['category'] as String? ?? 'Unknown';
      final level = q['level'] as String? ?? '1.0';
      final language = q['language'] as String? ?? 'en';

      // Normalize category name by removing ' eng' or ' guj' suffix
      category = category.replaceAll(' eng', '').replaceAll(' guj', '');

      if (!allQuestions.containsKey(category)) {
        allQuestions[category] = {
          'en': {
            '1.0': [],
            '2.0': [],
            '3.0': [],
          },
          'gu': {
            '1.0': [],
            '2.0': [],
            '3.0': [],
          },
        };
      }

      // Parse question with its actual language
      final question = _parseQuestion(i, q, language);
      allQuestions[category]![language]![level]!.add(question);
    }

    // Create Shastra objects with separate sets for each language and difficulty
    final shastras = <Shastra>[];
    shastraMetadata.forEach((categoryKey, metadataMap) {
      // Properly cast metadata values
      final metadata = metadataMap as Map<String, dynamic>;

      final questionsByLanguageAndLevel = allQuestions[categoryKey] ?? {
        'en': {
          '1.0': [],
          '2.0': [],
          '3.0': [],
        },
        'gu': {
          '1.0': [],
          '2.0': [],
          '3.0': [],
        },
      };

      final sets = <QuestionSet>[];

      // Create sets for English questions (Easy, Medium, Hard)
      final englishQuestions = questionsByLanguageAndLevel['en'] ?? {
        '1.0': [],
        '2.0': [],
        '3.0': [],
      };

      if (englishQuestions['1.0']!.isNotEmpty) {
        sets.add(QuestionSet(
          id: '${categoryKey}_english_easy',
          nameEnglish: (metadata['nameEnglish'] ?? '') as String,
          nameGujarati: (metadata['nameGujarati'] ?? '') as String,
          descriptionEnglish: '${metadata['descriptionEnglish'] ?? ''} - Easy',
          descriptionGujarati: '${metadata['descriptionGujarati'] ?? ''} - સહજ',
          questions: englishQuestions['1.0']!,
        ));
      }

      if (englishQuestions['2.0']!.isNotEmpty) {
        sets.add(QuestionSet(
          id: '${categoryKey}_english_medium',
          nameEnglish: (metadata['nameEnglish'] ?? '') as String,
          nameGujarati: (metadata['nameGujarati'] ?? '') as String,
          descriptionEnglish: '${metadata['descriptionEnglish'] ?? ''} - Medium',
          descriptionGujarati: '${metadata['descriptionGujarati'] ?? ''} - મધ્યમ',
          questions: englishQuestions['2.0']!,
        ));
      }

      if (englishQuestions['3.0']!.isNotEmpty) {
        sets.add(QuestionSet(
          id: '${categoryKey}_english_hard',
          nameEnglish: (metadata['nameEnglish'] ?? '') as String,
          nameGujarati: (metadata['nameGujarati'] ?? '') as String,
          descriptionEnglish: '${metadata['descriptionEnglish'] ?? ''} - Hard',
          descriptionGujarati: '${metadata['descriptionGujarati'] ?? ''} - મુશ્કેલ',
          questions: englishQuestions['3.0']!,
        ));
      }

      // Create sets for Gujarati questions (Easy, Medium, Hard)
      final gujaratiQuestions = questionsByLanguageAndLevel['gu'] ?? {
        '1.0': [],
        '2.0': [],
        '3.0': [],
      };

      if (gujaratiQuestions['1.0']!.isNotEmpty) {
        sets.add(QuestionSet(
          id: '${categoryKey}_gujarati_easy',
          nameEnglish: (metadata['nameEnglish'] ?? '') as String,
          nameGujarati: (metadata['nameGujarati'] ?? '') as String,
          descriptionEnglish: '${metadata['descriptionEnglish'] ?? ''} - Easy',
          descriptionGujarati: '${metadata['descriptionGujarati'] ?? ''} - સહજ',
          questions: gujaratiQuestions['1.0']!,
        ));
      }

      if (gujaratiQuestions['2.0']!.isNotEmpty) {
        sets.add(QuestionSet(
          id: '${categoryKey}_gujarati_medium',
          nameEnglish: (metadata['nameEnglish'] ?? '') as String,
          nameGujarati: (metadata['nameGujarati'] ?? '') as String,
          descriptionEnglish: '${metadata['descriptionEnglish'] ?? ''} - Medium',
          descriptionGujarati: '${metadata['descriptionGujarati'] ?? ''} - મધ્યમ',
          questions: gujaratiQuestions['2.0']!,
        ));
      }

      if (gujaratiQuestions['3.0']!.isNotEmpty) {
        sets.add(QuestionSet(
          id: '${categoryKey}_gujarati_hard',
          nameEnglish: (metadata['nameEnglish'] ?? '') as String,
          nameGujarati: (metadata['nameGujarati'] ?? '') as String,
          descriptionEnglish: '${metadata['descriptionEnglish'] ?? ''} - Hard',
          descriptionGujarati: '${metadata['descriptionGujarati'] ?? ''} - મુશ્કેલ',
          questions: gujaratiQuestions['3.0']!,
        ));
      }

      if (sets.isNotEmpty) {
        final shastra = Shastra(
          id: categoryKey,
          nameEnglish: (metadata['nameEnglish'] ?? '') as String,
          nameGujarati: (metadata['nameGujarati'] ?? '') as String,
          descriptionEnglish: (metadata['descriptionEnglish'] ?? '') as String,
          descriptionGujarati: (metadata['descriptionGujarati'] ?? '') as String,
          sets: sets,
        );

        shastras.add(shastra);
      }
    });

    return shastras;
  }

  static Question _parseQuestion(int index, Map<String, dynamic> json, String language) {
    final id = json['id'] as String? ?? 'q_$index';
    final category = json['category'] as String? ?? 'Unknown';
    final level = json['level'] as String? ?? '1.0';

    // Parse question - it's now a direct string
    final questionText = json['question'] as String? ?? '';

    // Parse options - each option has 'id' and 'text' keys
    final optionsList = json['options'] as List<dynamic>? ?? [];
    final options = <Option>[];

    for (var option in optionsList) {
      final opt = option as Map<String, dynamic>;
      final optId = opt['id'] as String? ?? '';
      // Handle text that might be String, int, or double
      final optTextValue = opt['text'];
      final optText = optTextValue?.toString() ?? '';
      options.add(Option(id: optId, text: optText));
    }

    final correctAnswerId = json['correctAnswer'] as String? ?? 'A';

    return Question(
      id: id,
      category: category,
      language: language,
      level: level,
      question: questionText,
      options: options,
      correctAnswer: correctAnswerId,
    );
  }
}
