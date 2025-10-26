import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:mcq_mentor/controller/leaderboard/leaderboard_controller.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LeaderboardController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏆 Leaderboard'),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Get.theme.colorScheme.onPrimary,
            ),
          );
        }

        if (controller.leaderboard.isEmpty) {
          return const Center(child: Text('No leaderboard data found'));
        }

        return RefreshIndicator(
          color: Get.theme.colorScheme.onPrimary,
          onRefresh: () async => controller.fetchLeaderboard(),
          child: ListView.builder(
              padding: EdgeInsets.only(
    left: 12.w,
    right: 12.w,
    top: 8.h,
    bottom: 100.h, // ✅ 40px space after last item
  ),
            itemCount: controller.leaderboard.length,
            itemBuilder: (context, index) {
              final user = controller.leaderboard[index];
              return LeaderboardCard(
                user: user,
                rank: index + 1,
                isTopUser: index == 0,
              );
            },
          ),
        );
      }),
    );
  }
}

class LeaderboardCard extends StatelessWidget {
  final dynamic user;
  final int rank;
  final bool isTopUser;

  const LeaderboardCard({
    super.key,
    required this.user,
    required this.rank,
    this.isTopUser = false,
  });

  @override
  Widget build(BuildContext context) {
    double accuracy = 0;
    final totalAnswered = int.tryParse(user.totalAnsweredQuestions ?? '0') ?? 0;
    final totalCorrect = int.tryParse(user.totalCorrectAnswers ?? '0') ?? 0;

    if (totalAnswered > 0) {
      accuracy = totalCorrect / totalAnswered;
    }

    return Card(
      elevation: isTopUser ? 10 : 4,
      shadowColor: isTopUser
          ? Get.theme.colorScheme.onPrimary
          : Colors.grey.shade400,
      margin: EdgeInsets.symmetric(vertical: 6.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rank & Avatar
            Row(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    // Square profile image
                    Container(
                      width: 90.w,
                      height: 110.w,
                      decoration: BoxDecoration(
                        gradient: _avatarGradient(rank),
                        boxShadow: [
                          BoxShadow(
                            color: _rankShadow(rank),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            (user.image != null && user.image!.isNotEmpty)
                                ? user.image!
                                : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    // Rank Badge
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: _rankColor(rank),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            if (rank == 1)
                              Icon(
                                Icons.emoji_events,
                                size: 16.sp,
                                color: Colors.white,
                              ),
                            Text(
                              "#$rank",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                      Gap(10.h),
                      Text(
                        "Total Marks: ${user.totalObtainedMarks ?? '0'}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: isTopUser
                              ? Colors.amber[800]
                              : Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(12.h),
            Divider(color: Colors.grey.shade300),
            Gap(6.h),
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem(
                  Icons.task,
                  "Exams",
                  user.totalExamsAttended.toString(),
                ),
                _statItem(
                  Icons.check_circle,
                  "Correct",
                  user.totalCorrectAnswers.toString(),
                ),
                _statItem(
                  Icons.cancel,
                  "Wrong",
                  user.totalWrongAnswers.toString(),
                ),
                _statItem(
                  Icons.help_outline,
                  "Not Given",
                  user.notGivenExams.toString(),
                ),
              ],
            ),
            Gap(12.h),
            // Accuracy bar
            LinearPercentIndicator(
              lineHeight: 10.h,
              percent: accuracy.clamp(0, 1),
              progressColor: Colors.green,
              backgroundColor: Colors.grey.shade300,
              barRadius: Radius.circular(20.r),
              animation: true,
            ),
            Gap(6.h),
            Text(
              "Accuracy: ${(accuracy * 100).toStringAsFixed(1)}%",
              style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Gradient _avatarGradient(int rank) {
    switch (rank) {
      case 1:
        return const LinearGradient(colors: [Colors.amber, Colors.orange]);
      case 2:
        return const LinearGradient(colors: [Colors.grey, Colors.blueGrey]);
      case 3:
        return const LinearGradient(colors: [Colors.brown, Colors.deepOrange]);
      default:
        return const LinearGradient(colors: [Colors.blueAccent, Colors.cyan]);
    }
  }

  Color _rankShadow(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber.withOpacity(0.4);
      case 2:
        return Colors.grey.withOpacity(0.4);
      case 3:
        return Colors.brown.withOpacity(0.4);
      default:
        return Colors.blueAccent.withOpacity(0.3);
    }
  }

  Color _rankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return Colors.blueGrey;
    }
  }

  Widget _statItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 20.sp, color: Colors.blueAccent),
        Text(
          value,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
