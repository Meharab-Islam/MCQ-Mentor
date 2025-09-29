
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/screens/home/home_screen.dart';
import 'package:mcq_mentor/screens/profile/profile_screen.dart';
import 'package:mcq_mentor/screens/quiz/quiz_form_screen.dart';



class CustomBottomNavBarScreen extends StatefulWidget {
  const CustomBottomNavBarScreen({Key? key}) : super(key: key);

  @override
  State<CustomBottomNavBarScreen> createState() => _CustomBottomNavBarScreenState();
}

class _CustomBottomNavBarScreenState extends State<CustomBottomNavBarScreen> {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 2);

  /// Controller to handle bottom nav bar and also handles initial page
  final NotchBottomBarController _controller = NotchBottomBarController(index: 2);

  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// widget list
    final List<Widget> bottomBarPages = [
     QuizMasterScreen(),
    const Placeholder(), 
    const HomeScreen(),
    const Placeholder(), 
    const ProfileScreen(), 
    ];
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              /// Provide NotchBottomBarController
              notchBottomBarController: _controller,
              color: Theme.of(context).colorScheme.onPrimary,
              showLabel: true,
              textOverflow: TextOverflow.visible,
              maxLine: 1,
              shadowElevation: 5,
              kBottomRadius: 28.0,

              // notchShader: const SweepGradient(
              //   startAngle: 0,
              //   endAngle: pi / 2,
              //   colors: [Colors.red, Colors.green, Colors.orange],
              //   tileMode: TileMode.mirror,
              // ).createShader(Rect.fromCircle(center: Offset.zero, radius: 8.0)),
              // notchColor: Theme.of(context).colorScheme.onPrimary,
              notchColor: Colors.blue.shade700,

              /// restart app if you change removeMargins
              removeMargins: false,
              bottomBarWidth: 500,
              showShadow: false,
              durationInMilliSeconds: 300,

              itemLabelStyle: TextStyle(fontSize: 10.sp, color: Get.theme.colorScheme.primary),

              elevation: 1,
              bottomBarItems:  [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                      color: Theme.of(context).colorScheme.primary,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                     color: Theme.of(context).colorScheme.primary,
                  ),
                  itemLabel: 'Page 1',
                ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.star,  color: Theme.of(context).colorScheme.primary,),
                  activeItem: Icon(
                    Icons.star,
                     color: Theme.of(context).colorScheme.primary,
                  ),
                  itemLabel: 'Page 2',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.house_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  activeItem: Icon(
                    Icons.house_rounded,
                      color: Theme.of(context).colorScheme.primary,
                  ),
                  itemLabel: 'Page 3',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.architecture_sharp,
                     color: Theme.of(context).colorScheme.primary,
                  ),
                  activeItem: Icon(
                    Icons.architecture_sharp,
                      color: Theme.of(context).colorScheme.primary,
                  ),
                  itemLabel: 'Page 4',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.person,
                      color: Theme.of(context).colorScheme.primary,
                  ),
                  activeItem: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  itemLabel: 'Page 5',
                ),
              ],
              onTap: (index) {
                
                _pageController.jumpToPage(index);
              },
              kIconSize: 24.0,
            )
          : null,
    );
  }
}