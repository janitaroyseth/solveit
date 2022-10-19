import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/screens/project_overview_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late List<Map<String, Object>> _pages;
  int _pageIndex = 0;

  void _changePageIndex(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      {"page": const ProjectOverviewScreen()},
      {"page": const ProfileScreen()},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
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
          currentIndex: _pageIndex),
    );
  }
}
