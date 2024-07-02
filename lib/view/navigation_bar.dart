import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanderlog/controller/controller.dart';
import 'package:wanderlog/util/colors.dart';
import 'package:wanderlog/view/home.dart';
import 'package:wanderlog/view/location.dart';
import 'package:wanderlog/view/notification.dart';
import 'package:wanderlog/view/profile.dart';

class Navigation extends StatefulWidget {
  Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  List<Widget> _buildScreens() {
    return [
      HomeTab(),
      const NotificationTab(),
       LocationTab(),
      const ProfileTab()
    ];
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Consumer<Controller>(builder: (context, controller, child) {
      return Scaffold(
          extendBody: true,
          body: _buildScreens()[controller.selectedNavindex],
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            child: SizedBox(
              height: height * .08,
              child: BottomNavigationBar(
                  useLegacyColorScheme: false,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: controller.selectedNavindex,
                  onTap: (value) {
                    controller.changeNavIndex(value);
                  },

                  // fixedColor: Colors.black,
                  selectedItemColor: WHITE,
                  unselectedItemColor: CupertinoColors.systemGrey3,
                  backgroundColor: DARK_BLUE_COLOR,
                  items: _navBarsItems()),
            ),
          ));
    });
  }

  List<BottomNavigationBarItem> _navBarsItems() {
    return [
      const BottomNavigationBarItem(
        backgroundColor: DARK_BLUE_COLOR,
        icon: ImageIcon(AssetImage("assets/home.png")),
        label: ("Home"),
      ),
      const BottomNavigationBarItem(
        icon: ImageIcon(AssetImage("assets/notification.png")),
        label: ("Notification"),
        backgroundColor: DARK_BLUE_COLOR,
      ),
      const BottomNavigationBarItem(
        icon: ImageIcon(AssetImage("assets/location.png")),
        label: ("Location"),
        backgroundColor: DARK_BLUE_COLOR,
      ),
      const BottomNavigationBarItem(
        icon: ImageIcon(AssetImage("assets/profile.png")),
        label: ("Profile"),
        backgroundColor: DARK_BLUE_COLOR,
      ),
    ];
  }
}
