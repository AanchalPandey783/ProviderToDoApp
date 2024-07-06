import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/taskviewmodel.dart';
import '../custom_dialog.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: Consumer<TaskViewModel>(
        builder: (context, taskProvider, child) {
          return ListView.builder(
            itemCount: taskProvider.taskList.length,
            itemBuilder: (context, index) {
              final task = taskProvider.taskList[index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text('${task.date} - ${task.time}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    taskProvider.deleteTaskById(task.id);
                  },
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => CustomDialog(initialTask: task),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const CustomDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
