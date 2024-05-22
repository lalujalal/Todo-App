import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/services/auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  final _loginKey = GlobalKey<FormState>();

  UserModel _userModel = UserModel();
  AuthService _authService = AuthService();

  bool _isLoading = false;

  void _login() async {
  setState(() {
    _isLoading = true;
  });

  try {
    _userModel = UserModel(
      email: _emailcontroller.text,
      password: _passwordcontroller.text,
    );

    final data = await _authService.loginUser(_userModel);

    if (data != null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        "/home",
        (route) => false,
      );
    }
  } on FirebaseAuthException catch (e) {
    setState(() {
      _isLoading = false;
    });

    List err = e.toString().split(']');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(err[1])),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    final ThemeData = Theme.of(context);
    return Scaffold(
      body:Container(
            height: double.infinity,
            width: double.infinity,
            padding:const EdgeInsets.all(20),
            child: Stack(
              children:[ 
                Form(
                key: _loginKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "login to your account",
                      style: ThemeData.textTheme.displayMedium,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      style: ThemeData.textTheme.displaySmall,
                      controller: _emailcontroller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'enter an email id';
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "enter email",
                        hintStyle: ThemeData.textTheme.displaySmall,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordcontroller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'enter password id mandatory';
                        }
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "enter password",
                        hintStyle: ThemeData.textTheme.displaySmall,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        if (_loginKey.currentState!.validate()) {
                          _login();
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Login',
                            style: ThemeData.textTheme.displayMedium,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: ThemeData.textTheme.displayMedium,
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            "Create",
                            style: ThemeData.textTheme.displayMedium,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Visibility(
                visible: _isLoading,
                child:const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ]),
          ),
      );
  }
}