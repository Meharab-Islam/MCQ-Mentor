import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/pdf/all_category_list_for_pdf_controller.dart';
import 'package:mcq_mentor/screens/pdf/all_pdf_list_screen.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';

class PdfCategoryListScreen extends StatelessWidget {
  final AllCategoryListForPdfController controller = Get.put(AllCategoryListForPdfController());

  @override
  Widget build(BuildContext context) {
    controller.fetchAllCategoriesForPdf();

    return Scaffold(
      appBar: CustomAppbar(
        title: "PDF Category",
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary,));
        }

        if (controller.categoryList.isEmpty) {
          return const Center(child: Text('কোনো বিষয় পাওয়া যায়নি'));
        }

        return ListView.builder(
          itemCount: controller.categoryList.length,
          itemBuilder: (context, index) {
            final category = controller.categoryList[index];
            return Bounceable(
              onTap: (){
                Get.to(()=> PdfListPage(categoryId: category.id,));
              },
              child: Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                color: Get.theme.colorScheme.secondary,
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: 10.h),
                  child: Center(child: Text(category.name, style: TextStyle(
                    fontSize: 15.sp
                  ),)),
                ),
                      
                
              ),
            );
          },
        );
      }),
    );
  }
}
