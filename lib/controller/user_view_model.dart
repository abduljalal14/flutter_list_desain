import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';
import '../network/api.dart';
import '../view/login_page.dart';

class UserViewModel with ChangeNotifier {
  User _user = User(id: '', name: '', email: ''); // Initialize _user

  bool _isLoggedIn = false;

  User get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  void checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('access_token');
    _isLoggedIn = token != null;

    if (_isLoggedIn) {
      loadUserData();
    }
    notifyListeners();
  }

  Future<void> loadUserData() async {
  try {
    var res = await Network().getData('/user');
    var body = json.decode(res.body);

    if (body != null) {
      _user = User(
        id: body['id'].toString(),
        name: body['name'],
        email: body['email'],
      );
      _isLoggedIn = true;
    }
  } catch (error) {
    print('Error loading user data: $error');
    _isLoggedIn = false;
    _user = User(id: '', name: '', email: '');
    return;
  } finally {
    // Notify listeners after the asynchronous operation is completed
    notifyListeners();
  }
}


  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    var res = await Network().auth(data, '/login');
    var body = json.decode(res.body);

    if (body['message'] == "Login success") {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('access_token', body['access_token']);
      loadUserData();
      
    }

    return body;
  }

  void logout(BuildContext context) async {
    var res = await Network().postData('', '/logout');
    var body = json.decode(res.body);

    if (body['message'] == "Successfully logged out") {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('access_token');
      var token = localStorage.getString('access_token');
      print("Isi token sekarang : $token");

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }
}
