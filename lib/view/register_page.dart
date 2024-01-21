import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/user_view_model.dart';
import '../network/api.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _secureText = true;
  late String name, email, password;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  _showMsg(msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xff151515),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 72),
          child: Column(
            children: [
              Card(
                elevation: 4.0,
                color: Colors.white10,
                margin: const EdgeInsets.only(top: 86),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Register",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                            cursorColor: Colors.blue,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: "Full Name",
                            ),
                            validator: (nameValue) {
                              if (nameValue == "") {
                                return 'Please enter your full name';
                              }
                              name = nameValue!;
                              return null;
                            }),
                        const SizedBox(height: 12),
                        TextFormField(
                            cursorColor: Colors.blue,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: "Email",
                            ),
                            validator: (emailValue) {
                              if (emailValue == "") {
                                return 'Please enter your email';
                              }
                              email = emailValue!;
                              return null;
                            }),
                        const SizedBox(height: 12),
                        TextFormField(
                            cursorColor: Colors.blue,
                            keyboardType: TextInputType.text,
                            obscureText: _secureText,
                            decoration: InputDecoration(
                              hintText: "Password",
                              suffixIcon: IconButton(
                                onPressed: showHide,
                                icon: Icon(_secureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                            ),
                            validator: (passwordValue) {
                              if (passwordValue == "") {
                                return 'Please enter your password';
                              }
                              password = passwordValue!;
                              return null;
                            }),
                        const SizedBox(height: 12),
                        TextButton(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            child: Text(
                              _isLoading ? 'Processing..' : 'Register',
                              textDirection: TextDirection.ltr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _register();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _register() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'name': name,
      'email': email,
      'password': password
    };

    var res = await Network().auth(data, '/register');
    var body = json.decode(res.body);
    if (body['access_token'] != null) {
    UserViewModel userViewModel = Provider.of<UserViewModel>(context, listen: false);
    await userViewModel.loadUserData();
    
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('access_token', body['access_token']);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      _showMsg("Registration failed");
    }

    setState(() {
      _isLoading = false;
    });
  }
}
