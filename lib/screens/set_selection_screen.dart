import 'package:flutter/material.dart';
import '../models.dart';
import '../language_provider.dart';

class SetSelectionScreen extends StatelessWidget {
  final Shastra shastra;

  const SetSelectionScreen({
    super.key,
    required this.shastra,
  });

  Color _getDifficultyColor(String level) {
    if (level.contains('1')) {
      return Colors.green;
    } else if (level.contains('2')) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _getDifficultyLabel(String level) {
    if (level.contains('1')) {
      return 'Easy';
    } else if (level.contains('2')) {
      return 'Medium';
    } else {
      return 'Hard';
    }
  }

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
            // Header with Back Button
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/language-selection');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.language,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    LanguageProvider.isEnglish() ? shastra.nameEnglish : shastra.nameGujarati,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    LanguageProvider.isEnglish() ? shastra.nameGujarati : shastra.nameEnglish,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    LanguageProvider.isEnglish() ? 'Select Difficulty Level' : 'મુશ્કેલીનું સ્તર પસંદ કરો',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            // Difficulty Sets
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                itemCount: _getFilteredSets().length,
                itemBuilder: (context, index) {
                  final set = _getFilteredSets()[index];
                  final difficulty = set.questions.isNotEmpty
                      ? set.questions.first.level
                      : '1.0';
                  final color = _getDifficultyColor(difficulty);
                  final difficultyLabel = _getDifficultyLabel(difficulty);

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/quiz',
                        arguments: {
                          'set': set,
                          'difficulty': difficulty,
                          'shastraName': shastra.nameEnglish,
                        },
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  color.withOpacity(0.15),
                                  color.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          difficultyLabel,
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: color,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Level ${_getLevelNumber(difficulty)}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        _getDifficultyIcon(difficulty),
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  LanguageProvider.isEnglish() ? set.descriptionEnglish : set.descriptionGujarati,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  LanguageProvider.isEnglish() ? set.descriptionGujarati : set.descriptionEnglish,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ],
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

  int _getLevelNumber(String level) {
    if (level.contains('1')) return 1;
    if (level.contains('2')) return 2;
    return 3;
  }

  IconData _getDifficultyIcon(String difficulty) {
    if (difficulty.contains('1')) {
      return Icons.emoji_events;
    } else if (difficulty.contains('2')) {
      return Icons.local_fire_department;
    } else {
      return Icons.flash_on;
    }
  }

  List<QuestionSet> _getFilteredSets() {
    final isEnglish = LanguageProvider.isEnglish();
    return shastra.sets
        .where((set) =>
            (isEnglish && set.id.contains('english')) ||
            (!isEnglish && set.id.contains('gujarati')))
        .toList();
  }
}
