import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/taskviewmodel.dart';
import '../model/taskmodel.dart';

class CreateScreen extends StatefulWidget {
  final Task? task;

  const CreateScreen({Key? key, this.task}) : super(key: key);

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _dateController.text = widget.task!.date;
      _timeController.text = widget.task!.time;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskViewModel>(context, listen: false);

    return AlertDialog(
      title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _dateController,
            decoration: const InputDecoration(labelText: 'Date'),
          ),
          TextField(
            controller: _timeController,
            decoration: const InputDecoration(labelText: 'Time'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (widget.task == null) {
              taskProvider.createTask(
                _titleController.text,
                _dateController.text,
                _timeController.text,
              );
            } else {
              taskProvider.updateTask(
                widget.task!.id,
                _titleController.text,
                _dateController.text,
                _timeController.text,
              );
            }
            Navigator.of(context).pop();
          },
          child: Text(widget.task == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}
