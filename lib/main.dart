import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/screens/reg_page.dart';
import 'package:todo_app/screens/splash.dart';
import 'package:todo_app/screens/todo_home_page.dart';
import 'package:todo_app/widgets/add_task.dart';
import 'firebase_options.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute:"/splash",
      routes: {
        '/':(context) =>const LoginView(),
        '/register':(context) =>const RegisterView(),
        '/home':(context) =>const TodoHomePage(),
        '/addtask':(context) =>const AddTaskView(),
        '/splash':(context) =>const SplashScreen(),
      },

      theme: ThemeData(

        textTheme:const TextTheme(
          displayMedium: TextStyle(color: Colors.white,fontSize: 18),
          displaySmall: TextStyle(color: Colors.white,fontSize: 14)
        ),
        scaffoldBackgroundColor:const Color(0xff0E1D3E),
        appBarTheme:const AppBarTheme(
          backgroundColor: Color(0xff0E1D3E),
          iconTheme: IconThemeData(color: Colors.white)
        ) ,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      
    );
  }
}
