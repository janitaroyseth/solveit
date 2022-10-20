import 'package:flutter/material.dart';
import 'package:project/example_data/example_data.dart';
import 'package:project/screens/project_calendar_screen.dart';
import 'package:project/screens/sign_in_screen.dart';
import 'package:project/screens/task_detail_screen.dart';
import 'package:project/screens/task_overview_screen.dart';
import './models/project.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static List<Project> projects = ExampleData.projects;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "solveIt",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Comfortaa",
      ),
      initialRoute: '/',
      routes: {
        //TODO: Update route names.
        '/': (context) => const SignInScreen(),
        '/project/calendar': (context) => const ProjectCalendarScreen(),
        '/tasks': (context) => const TaskOverviewScreen(),
        '/task': (context) => const TaskDetailScreen(),
      },
    );
  }
}
