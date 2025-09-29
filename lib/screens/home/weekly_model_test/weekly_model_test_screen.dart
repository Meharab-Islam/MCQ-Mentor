import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/exam_scction/exam_item_list_controller.dart';
import 'package:mcq_mentor/screens/rotine/all_routine_screen.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';

class WeeklyModelTestScreen extends StatelessWidget {
  final String title;
  final String description;
  final String examSectionId;
  final String examCategoryId;

  const WeeklyModelTestScreen({
    super.key,
    required this.description,
    required this.title, required this.examSectionId, required this.examCategoryId,
  });

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: CustomAppbar(),
      body:  SingleChildScrollView(
           
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ✅ Title + Info icon
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Icon(Icons.info, size: 20.sp),
                    ],
                  ),
                  Gap(8.h),

                  /// ✅ Description
                  if (description.isNotEmpty && description != 'null')
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                        color: Colors.amber.withAlpha(150),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  Gap(15.h),

                  /// ✅ Wrap for Exam Items
                  Wrap(
                    runSpacing: 10.h,
                    spacing: 10.w,
                    children: [
                        itemCard(context, icon: Icons.rule_outlined, title: 'Routine', onTap: (){
                         Get.to(()=> AllRoutineScreen(
                          examSectionId: examSectionId,
                          examCategoryId: examCategoryId,
                         ));
                        }),
                        itemCard(context, icon: Icons.verified_outlined, title: 'Result'),
                        itemCard(context, icon: Icons.archive_outlined, title: 'Archive'),
                        itemCard(context, icon: Icons.favorite_border, title: 'Favorite'),
                        itemCard(context, icon: Icons.menu_book_rounded, title: 'Syllabus'),
                        itemCard(context, icon: Icons.merge_outlined, title: 'Merit List'),
                        itemCard(context, icon: Icons.picture_as_pdf_outlined, title: 'PDFs'),
                    ],
                  ),

                  /// ✅ Show loading indicator at bottom (pagination)
                 
                ],
              ),
            ),
          ),
        
   
    );
  }

  /// ✅ Card widget for each exam item
  Widget itemCard(
    BuildContext context, {
    String? iconUrl,
    required String title,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2.3,
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: iconUrl != null && iconUrl.isNotEmpty
                  ? Image.network(
                      iconUrl,
                      width: 24.w,
                      height: 24.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.broken_image,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  : Icon(
                      icon ?? Icons.help_outline,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
            ),
            Gap(10.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 15.sp),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:flutter_bounceable/flutter_bounceable.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:mcq_mentor/controller/exam_scction/exam_item_list_controller.dart';
// import 'package:mcq_mentor/widget/custom_appbar.dart';

// class WeeklyModelTestScreen extends StatelessWidget {
//   const WeeklyModelTestScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     ExamItemListController singleExamSectionController =
//         Get.put(ExamItemListController());

//     return Scaffold(
//       appBar: CustomAppbar(),
//       body: Obx(() {
//         final examData = singleExamSectionController.itemList.value;

//         if (singleExamSectionController.isLoading.value) {
//           return const Center(child: CircularProgressIndicator.adaptive());
//         } else if (examData == null || examData.data.examItemLists.isEmpty) {
//           return const Center(child: Text("No Data found"));
//         } else {
//           return SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 15.w),
//               child: Center(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       examData.data.name,
//                       style: TextStyle(
//                         fontSize: 20.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Gap(5.h),
//                     Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.all(10.sp),
//                       decoration: BoxDecoration(
//                         color: Colors.amber,
//                         borderRadius: BorderRadius.circular(10.r),
//                       ),
//                       child: Center(
//                         child: Text(
//                           examData.data.description == null
//                               ? "No description available"
//                               : examData.data.description.toString(),
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(color: Colors.black),
//                         ),
//                       ),
//                     ),
//                     Gap(10.h),

//                     /// ✅ Dynamic list from API
//                     Wrap(
//                       runSpacing: 10.h,
//                       spacing: 10.w,
//                       children: examData.data.examItemLists.map((item) {
//                         return itemCard(
//                           context,
//                           iconUrl: item.icon,
//                           title: item.name,
//                         );
//                       }).toList(),
//                     ),

//                     /// ❌ Hardcoded version (commented out)
//                     /*
//                     Wrap(
//                       runSpacing: 10.h,
//                       spacing: 10.w,
//                       runAlignment: WrapAlignment.spaceBetween,
//                       crossAxisAlignment: WrapCrossAlignment.center,
//                       children: [
                        // itemCard(context, icon: Icons.rule_outlined, title: 'Routine'),
                        // itemCard(context, icon: Icons.verified_outlined, title: 'Result'),
                        // itemCard(context, icon: Icons.archive_outlined, title: 'Archive'),
                        // itemCard(context, icon: Icons.favorite_border, title: 'Favorite'),
                        // itemCard(context, icon: Icons.menu_book_rounded, title: 'Syllabus'),
                        // itemCard(context, icon: Icons.merge_outlined, title: 'Merit List'),
                        // itemCard(context, icon: Icons.picture_as_pdf_outlined, title: 'PDFs'),
//                       ],
//                     )
//                     */
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }
//       }),
//     );
//   }

//   /// Updated item card to support API icon
//   Widget itemCard(BuildContext context,
//       {String? iconUrl, required String title, IconData? icon}) {
//     return Bounceable(
//       onTap: () {
//         // TODO: Add navigation or action based on item
//       },
//       child: Container(
//         width: MediaQuery.of(context).size.width / 2.3,
//         padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.secondary,
//           borderRadius: BorderRadius.circular(10.r),
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: Theme.of(context).colorScheme.onPrimary,
//               child: iconUrl != null && iconUrl.isNotEmpty
//                   ? Image.network(iconUrl, width: 24.w, height: 24.h)
//                   : Icon(
//                       icon ?? Icons.help_outline,
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//             ),
//             Gap(10.w),
//             Expanded(
//               child: Text(
//                 title,
//                 style: TextStyle(fontSize: 15.sp),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
