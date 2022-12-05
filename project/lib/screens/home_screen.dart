import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/alert.dart';
import 'package:project/providers/alert_provider.dart';
import 'package:project/screens/explore_screen.dart';
import 'package:project/screens/notifications_screen.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/screens/project_overview_screen.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/general/notification_mark.dart';

/// Screen/[Scaffold] the user first sees when logging on or finishing signing up.
/// Displays a bottom tab bar for navigating to other screens.
class HomeScreen extends ConsumerStatefulWidget {
  /// Creates an instance of home screen. A [Scaffold] displaying a
  /// bottom tab bar for other screens.
  const HomeScreen({super.key});

  /// Named route for this screen.
  static const routeName = "/index";

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  /// Controller for the tab bar.
  late TabController tabBarController;

  /// The height of the tab bar.
  final double tabBarHeight = 50;

  /// The screens the tab bar can navigate to.
  final screens = [
    const ProjectOverviewScreen(),
    const ExploreScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];
  void initmessagin() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  @override
  void initState() {
    tabBarController = TabController(initialIndex: 0, length: 4, vsync: this);
    initmessagin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Themes.primaryColor,
      ),
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: TabBarView(
            controller: tabBarController,
            children: screens,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: tabBarHeight,
          child: TabBar(
            controller: tabBarController,
            indicator: UnderlineTabIndicator(
              insets: EdgeInsets.fromLTRB(
                0.0,
                0.0,
                0.0,
                tabBarHeight,
              ),
              borderSide: BorderSide(
                color: Themes.primaryColor.shade100,
                width: 3,
              ),
            ),
            tabs: <Widget>[
              const _BottomTab(
                icon: PhosphorIcons.diamondsFour,
                label: "projects",
              ),
              const _BottomTab(
                icon: PhosphorIcons.compass,
                label: "explore",
              ),
              StreamBuilder<Alert?>(
                  stream: ref.watch(alertProvider.notifier).getAlert(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      Alert alert = snapshot.data!;

                      return Stack(
                        children: [
                          const _BottomTab(
                            icon: PhosphorIcons.tray,
                            label: "inbox",
                          ),
                          NotificationMark(
                            visible:
                                alert.unseenMessage || alert.unseenNotification,
                          ),
                        ],
                      );
                    }
                    return const _BottomTab(
                      icon: PhosphorIcons.tray,
                      label: "inbox",
                    );
                  }),
              const _BottomTab(
                icon: PhosphorIcons.user,
                label: "profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tabs used for the bottom tab bar in the [HomeScreen] scaffold.
class _BottomTab extends StatelessWidget {
  /// The [IconData] to display for the icon in the tab.
  final IconData icon;

  /// The [String] the tab label should display.
  final String label;

  /// Creates an instance of [_BottomTab].
  const _BottomTab({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Tab(
      iconMargin: const EdgeInsets.all(0.0),
      icon: Icon(icon),
      child: Text(
        label.toLowerCase(),
        style: const TextStyle(
          fontSize: 11,
        ),
      ),
    );
  }
}
