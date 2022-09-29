import '../widgets/tag.dart';
import 'comment.dart';

class Task {
  String title;
  String description;
  List<Tag> tags;
  bool done;
  String? deadline;
  List<Comment> comments;

  Task({this.title = "task title", this.description = "task description", this.tags = const [], this.done = false, this.deadline, this.comments = const []});

  List<dynamic> values () {
    return [title, description, done, deadline, tags];
  }
}