import 'package:flutter/material.dart';
import '../models.dart';

class SetSelectionScreen extends StatefulWidget {
  final Shastra shastra;

  const SetSelectionScreen({
    super.key,
    required this.shastra,
  });

  @override
  State<SetSelectionScreen> createState() => _SetSelectionScreenState();
}

class _SetSelectionScreenState extends State<SetSelectionScreen> {
  DifficultyLevel selectedDifficulty = DifficultyLevel.easy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple[400]!, Colors.purple[800]!],
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    widget.shastra.nameEnglish,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select a set to continue',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
            // Difficulty Selection
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Difficulty Level:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _difficultyButton(
                        DifficultyLevel.easy,
                        'Easy',
                        Colors.green,
                      ),
                      _difficultyButton(
                        DifficultyLevel.medium,
                        'Medium',
                        Colors.orange,
                      ),
                      _difficultyButton(
                        DifficultyLevel.hard,
                        'Hard',
                        Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Sets List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: widget.shastra.sets.length,
                itemBuilder: (context, index) {
                  final set = widget.shastra.sets[index];
                  final questionsInDifficulty =
                      set.getQuestionsByDifficulty(selectedDifficulty);

                  return GestureDetector(
                    onTap: questionsInDifficulty.isEmpty
                        ? null
                        : () {
                            Navigator.of(context).pushNamed(
                              '/quiz',
                              arguments: {
                                'set': set,
                                'difficulty': selectedDifficulty,
                                'shastraName': widget.shastra.nameEnglish,
                              },
                            );
                          },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    set.nameEnglish,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    set.nameGujarati,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Chip(
                                    label: Text(
                                      '${questionsInDifficulty.length} Questions',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    backgroundColor: Colors.purple,
                                  ),
                                ],
                              ),
                            ),
                            questionsInDifficulty.isEmpty
                                ? Tooltip(
                                    message:
                                        'No questions in this difficulty',
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.lock,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.purple[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.purple,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _difficultyButton(
    DifficultyLevel level,
    String label,
    Color color,
  ) {
    final isSelected = selectedDifficulty == level;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDifficulty = level;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}
