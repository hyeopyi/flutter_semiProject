import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:semiproject_todolist_app/todoListPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController idcontroller;
  late TextEditingController pwcontroller;
  late List userId;
  late String id;
  late String pw;

  @override
  void initState() {
    super.initState();
    idcontroller = TextEditingController();
    pwcontroller = TextEditingController();
    id = '';
    pw = '';
    userId = [];
    //getJSONData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To do List'),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 30,
          letterSpacing: 13,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 150,
            ),
            const Text(
              "Log In",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                letterSpacing: 10,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                controller: idcontroller,
                decoration: const InputDecoration(
                  labelText: 'ID를 입력해주세요.',
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                controller: pwcontroller,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'PW를 입력해주세요.',
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                getJSONData();
              },
              child: const Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }

//function

  Future<bool> getJSONData() async {
    id = idcontroller.text.toString();
    pw = pwcontroller.text.toString();
    idcontroller.clear();
    pwcontroller.clear();

    var url = Uri.parse(
        'http://localhost:8080/Flutter/sami_todolist_login.jsp?id=$id&pw=$pw');
    var response = await http.get(url);

    //print(url);

    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];

    if (result.isNotEmpty) {
      if (id != result[0]["id"]) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "id를 다시 확인해주세요.",
            ),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red,
          ),
        );
      } else if (pw != result[0]["pw"]) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "pw를 다시 확인해주세요.",
            ),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red,
          ),
        );
      } else if (id == result[0]["id"]) {
        if (pw == result[0]["pw"]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Log in'),
                  content: const Text('로그인이 완료되었습니다.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          FocusScope.of(context).unfocus();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return ToDoListPage(u_id: id);
                            }),
                          );
                        },
                        child: const Text('확인'))
                  ],
                );
              });
        }
      }
    } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "id를 다시 확인해주세요.",
            ),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red,
          ),
      );
    }

    return true;
  }
}//end


    