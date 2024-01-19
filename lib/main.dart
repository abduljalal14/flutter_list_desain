import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/task_view_model.dart';
import 'controller/user_view_model.dart'; // Import UserViewModel
import 'view/home_page.dart';
import 'view/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskViewModel()),
        ChangeNotifierProvider(create: (context) => UserViewModel()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: const CheckAuth(),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.dark,
      ),
    );
  }
}

class CheckAuth extends StatelessWidget {
  const CheckAuth({Key? key});

  @override
  Widget build(BuildContext context) {
    // Use Provider to access UserViewModel
    bool isAuth = Provider.of<UserViewModel>(context).isLoggedIn;

    Widget child;
    if (isAuth) {
      child = HomePage();
    } else {
      child = Login();
    }

    return Scaffold(
      body: child,
    );
  }
}
