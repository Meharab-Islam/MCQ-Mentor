
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/screens/home/home_screen.dart';
import 'package:mcq_mentor/screens/leaderboard/leaderboard_view.dart';
import 'package:mcq_mentor/screens/packages/package_list_screen.dart';
import 'package:mcq_mentor/screens/profile/profile_screen.dart';
import 'package:mcq_mentor/screens/quiz/quiz_form_screen.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';
import 'package:mcq_mentor/widget/custom_drawer.dart';



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
    LeaderboardView(), 
    const HomeScreen(),
    const PackageListScreen(isMain: true,), 
    const ProfileScreen(), 
    ];
    return Scaffold(
      appBar: CustomAppbar(),
      drawer: CustomDrawer(),
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
                    Icons.ballot_outlined,
                      color: Theme.of(context).colorScheme.primary,
                  ),
                  activeItem: Icon(
                    Icons.ballot_outlined,
                     color: Theme.of(context).colorScheme.primary,
                  ),
                  itemLabel: 'Quiz',
                ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.leaderboard_outlined,  color: Theme.of(context).colorScheme.primary,),
                  activeItem: Icon(
                    Icons.leaderboard_outlined,
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
                  itemLabel: 'Home',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.workspace_premium_outlined,
                     color: Theme.of(context).colorScheme.primary,
                  ),
                  activeItem: Icon(
                    Icons.workspace_premium_outlined,
                      color: Theme.of(context).colorScheme.primary,
                  ),
                  itemLabel: 'Packages',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.people_outline,
                      color: Theme.of(context).colorScheme.primary,
                  ),
                  activeItem: Icon(
                    Icons.people_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  itemLabel: 'Profile',
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