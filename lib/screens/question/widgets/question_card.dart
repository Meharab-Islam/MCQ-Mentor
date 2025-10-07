import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:mcq_mentor/screens/question/widgets/analytics_section.dart';
import 'package:mcq_mentor/screens/question/widgets/explanation_dialog.dart';
import 'package:mcq_mentor/screens/question/widgets/option_tile.dart';

class QuestionCard extends StatelessWidget {
  final dynamic question;
  final bool showCorrect;
  final bool showAnalytics;
  final bool isFavorite;
  final VoidCallback onToggleCorrect;
  final VoidCallback onToggleAnalytics;
  final VoidCallback onToggleFavorite;

  const QuestionCard({
    super.key,
    required this.question,
    required this.showCorrect,
    required this.showAnalytics,
    required this.isFavorite,
    required this.onToggleCorrect,
    required this.onToggleAnalytics,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final correctAnswer = (question.correctAnswer ?? "")
        .toString()
        .trim()
        .toLowerCase();
    (question.options ?? [])
        .map((e) => e?.toString() ?? "")
        .toList();
    final List optionList = (question.options ?? [])
        .map((e) => e?.toString() ?? "")
        .toList();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Get.theme.colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🧠 Question Text
                Html(
                  data: question.question ?? "No question text",
                  style: {
                    "p": Style(
                      fontSize: FontSize(18),
                      color: Get.isDarkMode ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                   
                  },
                ),
                const SizedBox(height: 12),

                /// 🧩 Options
                Column(
                  children: optionList.map((option) {
                    final isCorrect =
                        showCorrect && option.toLowerCase() == correctAnswer;
                    return OptionTile(option: option, isCorrect: isCorrect);
                  }).toList(),
                ),

                const SizedBox(height: 12),

                /// 🔘 Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onPressed: onToggleCorrect,
                      icon: Icon(
                        showCorrect
                            ? Icons.visibility_off
                            : Icons.check_circle_outline,
                      ),
                      label: Text(showCorrect ? "Hide Answer" : "Show Correct"),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blueAccent.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onPressed: onToggleAnalytics,
                      icon: AnimatedRotation(
                        turns: showAnalytics ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: const Icon(Icons.pie_chart),
                      ),
                      label: Text(showAnalytics ? "Hide" : "Analytics"),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.orange.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onPressed: () => showExplanationDialog(
                        context,
                        question.explanation ?? "",
                      ),
                      icon: const Icon(Icons.info_outline),
                      label: const Text("Explain"),
                    ),
                  ],
                ),

                /// 📊 Analytics
                AnalyticsSection(showAnalytics: showAnalytics),
              ],
            ),
          ),

          /// ❤️ Favorite button top-right
          Positioned(
            top: 2,
            right: 1,
            child: LikeButton(
              size: 32,
              isLiked: isFavorite,
              onTap: (isLiked) async {
                onToggleFavorite();
                return !isLiked;
              },
              circleColor: const CircleColor(
                start: Colors.pinkAccent,
                end: Colors.pinkAccent,
              ),
              bubblesColor: const BubblesColor(
                dotPrimaryColor: Colors.redAccent,
                dotSecondaryColor: Colors.pinkAccent,
              ),
              likeBuilder: (bool isLiked) {
                return Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border_rounded,
                  color: isLiked ? Colors.redAccent : Colors.grey.shade400,
                  size: 32,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
