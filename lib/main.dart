import 'package:flutter/material.dart';
import 'package:semiproject_todolist_app/addList_Page.dart';
import 'package:semiproject_todolist_app/listeditingpage.dart';
import 'package:semiproject_todolist_app/loginPage.dart';
import 'package:semiproject_todolist_app/todoListPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      routes: {
        "/": (context) => const LoginPage(),
     

        "/addListPage" :(context) => const AddListPage(),
      },

      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      

    );
  }
}
