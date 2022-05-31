import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class AddListPage extends StatefulWidget {
  const AddListPage({Key? key}) : super(key: key);

  @override
  State<AddListPage> createState() => _AddListPageState();
}

class _AddListPageState extends State<AddListPage> {
  late String selectValue;
  late List<String> valueList;

  final tec = TextEditingController();

  @override
  void initState() {
    super.initState();
    valueList = ["집안일", "약속", "과제" , "학원"];
    selectValue = "집안일";
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        
        appBar: AppBar(
          automaticallyImplyLeading: false,
          primary : true,
          backgroundColor: Colors.white,
          elevation : 0,
          title: const Text(
            'data',
            style: TextStyle(
              color: Colors.lightBlueAccent
            ),
          ),
          leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();

            },
            color: Colors.lightBlueAccent,
            icon: Icon(Icons.arrow_back_ios),
          ),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.add),
          //     onPressed: (){
          //       Navigator.pushNamed(context, '/listEditingPage');
          //     }
          //   ) 
          // ],
        ),
                      
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 20 ,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                width: 200,
                child: DropdownButton(
                  isDense: true,
                  value: selectValue,
                  items: valueList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(), 
                  onChanged: (value){
                    setState(() {
                      selectValue = value.toString();
                    });
                  },
                  dropdownColor: Colors.grey,
                  isExpanded: true,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: tec,
                  decoration: InputDecoration(
                    labelText: '내용을 입력하세요',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 0)
                    )
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: 
                 ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide(width: 5,color: Colors.blue))  ,
                    minimumSize: MaterialStateProperty.all(Size(200, 40)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                onPressed: () {
                  sendContent();
                },
                child: const Text('전송'),
                
                
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -- functions

  sendContent() async{
    if(tec.text.trim().isNotEmpty){
      
      String u_id = 'qwer';
      String category = selectValue;
      String t_content = tec.text;
      
      var url = Uri.parse('http://localhost:8080/Flutter/todolist_insert_flutter.jsp?u_id=$u_id&category=$category&t_content=$t_content');
      print(url);
      var response = await http.get(url);

      setState(() {
        var dataConvetedJSON =  json.decode(utf8.decode(response.bodyBytes));
        var result = dataConvetedJSON['result'];
        if(result  == "OK") _showDialog(context);
        else errorSnackBar(context);
      });
    }else{
      emptySnackBar(); 
    }
  }

  //DB 입력 성공
  _showDialog(BuildContext context){
    showDialog(context: context, 
    builder: (BuildContext context){
      return AlertDialog(
        title:  const Text('입력 결과'),
        content: const Text('입력이 완료 되었습니다.'),
        actions: [
          TextButton(
            onPressed:(){
              Navigator.of(context).pop();
            }, 
            child: const Text('OK'),
          )
        ],
      );
    }
    );
  }
  
  //DB 입력 실패
  errorSnackBar(BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('입력 에러가 발생했습니다.'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      )
    );
  }

  //textfield 입력 X
  emptySnackBar(){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        
        content: const Text('다시는 내용을 비우지 말아주세요'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
      )
    );
  }
}