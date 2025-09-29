import 'package:get/get.dart';

class ProfileController extends GetxController {
  var user = {
    "name": "Meharab Islam",
    "email": "mdnibir178@gmail.com",
    "gender": "Male",
    "age": "20",
    "phone": "+880 1837387206",
    "address": "Faridpur Shadar, Faridpur",
    "date_of_birth": "20-12-2005",
    "image": "https://media.gettyimages.com/id/700712087/photo/mixed-race-woman-dancing.jpg?s=612x612&w=gi&k=20&c=wq3ZFeX7-Bh77ZPJqNlhbpoGGrP8DV-EnFQdG_sZ0Ek=",
  }.obs;

  var packages = <Map<String, dynamic>>[
    {"name": "Basic Package", "expiry": "2025-12-31"},
    {"name": "Premium Package", "expiry": "2026-06-30"},
  ].obs;

  var exams = <Map<String, dynamic>>[
    {"title": "Mathematics Final", "score": 85, "status": "Completed"},
    {"title": "English Quiz", "score": 70, "status": "Completed"},
    {"title": "Science Exam", "score": 0, "status": "Pending"},
  ].obs;
}
