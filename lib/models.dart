enum DifficultyLevel { easy, medium, hard }

class Question {
  final String id;
  final String textEnglish;
  final String textGujarati;
  final String answerEnglish;
  final String answerGujarati;
  final DifficultyLevel difficulty;

  Question({
    required this.id,
    required this.textEnglish,
    required this.textGujarati,
    required this.answerEnglish,
    required this.answerGujarati,
    required this.difficulty,
  });
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

  List<Question> getQuestionsByDifficulty(DifficultyLevel level) {
    return questions.where((q) => q.difficulty == level).toList();
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
  final DifficultyLevel difficulty;
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
