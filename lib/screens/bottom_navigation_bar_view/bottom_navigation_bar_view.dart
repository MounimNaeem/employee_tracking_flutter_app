import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:employee_location_tracking_app/screens/admin_dashboard/view/admin_dashboard_view.dart';
import 'package:employee_location_tracking_app/screens/drawer/view/drawer_view.dart';
import 'package:employee_location_tracking_app/screens/employees_tracking/view/employees_tracking_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavigationBarView extends StatefulWidget {
  const BottomNavigationBarView({super.key});

  @override
  State<BottomNavigationBarView> createState() =>
      _BottomNavigationBarViewState();
}

class _BottomNavigationBarViewState extends State<BottomNavigationBarView> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Keep track of the current page
  int _currentPage = 0;

  // Pages to display for each navigation item
  final List<Widget> _pages = [
    AdminDashboardView(),
    EmployeesTrackingView(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // key: _scaffoldKey,
      // drawer: const DrawerView(),
      backgroundColor: Colors.white,
      body: _pages[_currentPage],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: theme.primaryColor,
        items: <CurvedNavigationBarItem>[
          CurvedNavigationBarItem(
            child: SvgPicture.asset(
              'assets/images/employees_icon.svg',
              width: 32,
              color: _currentPage == 0 ? Colors.white : null,
            ),
            label: 'Employees',
          ),
          CurvedNavigationBarItem(
            child: SvgPicture.asset(
              'assets/images/bottom_bar_location_icon.svg',
              width: 22,
              color: _currentPage == 1 ? Colors.white : null,
            ),
            label: 'Tracker',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }
}
