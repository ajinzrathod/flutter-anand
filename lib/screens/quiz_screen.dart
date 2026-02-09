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
  late List<String> selectedAnswers;
  int currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    // Get questions by difficulty and randomize 10 of them
    final filtered = widget.set.getQuestionsByDifficulty(widget.difficulty);
    questions = (filtered..shuffle()).take(10).toList();
    selectedAnswers = List.filled(questions.length, '');
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
      final isCorrect = selectedAnswers[i]
          .toLowerCase()
          .trim()
          .compareTo(questions[i].answerEnglish.toLowerCase().trim()) ==
          0 ||
          selectedAnswers[i]
              .toLowerCase()
              .trim()
              .compareTo(questions[i].answerGujarati.toLowerCase().trim()) ==
              0;

      if (isCorrect) {
        correctCount++;
      }

      answers.add(
        QuestionAnswer(
          question: questions[i],
          userAnswer: selectedAnswers[i],
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

    return WillPopScope(
      onWillPop: () async => false, // Prevent going back
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
                        // Answer input
                        const Text(
                          'Your Answer',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          onChanged: (value) {
                            selectedAnswers[currentQuestionIndex] = value;
                          },
                          controller: TextEditingController(
                            text: selectedAnswers[currentQuestionIndex],
                          ),
                          decoration: InputDecoration(
                            hintText: 'Type your answer...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.blueAccent,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.blueAccent,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          minLines: 3,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 24),
                        // Hint box
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.blue[200]!,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hint (Answers)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'English: ${question.answerEnglish}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Gujarati: ${question.answerGujarati}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
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
                      onPressed: currentQuestionIndex > 0 ? _previousQuestion : null,
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
