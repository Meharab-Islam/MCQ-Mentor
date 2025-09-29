import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable widget for the app logo.
class LogoWidget extends StatelessWidget {
  final double height;
  final double width;
  const LogoWidget({super.key,  this.height = 140, this.width = 140});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: height.h,
      width: width.w,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/images/logo.png'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15.r,
            offset: const Offset(0, 5),
          ),
        ],
      ),
    );
  }
}
