import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/create_profile_screen.dart';
import 'package:project/screens/project_overview_screen.dart';
import 'package:project/static_data/example_data.dart';
import 'package:project/screens/project_calendar_screen.dart';
import 'package:project/screens/sign_in_screen.dart';
import 'package:project/styles/theme.dart';
import 'package:project/screens/task_detail_screen.dart';
import 'package:project/screens/task_overview_screen.dart';
import './models/project.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      initialRoute: '/',
      routes: {
        //TODO: Update route names.
        '/': (context) => const SignInScreen(),
        '/project/calendar': (context) => const ProjectCalendarScreen(),
        '/tasks': (context) => const TaskOverviewScreen(),
        '/task': (context) => const TaskDetailScreen(),
        ProjectOverviewScreen.routeName: (context) =>
            const ProjectOverviewScreen(),
        CreateProfileScreen.routeName: (context) => const CreateProfileScreen(),
      },
    );
  }
}
