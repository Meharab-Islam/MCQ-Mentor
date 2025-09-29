class ApiEndpoint {
  static const String baseUrl = 'http://192.168.110.188:8000/api';
  static const String login = '$baseUrl/login';
  static const String register = '$baseUrl/register';
  static const String forgotPassword = '$baseUrl/forget-password';
  static const String resetPassword = '$baseUrl/reset-password';
  static const String verifyOtp = '$baseUrl/verify-otp';
  static const String resendOtp = '$baseUrl/resend-otp';
  static const String examSection = '$baseUrl/ExamSections';
  static const String studySection = '$baseUrl/StudySection';
  static const String singleExamSection = '$baseUrl/ExamSections/';
  static const String allCategoryList = '$baseUrl/ExamCategory';
  static const String singleCategoryDetails = '$baseUrl/ExamCategory/';
  static const String examItemList = '$baseUrl/exam-item-list';
  static const String allRoutine = '$baseUrl/routines';
}