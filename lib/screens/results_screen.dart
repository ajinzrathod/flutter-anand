import 'package:flutter/material.dart';
import '../models.dart';
import '../language_provider.dart';

class ResultsScreen extends StatelessWidget {
  final QuizAttempt result;

  const ResultsScreen({
    super.key,
    required this.result,
  });

  Color _getScoreColor() {
    final percentage = result.percentage;
    final percentValue = double.parse(percentage);
    if (percentValue >= 80) return Colors.green;
    if (percentValue >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getPerformanceMessage() {
    final percentage = result.percentage;
    final percentValue = double.parse(percentage);

    if (LanguageProvider.isEnglish()) {
      if (percentValue >= 90) return 'Excellent!';
      if (percentValue >= 80) return 'Great!';
      if (percentValue >= 70) return 'Good!';
      if (percentValue >= 60) return 'Fair';
      return 'Need more practice';
    } else {
      if (percentValue >= 90) return 'શ્રેષ્ઠ!';
      if (percentValue >= 80) return 'શાનદાર!';
      if (percentValue >= 70) return 'સારું!';
      if (percentValue >= 60) return 'સરેરાશ';
      return 'વધુ પ્રેક્ટિસ જરૂરી છે';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent going back
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green[300]!, Colors.green[700]!],
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      LanguageProvider.isEnglish() ? 'Quiz Completed!' : 'ક્વિઝ પૂર્ણ!',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getPerformanceMessage(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Results Card
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Score Circle
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              result.percentage,
                              style: TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                color: _getScoreColor(),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${result.earnedPoints}/${result.totalPoints} Points',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Details Card
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow(
                              LanguageProvider.isEnglish() ? 'Shastra' : 'શાસ્ત્ર',
                              result.shastraName,
                              Icons.book,
                            ),
                            const Divider(height: 24),
                            _buildDetailRow(
                              LanguageProvider.isEnglish() ? 'Set' : 'સમૂહ',
                              result.setName,
                              Icons.layers,
                            ),
                            const Divider(height: 24),
                            _buildDetailRow(
                              LanguageProvider.isEnglish() ? 'Difficulty' : 'મુશ્કેલી',
                              _difficultyToString(result.difficulty),
                              Icons.speed,
                            ),
                            const Divider(height: 24),
                            _buildDetailRow(
                              LanguageProvider.isEnglish() ? 'Correct Answers' : 'સાચા જવાબો',
                              '${result.correctAnswers}/${result.totalQuestions}',
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                      // Answer Review
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LanguageProvider.isEnglish() ? 'Answer Review' : 'જવાબોની તપાસ',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...result.answers
                                .asMap()
                                .entries
                                .map((entry) =>
                                    _buildAnswerReview(entry.key, entry.value))
                                .toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Action Buttons
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/',
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Home'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    dynamic value,
    IconData icon, {
    Color? color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: color ?? Colors.blueAccent,
          size: 24,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnswerReview(int index, QuestionAnswer answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: answer.isCorrect
            ? Colors.green[50]
            : Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: answer.isCorrect ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                answer.isCorrect ? Icons.check_circle : Icons.cancel,
                color: answer.isCorrect ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Question ${index + 1}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Your answer: ${answer.userAnswer}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Correct answer: ${answer.question.answerEnglish}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _difficultyToString(DifficultyLevel level) {
    if (LanguageProvider.isEnglish()) {
      switch (level) {
        case DifficultyLevel.easy:
          return 'Easy';
        case DifficultyLevel.medium:
          return 'Medium';
        case DifficultyLevel.hard:
          return 'Hard';
      }
    } else {
      switch (level) {
        case DifficultyLevel.easy:
          return 'સહજ';
        case DifficultyLevel.medium:
          return 'મધ્યમ';
        case DifficultyLevel.hard:
          return 'મુશ્કેલ';
      }
    }
  }
}
