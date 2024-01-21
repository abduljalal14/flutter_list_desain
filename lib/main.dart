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

class CheckAuth extends StatefulWidget {
  const CheckAuth({Key? key}) : super(key: key);

  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserViewModel>(context, listen: false).checkIfLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    bool isAuth = Provider.of<UserViewModel>(context).isLoggedIn;

    Widget child = isAuth ? const HomePage() : const Login();

    return child;
  }
}
