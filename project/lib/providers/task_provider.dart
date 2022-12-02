import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/task.dart';
import 'package:project/services/task_service.dart';

final taskProvider = Provider<TaskService>((ref) {
  final TaskService taskService = FirebaseTaskService();
  return taskService;
});

final currentTaskProvider =
    StateNotifierProvider<CurrentTaskNotifier, Stream<Task?>>((ref) {
  return CurrentTaskNotifier();
});

class CurrentTaskNotifier extends StateNotifier<Stream<Task?>> {
  CurrentTaskNotifier() : super(Stream<Task?>.value(Task()));

  void setTask(Stream<Task?> task) {
    state = task;
  }
}

final editTaskProvider = StateNotifierProvider<EditTaskNotifier, Task?>((ref) {
  return EditTaskNotifier();
});

class EditTaskNotifier extends StateNotifier<Task?> {
  EditTaskNotifier() : super(null);

  void setTask(Task? task) {
    state = task;
  }
}
