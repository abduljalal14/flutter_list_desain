import 'package:flutter/material.dart';
import 'package:flutter_list_desain/controller/user_view_model.dart';
import 'package:provider/provider.dart';
import '../controller/task_view_model.dart';
import '../model/task_model.dart';
import 'component/task_list.dart';

class HomePage extends StatelessWidget {
  // final TextEditingController _taskController = TextEditingController();

  HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      Expanded(
        child: Consumer<TaskViewModel>(
          builder: (context, taskList, child) {
            return TaskListView(tasks: taskList.tasks);
          },
        ),
      ),
      const Center(child: Icon(Icons.alarm, size: 64.0, color: Colors.cyan)),
      const Center(child: Icon(Icons.forum, size: 64.0, color: Colors.blue)),
      const Center(child: Icon(Icons.forum, size: 64.0, color: Colors.blue)),
    ];
    final _kTabs = <Tab>[
      const Tab(icon: Icon(Icons.cloud), text: 'All Task'),
      const Tab(icon: Icon(Icons.alarm), text: 'On Process'),
      const Tab(icon: Icon(Icons.forum), text: 'Pending'),
      const Tab(icon: Icon(Icons.forum), text: 'Approved'),
    ];

    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<UserViewModel>(
          builder: (context, userViewModel, child) {
            return Text('Welcome, ${userViewModel.user.name}');
          },
        ),
          backgroundColor: Colors.cyan,
          actions: [
            IconButton(onPressed:() {
              Provider.of<UserViewModel>(context, listen: false).logout(context);
            }, icon: const Icon(Icons.logout))
          ],
          bottom: TabBar(
            tabs: _kTabs,
          ),
        ),
        body: TabBarView(
          children: _kTabPages,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddTaskModal(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddTaskModal(BuildContext context) {
    TextEditingController taskNameController = TextEditingController();
    TextEditingController customerNameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Task',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: taskNameController,
                decoration: const InputDecoration(labelText: 'Task Name'),
              ),
              TextField(
                controller: customerNameController,
                decoration: const InputDecoration(labelText: 'Customer Name'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save and Close'),
                onPressed: () async {
                Task? newTask = await Provider.of<TaskViewModel>(context, listen: false)
                    .addTask(taskNameController.text, customerNameController.text);

                if (newTask != null) {
                  // Berhasil menambahkan tugas, berikan umpan balik atau lakukan tindakan lain
                  print("Task added successfully: ${newTask.name}");
                } else {
                  // Gagal menambahkan tugas, berikan umpan balik atau lakukan tindakan lain
                  print("Failed to add task.");
                }

                taskNameController.clear();
                Navigator.pop(context); // Close the modal
              },
              ),
            ],
          ),
        );
      },
    );
  }
}
