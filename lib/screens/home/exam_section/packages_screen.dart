import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:animate_do/animate_do.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart'; // Assumed from your code
import 'package:mcq_mentor/widget/custom_drawer.dart'; // Assumed from your code

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(10.h),
            // Special Package Banner
            FadeInDown(child: _buildSpecialPackageBanner()),
            Gap(20.h),

            // Premium Packages Section
            FadeInLeft(child: _buildSectionHeader('Premium Packages')),
            Gap(10.h),
            FadeInUp(child: _buildPremiumPackagesList()),
            Gap(20.h),

            // Special Packages Section
            FadeInLeft(child: _buildSectionHeader('Special Packages')),
            Gap(10.h),
            FadeInUp(child: _buildSpecialPackagesList()),
            Gap(20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSpecialPackageBanner() {
    return Card(
      elevation: 4,
      color: Colors.yellow.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildSectionHeader('৪৭তম স্পেশাল বিসিএস (শিক্ষা) প্যাকেজ'),
            Gap(10.h),
            _buildTwoButtonRow('৪৭তম বিসিএস - ফুল', '৳ ৯৯৯'),
            Gap(10.h),
            _buildTwoButtonRow('৪৭তম বিসিএস - বিষয়ভিত্তিক', '৳ ৪৯৯'),
          ],
        ),
      ),
    );
  }

  Widget _buildTwoButtonRow(String label, String price) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
                side: const BorderSide(color: Colors.grey),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: Text(label, style: TextStyle(fontSize: 16.sp)),
          ),
        ),
        Gap(10.w),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
              side: const BorderSide(color: Colors.grey),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          ),
          child: Text(price, style: TextStyle(fontSize: 16.sp)),
        ),
      ],
    );
  }

  Widget _buildPackageItem({
    required String title,
    required String period,
    required String features,
    required double oldPrice,
    required double newPrice,
    required double discountPercentage,
    bool isSpecial = false,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  Gap(4.h),
                  Text('মেয়াদ: $period', style: TextStyle(fontSize: 14.sp)),
                  Gap(4.h),
                  Text(features, style: TextStyle(fontSize: 12.sp)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${newPrice.toStringAsFixed(0)} টাকা',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.blue)),
                Text('${oldPrice.toStringAsFixed(0)} টাকা',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                Text('Save ${discountPercentage.toStringAsFixed(2)}%',
                    style: TextStyle(fontSize: 12.sp, color: Colors.green)),
                Gap(8.h),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                  ),
                  child: Text('প্যাকেজ কিনুন', style: TextStyle(color: Colors.white, fontSize: 12.sp)),
                ),
              ],
            ),
            if (isSpecial)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.r),
                      bottomLeft: Radius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'Special',
                    style: TextStyle(color: Colors.white, fontSize: 10.sp),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  // This is a placeholder list to replicate the UI. You'd likely fetch this from an API.
  Widget _buildPremiumPackagesList() {
    return Column(
      children: [
        _buildPackageItem(
          title: '৪ বছর মেয়াদী স্বাধীন প্রিমিয়াম',
          period: '৪ বছর',
          features: 'সকল লাইভ + আর্কাইভড এক্সাম ও প্রিমিয়াম সার্ভিস',
          oldPrice: 5996,
          newPrice: 2999,
          discountPercentage: 49.98,
        ),
        _buildPackageItem(
          title: '৩ বছর মেয়াদী স্বাধীন প্রিমিয়াম',
          period: '৩ বছর',
          features: 'সকল লাইভ + আর্কাইভড এক্সাম ও প্রিমিয়াম সার্ভিস',
          oldPrice: 4497,
          newPrice: 2599,
          discountPercentage: 42.21,
        ),
        _buildPackageItem(
          title: '২ বছর মেয়াদী স্বাধীন প্রিমিয়াম',
          period: '২ বছর',
          features: 'সকল লাইভ + আর্কাইভড এক্সাম ও প্রিমিয়াম সার্ভিস',
          oldPrice: 2998,
          newPrice: 1999,
          discountPercentage: 33.32,
        ),
        _buildPackageItem(
          title: 'বার্ষিক প্রিমিয়াম প্যাকেজ',
          period: '১ বছর',
          features: 'সকল লাইভ + আর্কাইভড এক্সাম ও প্রিমিয়াম সার্ভিস',
          oldPrice: 2388,
          newPrice: 1499,
          discountPercentage: 37.23,
        ),
         _buildPackageItem(
          title: 'ত্রৈমাসিক প্রিমিয়াম প্যাকেজ',
          period: '৩ মাস',
          features: 'সকল লাইভ + আর্কাইভড এক্সাম ও প্রিমিয়াম সার্ভিস (ভিডিও ক্লাস ছাড়া)',
          oldPrice: 597,
          newPrice: 550,
          discountPercentage: 7.87,
        ),
         _buildPackageItem(
          title: 'মাসিক প্রিমিয়াম প্যাকেজ',
          period: '৩০ দিন',
          features: 'সকল লাইভ + আর্কাইভড এক্সাম ও প্রিমিয়াম সার্ভিস (ভিডিও ক্লাস ছাড়া)',
          oldPrice: 199,
          newPrice: 199,
          discountPercentage: 0,
        ),
      ],
    );
  }

  Widget _buildSpecialPackagesList() {
    return Column(
      children: [
        _buildPackageItem(
          title: '৪৭তম বিসিএস ফাইনাল মডেল টেস্ট',
          period: '৪৭তম বিসিএস প্রিলিমিনারি কোচিংয়ের সকল লাইভ ও আর্কাইভড পরীক্ষা + নির্দিষ্ট স্টাডি ম্যাটেরিয়ালস',
          oldPrice: 0,
          newPrice: 299,
          discountPercentage: 0, features: '',
        ),
        _buildPackageItem(
          title: 'ব্যাংক প্রস্তুতি প্যাকেজ [বার্ষিক]',
          period: '১ বছর',
          features: 'ব্যাংকিং-এর সকল পরীক্ষা ও ক্লাস',
          oldPrice: 0,
          newPrice: 798,
          discountPercentage: 0,
        ),
        _buildPackageItem(
          title: '১৯তম জুডিশিয়াল সার্ভিস (BJS)',
          period: '১৯তম BJS পরীক্ষা পর্যন্ত BJS-এর সকল পরীক্ষা ও ক্লাস',
          oldPrice: 1499,
          newPrice: 699,
          discountPercentage: 53.37,
          isSpecial: true, features: '',
        ),
        _buildPackageItem(
          title: 'বার কাউন্সিল এনরোলমেন্ট',
          period: 'ক্রুশিয়ালের সকল পরীক্ষা ও ক্লাস',
          features: 'বার কাউন্সিলের সকল পরীক্ষা ও ক্লাস',
          oldPrice: 0,
          newPrice: 599,
          discountPercentage: 0,
        ),
      ],
    );
  }
}