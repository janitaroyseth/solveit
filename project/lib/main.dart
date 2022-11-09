import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/firebase_options.dart';
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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static List<Project> projects = ExampleData.projects;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "solveIt",
      theme: Themes.themeData,
      initialRoute: SignInScreen.routeName,
      routes: {
        //TODO: Update route names.
        '/': (context) => const SignInScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        ProjectCalendarScreen.routeName: (context) =>
            const ProjectCalendarScreen(),
        TaskOverviewScreen.routeName: (context) => const TaskOverviewScreen(),
        '/task': (context) => const TaskDetailScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        ProjectPreviewScreen.routeName: (context) =>
            const ProjectPreviewScreen(),
        ProjectOverviewScreen.routeName: (context) =>
            const ProjectOverviewScreen(),
        CreateProfileScreen.routeName: (context) => const CreateProfileScreen(),
        CreateProjectScreen.routeName: (context) => const CreateProjectScreen(),
      },
    );
  }
}
