class Option {
  final String id;
  final String text;

  Option({
    required this.id,
    required this.text,
  });
}

class Question {
  final String id;
  final String category;
  final String language; // "en" or "gu"
  final String level;
  final String question;
  final List<Option> options;
  final String correctAnswer; // Option ID (A, B, C, D)

  Question({
    required this.id,
    required this.category,
    required this.language,
    required this.level,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  // Get the correct answer text
  String getCorrectAnswerText() {
    final correctOpt = options.firstWhere(
      (opt) => opt.id == correctAnswer,
      orElse: () => Option(id: 'A', text: 'Unknown'),
    );
    return correctOpt.text;
  }

  // Get correct option index
  int getCorrectOptionIndex() {
    final index = options.indexWhere((opt) => opt.id == correctAnswer);
    return index >= 0 ? index : 0;
  }
}

class QuestionSet {
  final String id;
  final String nameEnglish;
  final String nameGujarati;
  final String descriptionEnglish;
  final String descriptionGujarati;
  final List<Question> questions;

  QuestionSet({
    required this.id,
    required this.nameEnglish,
    required this.nameGujarati,
    required this.descriptionEnglish,
    required this.descriptionGujarati,
    required this.questions,
  });

  List<Question> getQuestionsByLanguage(String language) {
    return questions.where((q) => q.language == language).toList();
  }
}

class Shastra {
  final String id;
  final String nameEnglish;
  final String nameGujarati;
  final String descriptionEnglish;
  final String descriptionGujarati;
  final List<QuestionSet> sets;

  Shastra({
    required this.id,
    required this.nameEnglish,
    required this.nameGujarati,
    required this.descriptionEnglish,
    required this.descriptionGujarati,
    required this.sets,
  });
}

class QuizAttempt {
  final int totalQuestions;
  final int correctAnswers;
  final int totalPoints;
  final int earnedPoints;
  final String shastraName;
  final String setName;
  final String difficulty; // Changed from DifficultyLevel to String
  final List<QuestionAnswer> answers;

  QuizAttempt({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.totalPoints,
    required this.earnedPoints,
    required this.shastraName,
    required this.setName,
    required this.difficulty,
    required this.answers,
  });

  String get percentage => (earnedPoints / totalPoints * 100).toStringAsFixed(1);
}

class QuestionAnswer {
  final Question question;
  final String userAnswer;
  final bool isCorrect;

  QuestionAnswer({
    required this.question,
    required this.userAnswer,
    required this.isCorrect,
  });
}
