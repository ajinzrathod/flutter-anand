import 'package:flutter/material.dart';
import '../models.dart';

class QuizScreen extends StatefulWidget {
  final QuestionSet set;
  final DifficultyLevel difficulty;
  final String shastraName;

  const QuizScreen({
    super.key,
    required this.set,
    required this.difficulty,
    required this.shastraName,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Question> questions;
  late List<int?> selectedAnswers;
  int currentQuestionIndex = 0;
  late List<bool> feedbackShown;

  @override
  void initState() {
    super.initState();
    // Randomize 10 questions from the selected difficulty set
    questions = (widget.set.questions..shuffle()).take(10).toList();
    selectedAnswers = List.filled(questions.length, null);
    feedbackShown = List.filled(questions.length, false);
  }

  int _getCorrectAnswersCount() {
    int count = 0;
    for (int i = 0; i <= currentQuestionIndex; i++) {
      final question = questions[i];
      final selectedIndex = selectedAnswers[i];
      if (selectedIndex != null && selectedIndex == question.correctOptionIndex) {
        count++;
      }
    }
    return count;
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void _submitQuiz() {
    // Calculate results
    int correctCount = 0;
    final answers = <QuestionAnswer>[];

    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      final selectedIndex = selectedAnswers[i];
      
      final isCorrect = selectedIndex != null && 
          selectedIndex == question.correctOptionIndex;

      if (isCorrect) {
        correctCount++;
      }

      final selectedAnswer = selectedIndex != null 
          ? question.options[selectedIndex]
          : 'Not answered';

      answers.add(
        QuestionAnswer(
          question: question,
          userAnswer: selectedAnswer,
          isCorrect: isCorrect,
        ),
      );
    }

    final result = QuizAttempt(
      totalQuestions: questions.length,
      correctAnswers: correctCount,
      totalPoints: questions.length * 10,
      earnedPoints: correctCount * 10,
      shastraName: widget.shastraName,
      setName: widget.set.nameEnglish,
      difficulty: widget.difficulty,
      answers: answers,
    );

    Navigator.of(context).pushReplacementNamed(
      '/results',
      arguments: result,
    );
  }

  void _showAnswerFeedback() {
    final question = questions[currentQuestionIndex];
    final selectedIndex = selectedAnswers[currentQuestionIndex];
    
    if (selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an answer first!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      feedbackShown[currentQuestionIndex] = true;
    });

    final isCorrect = selectedIndex == question.correctOptionIndex;
    final correctAnswerText = question.options[question.correctOptionIndex];
    final correctAnswerGuj = question.optionsGujarati[question.correctOptionIndex];
    final correctCount = _getCorrectAnswersCount();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isCorrect
                  ? [Colors.green[100]!, Colors.green[50]!]
                  : [Colors.orange[100]!, Colors.orange[50]!],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Result icon and message
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCorrect ? Colors.green : Colors.orange,
                  ),
                  child: Icon(
                    isCorrect ? Icons.check : Icons.close,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isCorrect ? '🎉 Excellent!' : '💪 Good Try!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? Colors.green[700] : Colors.orange[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  isCorrect
                      ? 'Your answer is correct! Keep it up!'
                      : 'The correct answer was:',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Correct answer display
                if (!isCorrect)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Correct Answer (English)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          correctAnswerText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'સાચો જવાબ (Gujarati)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          correctAnswerGuj,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                // Progress tracker
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Your Progress',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$correctCount',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[600],
                              ),
                            ),
                            const TextSpan(
                              text: ' / ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            const TextSpan(
                              text: '10',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            const TextSpan(
                              text: ' correct',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: correctCount / 10,
                        minHeight: 6,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (currentQuestionIndex < questions.length - 1) {
                        _nextQuestion();
                      } else {
                        _submitQuiz();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCorrect ? Colors.green : Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      currentQuestionIndex == questions.length - 1
                          ? 'View Results'
                          : 'Next Question',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];
    final isLastQuestion = currentQuestionIndex == questions.length - 1;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          elevation: 0,
          title: Text(
            'Question ${currentQuestionIndex + 1} of ${questions.length}',
            style: const TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue[100]!, Colors.blue[50]!],
            ),
          ),
          child: Column(
            children: [
              // Progress bar
              LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / questions.length,
                minHeight: 6,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
              // Question content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question text
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Question (English)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                question.textEnglish,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Divider(),
                              const SizedBox(height: 20),
                              const Text(
                                'પ્રશ્ન (Gujarati)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                question.textGujarati,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // MCQ Options
                        const Text(
                          'Select Your Answer',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(
                          question.options.length,
                          (optionIndex) {
                            final isSelected =
                                selectedAnswers[currentQuestionIndex] ==
                                    optionIndex;
                            final isCorrectOption =
                                optionIndex == question.correctOptionIndex;
                            final isFeedbackShown =
                                feedbackShown[currentQuestionIndex];
                            final option = question.options[optionIndex];
                            final optionGuj = question.optionsGujarati[optionIndex];

                            Color getBackgroundColor() {
                              if (!isFeedbackShown) {
                                return isSelected
                                    ? Colors.blueAccent
                                    : Colors.white;
                              }
                              if (isCorrectOption) {
                                return Colors.green[100]!;
                              }
                              if (isSelected && !isCorrectOption) {
                                return Colors.red[100]!;
                              }
                              return Colors.white;
                            }

                            Color getBorderColor() {
                              if (!isFeedbackShown) {
                                return isSelected
                                    ? Colors.blueAccent
                                    : Colors.grey[300]!;
                              }
                              if (isCorrectOption) {
                                return Colors.green;
                              }
                              if (isSelected && !isCorrectOption) {
                                return Colors.red;
                              }
                              return Colors.grey[300]!;
                            }

                            Color getTextColor() {
                              if (!isFeedbackShown) {
                                return isSelected
                                    ? Colors.white
                                    : Colors.black87;
                              }
                              if (isCorrectOption || isSelected) {
                                return Colors.black87;
                              }
                              return Colors.black54;
                            }

                            Color getSecondaryTextColor() {
                              if (!isFeedbackShown) {
                                return isSelected
                                    ? Colors.white70
                                    : Colors.black54;
                              }
                              if (isCorrectOption || isSelected) {
                                return Colors.black54;
                              }
                              return Colors.black38;
                            }

                            return GestureDetector(
                              onTap: isFeedbackShown
                                  ? null
                                  : () {
                                      setState(() {
                                        selectedAnswers[currentQuestionIndex] =
                                            optionIndex;
                                      });
                                    },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: getBackgroundColor(),
                                  border: Border.all(
                                    color: getBorderColor(),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isFeedbackShown &&
                                                  (isCorrectOption ||
                                                      isSelected)
                                              ? getBorderColor()
                                              : Colors.grey[400]!,
                                          width: 2,
                                        ),
                                        color: isFeedbackShown &&
                                                (isCorrectOption ||
                                                    isSelected)
                                            ? getBorderColor()
                                            : Colors.transparent,
                                      ),
                                      child: (isFeedbackShown &&
                                              isCorrectOption)
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                              size: 14,
                                            )
                                          : (isFeedbackShown &&
                                                  isSelected &&
                                                  !isCorrectOption)
                                              ? const Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                  size: 14,
                                                )
                                              : (isSelected &&
                                                      !isFeedbackShown
                                                  ? const Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                      size: 14,
                                                    )
                                                  : null),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            option,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: getTextColor(),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            optionGuj,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  getSecondaryTextColor(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Navigation buttons
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLastQuestion
                        ? ElevatedButton(
                            onPressed: _showAnswerFeedback,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              'Submit Quiz',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: _showAnswerFeedback,
                            label: const Text('Next Question'),
                            icon: const Icon(Icons.arrow_forward),
                            style: ElevatedButton.styleFrom(
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
}
