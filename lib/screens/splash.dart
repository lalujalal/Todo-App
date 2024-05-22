import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? name;
  String? email;
  String? uid;
  String? token;

  @override
  void initState() {
    super.initState();
    loadDataAndCheckLogin();
  }

  Future<void> loadDataAndCheckLogin() async {
    await getData();
    await Future.delayed(const Duration(seconds: 2));
    checkLogin();
  }

  Future<void> getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    token = await _pref.getString('token');
    email = await _pref.getString('email');
    uid = await _pref.getString('uid');
    name = await _pref.getString('name');
  }

  void checkLogin() {
    if (token == null) {
      Navigator.pushNamed(context, '/');
    } else {
      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Todo App', style: TextStyle(fontSize: 33, color: Colors.white)),
      ),
    );
  }
}
