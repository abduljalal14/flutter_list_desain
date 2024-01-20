import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/task_view_model.dart';
import '../../model/task_model.dart';

class TaskListView extends StatelessWidget {
  final List<Task> tasks;

  const TaskListView({Key? key, required this.tasks}) : super(key: key);

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
                  _showEditTaskDialog(context, task);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  Provider.of<TaskViewModel>(context, listen: false)
                      .deleteTaskById(task.id);
                },
              ),
            ],
          ),
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

  EditTaskDialog({Key? key, required this.task}) : super(key: key);

  @override
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
