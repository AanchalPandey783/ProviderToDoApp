import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/taskviewmodel.dart';
import '../model/taskmodel.dart';

class CustomDialog extends StatelessWidget {
  final Task? initialTask;

  const CustomDialog({Key? key, this.initialTask}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskViewModel>(context, listen: false);
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _dateController = taskProvider.dateController;
    final TextEditingController _timeController = taskProvider.timeController;

    if (initialTask != null) {
      _titleController.text = initialTask!.title;
      _dateController.text = initialTask!.date;
      _timeController.text = initialTask!.time;
    }

    return AlertDialog(
      title: Text(initialTask == null ? 'Create Task' : 'Edit Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null) {
                      taskProvider.setDate(pickedDate);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Date',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (pickedDate != null) {
                          taskProvider.setDate(pickedDate);
                        }
                      },
                      icon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _timeController,
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      taskProvider.setTime(pickedTime);
                    }
                  },
                  decoration:  InputDecoration(
                    labelText: 'Time',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          taskProvider.setTime(pickedTime);
                        }
                      },
                      icon: Icon(Icons.access_time),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final title = _titleController.text;
            final date = _dateController.text;
            final time = _timeController.text;

            if (initialTask == null) {
              taskProvider.createTask(title, date, time);
            } else {
              taskProvider.updateTask(initialTask!.id, title, date, time);
            }

            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
