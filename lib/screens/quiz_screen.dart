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

  @override
  void initState() {
    super.initState();
    // Get questions by difficulty and randomize 10 of them
    final filtered = widget.set.getQuestionsByDifficulty(widget.difficulty);
    questions = (filtered..shuffle()).take(10).toList();
    selectedAnswers = List.filled(questions.length, null);
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
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
                            final option = question.options[optionIndex];
                            final optionGuj = question.optionsGujarati[optionIndex];

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedAnswers[currentQuestionIndex] =
                                      optionIndex;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blueAccent
                                      : Colors.white,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.blueAccent
                                        : Colors.grey[300]!,
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
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey[400]!,
                                          width: 2,
                                        ),
                                        color: isSelected
                                            ? Colors.blueAccent
                                            : Colors.transparent,
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 14,
                                            )
                                          : null,
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
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            optionGuj,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: isSelected
                                                  ? Colors.white70
                                                  : Colors.black54,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed:
                          currentQuestionIndex > 0 ? _previousQuestion : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                    isLastQuestion
                        ? ElevatedButton(
                            onPressed: _submitQuiz,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: _nextQuestion,
                            label: const Text('Next'),
                            icon: const Icon(Icons.arrow_forward),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
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
