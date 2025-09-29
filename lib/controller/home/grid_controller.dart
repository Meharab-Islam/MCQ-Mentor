import 'package:get/get.dart';

class GridController extends GetxController {
  final List<String> items = List.generate(20, (index) => 'Item ${index + 1}');

  // You can add methods here to handle logic,
  // like adding/removing items or fetching data from an API.
}