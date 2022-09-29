import 'package:project/entities/task.dart';

class Project {
  String title;
  List<Task> tasks;

  Project({this.title = "project title", this.tasks = const []});
}