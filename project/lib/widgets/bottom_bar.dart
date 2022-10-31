import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/screens/project_overview_screen.dart';
import 'package:project/styles/theme.dart';

/// Represents the bar at the bottom of the screen.
class BottomBar extends StatefulWidget {
  const BottomBar({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

///
class _BottomBarState extends State<BottomBar> with TickerProviderStateMixin {
  late List<Map<String, Object>> _pages;
  int _pageIndex = 0;

  late TabController tabBarController;

  void changePageIndex(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  void initState() {
    tabBarController = TabController(initialIndex: 0, length: 4, vsync: this);
    super.initState();
    _pages = [
      {"page": const ProjectOverviewScreen()},
      {"page": const ProfileScreen()},
    ];
  }

  final screens = [
    const ProjectOverviewScreen(),
    const ProjectOverviewScreen(),
    const ProjectOverviewScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: _pages[_pageIndex]['page'] as Widget,
      body: SafeArea(
          child: TabBarView(
        controller: tabBarController,
        children: screens,
      )),
      bottomNavigationBar: BottomAppBar(
          child: SizedBox(
        height: 50,
        child: TabBar(
          controller: tabBarController,
          indicator: UnderlineTabIndicator(
            insets: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 50.0),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 3),
          ),
          labelColor: Themes.primaryColor,
          unselectedLabelColor: Themes.textColor,
          tabs: const [
            Tab(
              iconMargin: EdgeInsets.all(0.0),
              icon: Icon(
                PhosphorIcons.diamondsFour,
              ),
              child: Text(
                "projects",
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
            ),
            Tab(
              iconMargin: EdgeInsets.all(0.0),
              icon: Icon(PhosphorIcons.compass),
              child: Text(
                "explore",
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
            ),
            Tab(
              iconMargin: EdgeInsets.all(0.0),
              icon: Icon(PhosphorIcons.tray),
              child: Text(
                "inbox",
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
            ),
            Tab(
              iconMargin: EdgeInsets.all(0.0),
              icon: Icon(PhosphorIcons.user),
              child: Text(
                "profile",
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      )), /* BottomNavigationBar(
          onTap: _changePageIndex,
          items: const [
            
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.diamondsFour),
              label: "projects",
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.user),
              label: "profile",
            ),
          ],
          currentIndex: _pageIndex),*/
    );
  }
}
