import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/services/auth_service.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _namecontroller = TextEditingController();
  UserModel _userModel = UserModel();
  AuthService _authService = AuthService();

  final _regKey = GlobalKey<FormState>();

  bool _isLoading=false;

  void _register()async{
    setState(() {
      _isLoading=true;
    });

     _userModel = UserModel(
                        email: _emailcontroller.text,
                        password: _passwordcontroller.text,
                        name: _namecontroller.text,
                        status: 1,
                        createdAt: DateTime.now(),
                      );
    try {
      await Future.delayed(const Duration(seconds: 2));
      final userdata =
        await _authService.registerUser(_userModel);

      if (userdata != null) {
        Navigator.pushNamedAndRemoveUntil(
          context, '/home', (route) => false
        );
      }
    }on FirebaseAuthException catch(e){
      setState(() {
        _isLoading=false;
      });

       List err=e.toString().split(']');
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err[1])));

    }
   
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding:const EdgeInsets.all(20),
        child: Stack(
          children:[ 
            Form(
              key: _regKey,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Create an account",
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
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: ThemeData.textTheme.displaySmall,
                  controller: _passwordcontroller,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter password is mandatory';
                    }
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "enter password",
                      hintStyle: ThemeData.textTheme.displaySmall,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: ThemeData.textTheme.displaySmall,
                  controller: _namecontroller,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter name is mandatory';
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "enter name",
                      hintStyle: ThemeData.textTheme.displaySmall,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    if (_regKey.currentState!.validate()) {
                      _register();
                      //  UserCredential userData= await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      //   email: _emailcontroller.text.trim(),
                      //   password:_passwordcontroller.text.trim()
                      //   );
                      //  if(userData!=null){
                      //   FirebaseFirestore.instance
                      //   .collection('users').doc(userData.user!.uid)
                      //   .set({
                      //     'uid' : userData.user!.uid,
                      //     'email':userData.user!.email,
                      //     'name':_namecontroller.text,
                      //     'createAt':DateTime.now(),
                      //     'status':1
                      //   });
                      //    Navigator.pushReplacementNamed(context,'/home');
                      //  }

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
                        'Create',
                        style: ThemeData.textTheme.displayMedium,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                        style: ThemeData.textTheme.displayMedium),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "SignIn",
                          style: ThemeData.textTheme.displayMedium,
                        )),
                  ],
                )
              ],
            ),
          ),
            Visibility(
              visible: _isLoading,
              child: Center(child: CircularProgressIndicator(),))
          ]
        ),
      ),
    );
  }
}