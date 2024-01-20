import 'package:flutter/material.dart';
import 'package:flutter_list_desain/controller/user_view_model.dart';
import 'package:provider/provider.dart';
import '../controller/task_view_model.dart';
import '../model/task_model.dart';
import 'component/task_list.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    Provider.of<UserViewModel>(context, listen: false).checkIfLoggedIn();

    final kTabPages = <Widget>[
      Expanded(
        child: Consumer<TaskViewModel>(
          builder: (context, taskList, child) {
            if (taskList.tasks.isEmpty) {
              return const Center(
                  child:
                      Icon(Icons.check_circle, size: 64.0, color: Colors.blue));
            }
            return TaskListView(tasks: taskList.tasks);
          },
        ),
      ),
      Expanded(
        child: Consumer<TaskViewModel>(
          builder: (context, taskList, child) {
            List<Task> onProcessTasks = taskList.tasks
                .where((task) => task.status == "ONPROCESS")
                .toList();

            if (onProcessTasks.isEmpty) {
              return const Center(
                  child:
                      Icon(Icons.check_circle, size: 64.0, color: Colors.blue));
            }
            return TaskListView(tasks: onProcessTasks);
          },
        ),
      ),
      Expanded(
        child: Consumer<TaskViewModel>(
          builder: (context, taskList, child) {
            List<Task> pendingTasks = taskList.tasks
                .where((task) => task.status == "PENDING")
                .toList();

            if (pendingTasks.isEmpty) {
              return const Center(
                  child:
                      Icon(Icons.check_circle, size: 64.0, color: Colors.blue));
            }
            return TaskListView(tasks: pendingTasks);
          },
        ),
      ),
      Expanded(
        child: Consumer<TaskViewModel>(
          builder: (context, taskList, child) {
            List<Task> approvedTasks = taskList.tasks
                .where((task) => task.status == "APPROVED")
                .toList();

            if (approvedTasks.isEmpty) {
              return const Center(
                  child:
                      Icon(Icons.check_circle, size: 64.0, color: Colors.blue));
            }
            return TaskListView(tasks: approvedTasks);
          },
        ),
      ),
    ];
    final kTabs = <Tab>[
      const Tab(icon: Icon(Icons.assessment), text: 'All Task'),
      const Tab(icon: Icon(Icons.draw), text: 'On Process'),
      const Tab(icon: Icon(Icons.access_time_filled), text: 'Pending'),
      const Tab(icon: Icon(Icons.checklist), text: 'Approved'),
    ];

    return DefaultTabController(
      length: kTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<UserViewModel>(
            builder: (context, userViewModel, child) {
              return Text('Welcome, ${userViewModel.user.name}');
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Provider.of<UserViewModel>(context, listen: false)
                      .logout(context);
                },
                icon: const Icon(Icons.logout))
          ],
          bottom: TabBar(
            tabs: kTabs,
          ),
        ),
        body: TabBarView(
          children: kTabPages,
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
                  Task? newTask = await Provider.of<TaskViewModel>(context,
                          listen: false)
                      .addTask(
                          taskNameController.text, customerNameController.text);

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
