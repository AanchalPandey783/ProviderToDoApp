import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/taskmodel.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> tasks = [];
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  String? _taskName;

  List<Task> get taskList => tasks;

  bool get validTask =>
      _taskName != null &&
          dateController.text.isNotEmpty &&
          timeController.text.isNotEmpty;

  void setTaskName(String? value) {
    _taskName = value;
    notifyListeners();
  }

  void setDate(DateTime? date) {
    if (date == null) {
      return;
    }
    DateTime currentDate = DateTime.now();
    DateTime now = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
    );

    int diff = date.difference(now).inDays;
    if (diff == 0) {
      dateController.text = 'Today';
    } else if (diff == 1) {
      dateController.text = 'Tomorrow';
    } else {
      dateController.text = "${date.day}/${date.month}/${date.year}";
    }
    notifyListeners();
  }

  void setTime(TimeOfDay? time) {
    if (time == null) {
      return;
    }

    if (time.hour == 0) {
      timeController.text = "12:${time.minute} AM";
    } else if (time.hour < 12) {
      timeController.text = "${time.hour}:${time.minute} AM";
    } else if (time.hour == 12) {
      timeController.text = "${time.hour}:${time.minute} PM";
    } else {
      timeController.text = "${time.hour - 12}:${time.minute} PM";
    }
    notifyListeners();
  }

  void createTask(String title, String date, String time) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final task = Task(title, date, time, id);
    tasks.add(task);
    notifyListeners();
  }

  void updateTask(String id, String title, String date, String time) {
    final taskIndex = tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      tasks[taskIndex] = Task(title, date, time, id);
      notifyListeners();
    }
  }

  void deleteTaskById(String id) {
    tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void updateTaskStatus(Task task, bool isDone) {
    // Example implementation, modify as per your logic
    task.isDone = isDone;
    notifyListeners();
  }

  // Method to fetch tasks from an API
  Future<void> fetchTodo() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      // Check the structure of the JSON response
      if (json.containsKey('data') && json['data'] is List) {
        final List<dynamic> data = json['data'];

        tasks.addAll(data.map((taskJson) =>
            Task(
              taskJson['title'] ?? 'No Title',
              taskJson['date'] ?? 'No Date',
              taskJson['time'] ?? 'No Time',
              taskJson['id'] ??
                  '', // Ensure id is provided or handled appropriately
            )).toList());
        notifyListeners();
      } else {
        print('Failed to fetch tasks');
      }
    }
  }
}
