import 'package:flutter/material.dart';
import 'dart:async';
import '../models.dart';
import '../language_provider.dart';
import '../timer_settings.dart';

class QuizScreen extends StatefulWidget {
  final QuestionSet set;
  final String difficulty;
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
  late Timer _timer;
  int _timeRemaining = 10; // 10 seconds per question for faster testing
  late List<int> questionTimings; // Track time spent on each question
  bool _timeIsUp = false; // Track if time is up for current question

  @override
  void initState() {
    super.initState();
    // Get all available questions and shuffle them
    final allQuestions = List<Question>.from(widget.set.questions);
    allQuestions.shuffle();

    // Take the first 10 unique questions (shuffle ensures no repetition)
    questions = allQuestions.take(10).toList();

    selectedAnswers = List.filled(questions.length, null);
    feedbackShown = List.filled(questions.length, false);
    questionTimings = List.filled(questions.length, 0);
    _startTimer();
  }

  void _startTimer() {
    _timeRemaining = TimerSettingsProvider.getTimerSeconds();
    _timeIsUp = false;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else if (!_timeIsUp) {
          _timeIsUp = true;
          // Show "Time's Up" message and move to next question
          _showTimeUpDialog();
        }
      });
    });
  }

  void _showTimeUpDialog() {
    _timer.cancel();
    final question = questions[currentQuestionIndex];
    final correctAnswerText = question.getCorrectAnswerText();

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
              colors: [Colors.red[100]!, Colors.red[50]!],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.schedule,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 20),
                Text(
                  LanguageProvider.isEnglish() ? "Time's Up!" : 'સમય સમાપ્ત!',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Show correct answer
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
                      Text(
                        LanguageProvider.isEnglish() ? 'Correct Answer' : 'સાચો જવાબ',
                        style: const TextStyle(
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
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  LanguageProvider.isEnglish()
                      ? 'Moving to the next question...'
                      : 'આગલા પ્રશ્ને જતા રહ્યા છીએ...',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (currentQuestionIndex < questions.length - 1) {
                        setState(() {
                          currentQuestionIndex++;
                        });
                        _startTimer();
                      } else {
                        _submitQuiz();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      LanguageProvider.isEnglish() ? 'Next Question' : 'આગલો પ્રશ્ન',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  int _getCorrectAnswersCount() {
    int count = 0;
    for (int i = 0; i <= currentQuestionIndex; i++) {
      final question = questions[i];
      final selectedIndex = selectedAnswers[i];
      final correctIndex = question.getCorrectOptionIndex();
      if (selectedIndex != null && selectedIndex == correctIndex) {
        count++;
      }
    }
    return count;
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      _timer.cancel();
      setState(() {
        currentQuestionIndex++;
      });
      _startTimer();
    }
  }

  void _submitQuiz() {
    _timer.cancel();
    // Calculate results
    int correctCount = 0;
    final answers = <QuestionAnswer>[];

    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      final selectedIndex = selectedAnswers[i];
      final correctIndex = question.getCorrectOptionIndex();

      final isCorrect = selectedIndex != null && 
          selectedIndex == correctIndex;

      if (isCorrect) {
        correctCount++;
      }

      final selectedAnswer = selectedIndex != null 
          ? question.options[selectedIndex].text
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

  void _showQuitConfirmation(BuildContext context) {
    _timer.cancel();
    showDialog(
      context: context,
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
              colors: [Colors.red[100]!, Colors.red[50]!],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                LanguageProvider.isEnglish()
                    ? 'Quit Quiz?'
                    : 'ક્વિઝ છોડી દો?',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                LanguageProvider.isEnglish()
                    ? 'Your progress will be lost. Are you sure?'
                    : 'તમારી પ્રગતિ ગુમ થશે. શું તમે ચોક્કસ છો?',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _startTimer(); // Resume the timer
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      LanguageProvider.isEnglish() ? 'Continue' : 'ચાલુ રાખો',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/',
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      LanguageProvider.isEnglish() ? 'Quit' : 'બહાર નીકળો',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAnswerFeedback() {
    final question = questions[currentQuestionIndex];
    final selectedIndex = selectedAnswers[currentQuestionIndex];
    
    // Validate silently - just return without showing snackbar
    if (selectedIndex == null) {
      return;
    }

    setState(() {
      feedbackShown[currentQuestionIndex] = true;
    });

    final correctIndex = question.getCorrectOptionIndex();
    final isCorrect = selectedIndex == correctIndex;
    final correctAnswerText = question.getCorrectAnswerText();
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
                        Text(
                          LanguageProvider.isEnglish() ? 'Correct Answer' : 'સાચો જવાબ',
                          style: const TextStyle(
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
          actions: [
            // Timer display in AppBar
            Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _timeRemaining > 10
                    ? Colors.green
                    : _timeRemaining > 5
                        ? Colors.orange
                        : Colors.red,
              ),
              child: Center(
                child: Text(
                  '${_timeRemaining}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                _showQuitConfirmation(context);
              },
              tooltip: LanguageProvider.isEnglish() ? 'Quit' : 'બહાર નીકળો',
            ),
          ],
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
                              Text(
                                LanguageProvider.isEnglish() ? 'Question' : 'પ્રશ્ન',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                question.question,
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
                            final correctIndex = question.getCorrectOptionIndex();
                            final isCorrectOption = optionIndex == correctIndex;
                            final isFeedbackShown =
                                feedbackShown[currentQuestionIndex];
                            final option = question.options[optionIndex];

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

                            return GestureDetector(
                              onTap: (isFeedbackShown || _timeIsUp)
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
                                            option.text,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: getTextColor(),
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
                        const SizedBox(height: 32),
                        // Navigation button - bigger and at top
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: selectedAnswers[currentQuestionIndex] == null || _timeIsUp ? null : _showAnswerFeedback,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedAnswers[currentQuestionIndex] == null ? Colors.grey : (isLastQuestion ? Colors.green : Colors.blueAccent),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              isLastQuestion
                                  ? 'Submit Quiz'
                                  : 'Next Question',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
