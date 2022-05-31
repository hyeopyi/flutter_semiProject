import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:semiproject_todolist_app/listeditingpage.dart';

class ConmpleteList extends StatefulWidget {
  final String u_id;
  const ConmpleteList({Key? key, required this.u_id}) : super(key: key);

  @override
  State<ConmpleteList> createState() => _ConmpleteListState();
}

class _ConmpleteListState extends State<ConmpleteList> {
  // Property
  late List data;
  late int t_id;
  @override
  void initState() {
    data = [];
    t_id = -1;

    getJSONData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: data.isEmpty ? const CircularProgressIndicator()
          : ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) => GestureDetector(
               onLongPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return ListEditinPage(t_id: data[index]['id'], 
                                                  category: data[index]['category'],
                                                  content: data[index]['content'],);
                          }),
                        ).then((value) => getJSONData());
                      },
              child: Dismissible(
                  key: Key(data[index]['id']),
                  onDismissed: (direction) => _onDismissed(direction, index),
                  confirmDismiss: (direction) =>
                      _confirmDismiss(direction, context, index),
                  background: _buildBackground,
                  secondaryBackground: _buildSecondBackground,
                  child: _buildListItem(index)),
            ))
        )
       
            );
  }

  // --- Function ---
  _onDismissed(DismissDirection direction, int index) {
    // if (direction == DismissDirection.endToStart) {

    // }
    // if (direction == DismissDirection.startToEnd) {

    // }
  }

  Future<bool> _confirmDismiss(
      DismissDirection direction, BuildContext context, int index) {
    if (direction == DismissDirection.endToStart) {
      return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('삭제 알림'),
              content: Text('${data[index]['content']} \n삭제하시겠습니까'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    return Navigator.of(context).pop(false);
                  },
                  child: const Text('취소'),
                ),
                ElevatedButton(
                  onPressed: () {
                    deleteJSONData(index);
                    return Navigator.of(context).pop(true);
                  },
                  child: const Text('삭제'),
                ),
              ],
            );
          }).then((value) => Future.value(value));
    } else if (direction == DismissDirection.startToEnd) {
      return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('미완료 진행하시겠습니까?'),
              content: Text('${data[index]['content']} \n 미완료처리 합니다'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                   
                    return Navigator.of(context).pop(false);
                  },
                  child: const Text('취소'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setJSONData(index, 0);
                    
                    return Navigator.of(context).pop(true);
                    
                  },
                  child: const Text('완료'),
                ),
              ],
            );
          }).then((value) => Future.value(value));
    }
    return Future.value(false);
  }

  Card _buildListItem(int index) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 8,
      child: ListTile(
        leading: CircleAvatar(
          child: Text(data[index]['category']),
        ),
        title: Text(
          data[index]['content'],
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Container get _buildSecondBackground => Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          size: 36,
          color: Colors.white,
        ),
      );

  Container get _buildBackground => Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.green,
        alignment: Alignment.centerLeft,
        child: const Icon(
          Icons.save,
          size: 36,
          color: Colors.white,
        ),
      );

  Future<bool> getJSONData() async {
    // Future, async, await 는 한 세트로
    // 비동기 함수로 생성
    data.clear();
    var url = Uri.parse(
        'http://localhost:8080/Flutter/todolist_query_flutter.jsp?u_id=${widget.u_id}&t_state=1'); // web만 post방식을 사용 나머지는 get방식 사용 - 자체 암호화를 위해
    var response = await http.get(url); // 데이터를 가져와서 빌드가 끝날때까지 대기

    setState(() {
      // 화면 구성이 바뀌어야 쓴다
      var dataConvertedJSON =
          json.decode(utf8.decode(response.bodyBytes)); // utf-8 타입으로 하나씩 변환
      List result = dataConvertedJSON['results'];
      data.addAll(result);
    });

    //print(result);

    return true; // return을 하지만 쓰지않는다
  }

  Future<bool> setJSONData(int index, int comNum) async {
    t_id = int.parse(data[index]['id']);
    var url = Uri.parse(
        'http://localhost:8080/Flutter/todolist_update_status_flutter.jsp?t_id=$t_id&t_state=$comNum'); // web만 post방식을 사용 나머지는 get방식 사용 - 자체 암호화를 위해
    var response2 = await http.get(url); // 데이터를 가져와서 빌드가 끝날때까지 대기

    getJSONData();

    return true; // return을 하지만 쓰지않는다
  }

  Future<bool> deleteJSONData(int index) async {
    t_id = int.parse(data[index]['id']);
    var url = Uri.parse(
        'http://localhost:8080/Flutter/list_delete.jsp?t_id=$t_id'); // web만 post방식을 사용 나머지는 get방식 사용 - 자체 암호화를 위해
    var response2 = await http.get(url); // 데이터를 가져와서 빌드가 끝날때까지 대기
    getJSONData();

    return true; // return을 하지만 쓰지않는다
  }
} // End