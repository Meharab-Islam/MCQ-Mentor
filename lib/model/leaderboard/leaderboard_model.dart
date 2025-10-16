class LeaderboardModel {
  final bool success;
  final String message;
  final List<LeaderboardUser> data;

  LeaderboardModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => LeaderboardUser.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class LeaderboardUser {
  final int userId;
  final String name;
  final String email;
  final String image;
  final String totalExamsAttended;
  final String notGivenExams;
  final String totalObtainedMarks;
  final String totalAnsweredQuestions;
  final String totalCorrectAnswers;
  final String totalWrongAnswers;

  LeaderboardUser({
    required this.userId,
    required this.name,
    required this.email,
    required this.image,
    required this.totalExamsAttended,
    required this.notGivenExams,
    required this.totalObtainedMarks,
    required this.totalAnsweredQuestions,
    required this.totalCorrectAnswers,
    required this.totalWrongAnswers,
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      totalExamsAttended: json['total_exams_attended'] ?? "0",
      notGivenExams: json['not_given_exams'] ?? "0",
      totalObtainedMarks: json['total_obtained_marks'] ?? "0",
      totalAnsweredQuestions: json['total_answered_questions'] ?? "0",
      totalCorrectAnswers: json['total_correct_answers'] ?? "0",
      totalWrongAnswers: json['total_wrong_answers'] ?? "0",
    );
  }
}
