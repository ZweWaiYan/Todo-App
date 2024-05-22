// ignore_for_file: file_names

import 'package:flutter/material.dart';

class TaskType {
  final int taskId;
  final String taskName;
  final int taskTime;
  final bool tasksCompleted;

  TaskType(this.taskId, this.taskName, this.taskTime, this.tasksCompleted);
}

class MarkedTaskType {
  final int? markedTaskId;
  final String? markedTasksName;

  MarkedTaskType(this.markedTaskId, this.markedTasksName);
}

class Tasks extends ChangeNotifier {
  //List of Task
  final List<TaskType> _tasks = [];

  List<TaskType> get tasks => _tasks;

  void addTask(int taskId, String taskName, int taskTime, bool tasksCompleted) {
    _tasks.add(TaskType(taskId, taskName, taskTime, tasksCompleted));
    notifyListeners();
  }

  void editTask(
      int taskId, String taskName, int taskTime, bool tasksCompleted) {
    int taskIndex = _tasks.indexWhere((task) => task.taskId == taskId);

    if (taskIndex != -1) {
      _tasks[taskIndex] = TaskType(taskId, taskName, taskTime, tasksCompleted);
      notifyListeners();
    }
  }

  void removeTask(int? taskId) {
    _tasks.removeWhere((tasks) => tasks.taskId == taskId);
    _taskmarked
        .removeWhere((tasksmarked) => tasksmarked.markedTaskId == taskId);
    notifyListeners();
  }

  //List of Marked Task
  final List<MarkedTaskType> _taskmarked = [];

  List<MarkedTaskType> get tasksmarked => _taskmarked;

  void addMarkedTask(int? markedTaskId, String? markedTasksName) {
    _taskmarked.add(MarkedTaskType(markedTaskId, markedTasksName));
    notifyListeners();
  }

  void removeMarkedTask(int? markedTaskId) {
    _taskmarked
        .removeWhere((markedTasks) => markedTasks.markedTaskId == markedTaskId);
    notifyListeners();
  }

  List<int> getMarkedTaskIds() {
    return _taskmarked.map((markedTasks) => markedTasks.markedTaskId!).toList();
  }
}
