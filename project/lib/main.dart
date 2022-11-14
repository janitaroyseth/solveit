import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/firebase_options.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/screens/create_profile_screen.dart';
import 'package:project/screens/create_project_screen.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/screens/project_overview_screen.dart';
import 'package:project/screens/project_preview_screen.dart';
import 'package:project/data/example_data.dart';
import 'package:project/screens/project_calendar_screen.dart';
import 'package:project/screens/sign_in_screen.dart';
import 'package:project/styles/theme.dart';
import 'package:project/screens/task_detail_screen.dart';
import 'package:project/screens/task_overview_screen.dart';
import 'package:project/screens/home_screen.dart';
import './models/project.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static List<Project> projects = ExampleData.projects;

  /// Check if the user is logged in.
  /// They get send to the [HomeScreen] if logged in and [SignInScreen] if not.
  Widget initialScreenCheck(WidgetRef ref) {
    final userAsyncData = ref.watch(userProvider);

    return userAsyncData.when(
      data: (user) {
        String userId = user != null ? user.uid : "<unknown>";
        print("User = $userId");
        return user != null ? const HomeScreen() : SignInScreen();
      },
      error: (err, stack) => Text("Error in auth stream: $err"),
      loading: () => const CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return MaterialApp(
          title: "solveIt",
          theme: Themes.themeData,
          home: initialScreenCheck(ref),
          routes: {
            //TODO: Update route names.
            SignInScreen.routeName: (context) => SignInScreen(),
            HomeScreen.routeName: (context) => const HomeScreen(),
            ProjectCalendarScreen.routeName: (context) =>
                const ProjectCalendarScreen(),
            TaskOverviewScreen.routeName: (context) =>
                const TaskOverviewScreen(),
            '/task': (context) => const TaskDetailScreen(),
            ProfileScreen.routeName: (context) => const ProfileScreen(),
            ProjectPreviewScreen.routeName: (context) =>
                const ProjectPreviewScreen(),
            ProjectOverviewScreen.routeName: (context) =>
                const ProjectOverviewScreen(),
            CreateProfileScreen.routeName: (context) =>
                const CreateProfileScreen(),
            CreateProjectScreen.routeName: (context) =>
                const CreateProjectScreen(),
          },
        );
      },
    );
  }
}
