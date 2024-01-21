import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/task_view_model.dart';
import '../../model/task_model.dart';

class TaskListView extends StatefulWidget {
  final List<Task> tasks;

  const TaskListView({Key? key, required this.tasks}) : super(key: key);

  @override
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Handle the refresh logic here
        await Provider.of<TaskViewModel>(context, listen: false).initializeTasks();
      },
      child: ListView.builder(
        itemCount: widget.tasks.length,
        itemBuilder: (context, index) {
          Task task = widget.tasks[index]; 
          return Container(
            margin: const EdgeInsets.all(8),
                  // Adjust the margin as needed
                  decoration: BoxDecoration(
                    color: (() {
                      switch (widget.tasks[index].status) {
                        case 'ONPROCESS':
                          return Color.fromARGB(255, 161, 0, 0);
                        case 'PENDING':
                          return Color.fromARGB(255, 255, 102, 0);
                        case 'APPROVED':
                          return Color.fromARGB(255, 30, 121, 33);
                        default:
                          return Color.fromARGB(255, 194, 0, 0);
                      }
                    })(),
                    borderRadius: const BorderRadius.all(Radius.circular(
                        8.0)), // Border radius for rounded corners
                  ),
            child: ListTile(
              title: Text(task.name),
              leading: widget.tasks[index].urgent == 1
                        ? const Icon(Icons.push_pin, color: Colors.white)
                        : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showEditTaskDialog(context, task);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteConfirmationDialog(task.id);
                      //Provider.of<TaskViewModel>(context, listen: false).deleteTaskById(task.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Future<void> _showDeleteConfirmationDialog(String taskId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Provider.of<TaskViewModel>(context, listen: false).deleteTaskById(taskId);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }


  Future<void> _showEditTaskDialog(BuildContext context, Task task) async {
    return showDialog(
      context: context,
      builder: (context) {
        return EditTaskDialog(task: task);
      },
    );
  }
}

class EditTaskDialog extends StatefulWidget {
  final Task task;

  const EditTaskDialog({Key? key, required this.task}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late TextEditingController _nameController;
  late TextEditingController _customerController;
  late String selectedStatus;
  late int urgentValue;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task.name);
    _customerController = TextEditingController(text: widget.task.customer);
    selectedStatus = widget.task.status;
    urgentValue = widget.task.urgent;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Tugas'),
      content: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Task Name'),
          ),
          TextField(
            controller: _customerController,
            decoration: const InputDecoration(labelText: 'Customer'),
          ),
          DropdownButtonFormField<String>(
            value: selectedStatus,
            items: ['ONPROCESS', 'PENDING', 'APPROVED']
                .map((status) => DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedStatus = value!;
              });
            },
            decoration: const InputDecoration(labelText: 'Status'),
          ),
          Row(
            children: [
              const Text('Urgent:'),
              Radio(
                value: 0,
                groupValue: urgentValue,
                onChanged: (value) {
                  setState(() {
                    urgentValue = value as int;
                  });
                },
              ),
              const Text('No'),
              Radio(
                value: 1,
                groupValue: urgentValue,
                onChanged: (value) {
                  setState(() {
                    urgentValue = value as int;
                  });
                },
              ),
              const Text('Yes'),
            ],
          ),
        ],
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
            _saveChanges();
            Navigator.pop(context);
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }

  void _saveChanges() async {
    String updatedName = _nameController.text;
    String updatedCustomer = _customerController.text;

    Task updatedTask = Task(
      id: widget.task.id,
      name: updatedName,
      customer: updatedCustomer,
      status: selectedStatus,
      urgent: urgentValue,
    );

    await Provider.of<TaskViewModel>(context, listen: false).updateTask(updatedTask);

  }
}
