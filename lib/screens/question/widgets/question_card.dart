import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:mcq_mentor/controller/favorite/favorite_controller.dart';
import 'package:mcq_mentor/screens/question/widgets/analytics_section.dart';
import 'package:mcq_mentor/screens/question/widgets/explanation_dialog.dart';
import 'package:mcq_mentor/screens/question/widgets/option_tile.dart';

class QuestionCard extends StatelessWidget {
  final dynamic question;
  final bool showCorrect;
  final bool? isShowAnalytics;
  final bool showAnalytics;
  final bool? isShowFavorite;
  final bool isFavorite;
  final VoidCallback onToggleCorrect;
  final VoidCallback onToggleAnalytics;

  final int? sectionId;
  final int? categoryId;
  final int? archiveId;

  const QuestionCard({
    super.key,
    required this.question,
    required this.showCorrect,
    required this.showAnalytics,
    this.isShowFavorite = true,
    this.isShowAnalytics = true,
    required this.isFavorite,
    required this.onToggleCorrect,
    required this.onToggleAnalytics,
    this.sectionId = 0,
    this.categoryId = 0,
    this.archiveId = 0,
  });

  // 🔠 Function to choose labels
  List<String> getOptionLabels(String? template) {
    if (template?.toLowerCase() == "bangla") {
      return ["ক", "খ", "গ", "ঘ", "ঙ", "চ", "ছ", "জ"];
    } else {
      return ["A", "B", "C", "D", "E", "F", "G", "H"];
    }
  }

  @override
  Widget build(BuildContext context) {
    FavoriteController favoriteController = Get.put(FavoriteController());
    final correctAnswer = (question.correctAnswer ?? "")
        .toString()
        .trim()
        .toLowerCase();

    final List optionList = (question.options ?? [])
        .map((e) => e?.toString() ?? "")
        .toList();

    final labels = getOptionLabels(question.template);

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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🧠 Question Text
            /// 🧠 Question Text
            Builder(
              builder: (_) {
                final text = question.question ?? "No question text";
                final bool isHtml = text.contains(
                  RegExp(r"<[^>]+>"),
                ); // detect HTML tags

                if (isHtml) {
                  // 🧩 Render HTML content
                  return Html(
                    data: text,
                    style: {
                      "html": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      "body": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      "p": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        fontSize: FontSize(20.sp),
                        color: Get.isDarkMode ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      "div": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      "span": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                    },
                  );
                } else {
                  // 📝 Render plain text
                  return Text(
                    text,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Get.isDarkMode ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 12),

            /// 🧩 Options Section (with Bangla or English labels)
            Column(
              children: optionList.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                final isCorrect =
                    showCorrect && option.toLowerCase() == correctAnswer;

                final label = index < labels.length
                    ? labels[index]
                    : (index + 1).toString();

                return OptionTile(
                  option: option,
                  isCorrect: isCorrect,
                  label: label,
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            /// 🔘 Action Buttons
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
                  label: Text(showCorrect ? "Hide Answer" : "Correct Answer"),
                ),
                if (isShowAnalytics == true)
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
                if (isShowFavorite == true)
                  LikeButton(
                    size: 35.sp,
                    isLiked:
                        isFavorite, // use actual favorite state from your model
                    onTap: (isLiked) async {
                      // Call your controller to toggle favorite
                      await favoriteController.toggleFavorite(
                        sectionId: sectionId!,
                        categoryId: categoryId!,
                        archiveId: archiveId!,
                        questionId: question.id,
                      );

                      // Update local favorite state after toggling
                      question.favorite = !isLiked;

                      // Return new state to update LikeButton UI
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
                        isLiked
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        color: isLiked
                            ? Colors.redAccent
                            : Colors.grey.shade400,
                        size: 35.sp,
                      );
                    },
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
                  label: const Text("Explanation"),
                ),
              ],
            ),

            /// 📊 Analytics Section
            AnalyticsSection(showAnalytics: showAnalytics),
          ],
        ),
      ),
    );
  }
}
