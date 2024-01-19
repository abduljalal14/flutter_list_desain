import 'dart:convert';
import 'package:flutter/material.dart';
import '../model/task_model.dart';
import '../network/api.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  set tasks(List<Task> value) {
    _tasks = value;
    notifyListeners();
  }

  TaskViewModel() {
    getTasks("1").then((receivedTasks) {
      receivedTasks.sort((a, b) {
        return b.urgent.compareTo(a.urgent);
      });
      tasks = receivedTasks;
    });
  }

  Future<Task?> addTask(String name, String customer) async {
  var data = {
    'name': name,
    'customer': customer,
    'status': "ONPROCCES",
    'urgent': 0,
  };

  var res = await Network().postData(data, '/tasks');
  var body = json.decode(res.body);
  var taskData = (body as Map<String, dynamic>)['data'];
  Task newTask = Task.createTasks(taskData);
  _tasks.add(newTask);
  notifyListeners();

  return newTask;
}
  static Future<List<Task>> getTasks(String page) async {
    var res = await Network().getData('/tasks?page=$page');
    var body = json.decode(res.body);

    List<dynamic> listTask = (body as Map<String, dynamic>)['data']['data'];
    List<Task> tasks = [];
    for (var i = 0; i < listTask.length; i++) {
      tasks.add(Task.createTasks(listTask[i]));
    }

    return tasks;
  }

  static Future<void> deleteTaskById(String taskId) async {
    var res = await Network().deleteData('/tasks/$taskId');
    var body = json.decode(res.body);

    if (body.statusCode == 200) {
      // Task berhasil dihapus
      print("Task with ID $taskId deleted successfully");
    } else {
      // Gagal menghapus task, tangani kesalahan jika diperlukan
      print("Failed to delete task. Status code: ${body.statusCode}");
      print("Response body: ${body.body}");
    }
  }

  // Fungsi untuk mengirim perubahan task ke API
  static Future<void> updateTask(Task updatedTask) async {
    // ignore: unused_local_variable
    Map<String, dynamic> requestData = {
      "name": updatedTask.name,
      "customer": updatedTask.customer,
      "status": updatedTask.status,
      "urgent": updatedTask.urgent,
    };

    var res = await Network().updateData('/tasks/${updatedTask.id}');
    var body = json.decode(res.body);

    if (body.statusCode == 200) {
      // Task berhasil diupdate
      print("Task with ID ${updatedTask.id} updated successfully");
    } else {
      // Gagal mengupdate task, tangani kesalahan jika diperlukan
      print("Failed to update task. Status code: ${body.statusCode}");
      print("Response body: ${body.body}");
    }
  }
}
