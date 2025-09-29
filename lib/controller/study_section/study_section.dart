import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for Study Section
class StudyController extends GetxController {
  var sections = <Map<String, dynamic>>[
    {"id": 1, "icon": Icons.video_collection, "name": "Video Section"},
    {"id": 2, "icon": Icons.picture_as_pdf, "name": "PDF Section"},
    {"id": 3, "icon": Icons.article, "name": "সংশোধনী পোস্ট"},
    {"id": 4, "icon": Icons.audiotrack, "name": "Audio Section"},
    {"id": 5, "icon": Icons.group, "name": "Study Group"},
    {"id": 6, "icon": Icons.book, "name": "Book Store"},
  ].obs;
}
