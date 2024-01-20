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
    'status': "ONPROCESS",
    'urgent': 0,
  };
  // unggah data ke server
  var res = await Network().postData(data, '/tasks');
  // ambil json dari server
  var body = json.decode(res.body);
  // mampping
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

   Future<void> deleteTaskById(String taskId) async {
    try {
    tasks.removeWhere((task) => task.id == taskId);
     notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    try {
    await Network().deleteData('/tasks/$taskId');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // Fungsi untuk mengirim perubahan task ke API
  Future<void> updateTask(Task updatedTask) async {
  Map<String, dynamic> requestData = {
    "name": updatedTask.name,
    "customer": updatedTask.customer,
    "status": updatedTask.status,
    "urgent": updatedTask.urgent,
  };

  var res = await Network().updateData(requestData, '/tasks/${updatedTask.id}');
  var statusCode = res.statusCode; // Mengambil status code dari response
  if (statusCode == 200) {
    print("Task dengan ID ${updatedTask.id} berhasil diperbarui");

    // Cari indeks task dengan ID yang sesuai dalam _tasks
    int index = _tasks.indexWhere((task) => task.id == updatedTask.id);

    // Perbarui task pada indeks yang ditemukan
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  } else {
    print("Gagal memperbarui tugas. Kode status: $statusCode");
    print("Response body: ${res.body}");
  }
}

}
