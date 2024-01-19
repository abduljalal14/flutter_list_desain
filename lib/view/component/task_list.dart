import 'package:flutter/material.dart';
import '../../model/task_model.dart';


class TaskListView extends StatelessWidget {
  final List<Task> tasks;

  const TaskListView({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        Task task = tasks[index];
        return ListTile(
          title: Text(task.name),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showEditTaskDialog(context, task.id, task.name);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  //Provider.of<TaskViewModel>(context, listen: false).deleteTask(task.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showEditTaskDialog(BuildContext context, String taskId, String currentTitle) async {
    TextEditingController editTaskController = TextEditingController(text: currentTitle);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Tugas'),
          content: TextField(
            controller: editTaskController,
            decoration: const InputDecoration(labelText: 'Edit Tugas'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                //Provider.of<TaskViewModel>(context, listen: false).editTask(taskId, editTaskController.text);
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}

