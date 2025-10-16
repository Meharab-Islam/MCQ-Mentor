import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:mcq_mentor/controller/favorite/favorite_controller.dart';
import 'package:mcq_mentor/controller/favorite/favorite_question_list_controller.dart';
import 'package:mcq_mentor/model/favorite/favorite_list_question_model.dart';
import 'package:mcq_mentor/screens/question/widgets/analytics_section.dart';
import 'package:mcq_mentor/screens/question/widgets/explanation_dialog.dart';
import 'package:mcq_mentor/screens/question/widgets/option_tile.dart';

class FavoriteListScreen extends StatefulWidget {
  final int? sectionId;
  final int? categoryId;
  final int? archiveId;

  const FavoriteListScreen({
    super.key,
    this.sectionId = 0,
    this.categoryId = 0,
    this.archiveId = 0,
  });

  @override
  State<FavoriteListScreen> createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
  final FavoriteListController favoriteListController = Get.put(
    FavoriteListController(),
  );
  final FavoriteController favoriteController = Get.put(FavoriteController());
  final ScrollController _scrollController = ScrollController();

  final RxMap<int, bool> showCorrectMap = <int, bool>{}.obs;
  final RxMap<int, bool> showAnalyticsMap = <int, bool>{}.obs;

  @override
  void initState() {
    super.initState();

    // Initial fetch
    favoriteListController.fetchFavorites(
      sectionId: widget.sectionId!,
      categoryId: widget.categoryId!,
      archiveId: widget.archiveId!,
    );

    // Pagination listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !favoriteListController.isLoading.value &&
          favoriteListController.hasNextPage) {
        favoriteListController.fetchFavorites(
          sectionId: widget.sectionId!,
          categoryId: widget.categoryId!,
          archiveId: widget.archiveId!,
          page: favoriteListController.currentPage + 1,
        );
      }
    });
  }

  List<String> getOptionLabels(String? template) {
    if (template?.toLowerCase() == "bangla") {
      return ["ক", "খ", "গ", "ঘ", "ঙ", "চ", "ছ", "জ"];
    } else {
      return ["A", "B", "C", "D", "E", "F", "G", "H"];
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites"), centerTitle: true),
      body: Obx(() {
        if (favoriteListController.isLoading.value &&
            favoriteListController.favorites.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: Get.theme.colorScheme.onPrimary,
            ),
          );
        }

        if (favoriteListController.favorites.isEmpty) {
          return const Center(child: Text("No favorites found"));
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount:
              favoriteListController.favorites.length +
              (favoriteListController.hasNextPage ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < favoriteListController.favorites.length) {
              final FavoriteQuestionModel question =
                  favoriteListController.favorites[index];

              // Initialize toggle maps
              showCorrectMap.putIfAbsent(question.id, () => false);
              showAnalyticsMap.putIfAbsent(question.id, () => false);

              final correctAnswer = question.correctAnswer
                  .toString()
                  .trim()
                  .toLowerCase();
              final optionList = question.options;
              final labels = getOptionLabels("bangla"); // or dynamic template

              return Obx(
                () => AnimatedContainer(
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
                        /// Question Text (supports HTML)
                        Builder(
                          builder: (_) {
                            final text = question.question;
                            final isHtml = text.contains(RegExp(r"<[^>]+>"));
                            if (isHtml) {
                              return Html(
                                data: text,
                                style: {
                                  "p": Style(
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                    fontSize: FontSize(20.sp),
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                },
                              );
                            } else {
                              return Text(
                                text,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 12),

                        /// Options
                        Column(
                          children: optionList.asMap().entries.map((entry) {
                            final index = entry.key;
                            final option = entry.value;
                            final isCorrect =
                                showCorrectMap[question.id]! &&
                                option.toLowerCase() == correctAnswer;
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

                        /// Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// Correct Answer Button
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              onPressed: () {
                                showCorrectMap[question.id] =
                                    !showCorrectMap[question.id]!;
                              },
                              icon: Icon(
                                showCorrectMap[question.id]!
                                    ? Icons.visibility_off
                                    : Icons.check_circle_outline,
                              ),
                              label: Text(
                                showCorrectMap[question.id]!
                                    ? "Hide Answer"
                                    : "Correct Answer",
                              ),
                            ),

                            /// Favorite Button
                            LikeButton(
                              size: 35.sp,
                              isLiked: question
                                  .favorite, // use actual favorite state from your model
                              onTap: (isLiked) async {
                                // First toggle on the server
                                await favoriteController.toggleFavorite(
                                  sectionId: int.parse(question.examSectionId),
                                  categoryId: int.parse(
                                    question.examCategoryId,
                                  ),
                                  archiveId: int.parse(question.archiveId),
                                  questionId: question.id,
                                );

                                // Then remove locally from the list immediately
                                favoriteListController.removeFavorite(
                                  questionId: question.id,
                                );

                                // Update UI state (return opposite of current)

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

                            /// Explanation Button
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
                                question.explanation,
                              ),
                              icon: const Icon(Icons.info_outline),
                              label: const Text("Explanation"),
                            ),
                          ],
                        ),

                        /// Analytics Section
                        AnalyticsSection(
                          showAnalytics: showAnalyticsMap[question.id]!,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        );
      }),
    );
  }
}
