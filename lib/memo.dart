import 'dart:convert';

import 'package:catcare/config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Memo extends StatefulWidget {
  final String email;
  final DateTime? selectedDate;

  const Memo({Key? key, required this.email, required this.selectedDate}) : super(key: key);

  @override
  State<Memo> createState() => _MemoState();
}

class _MemoState extends State<Memo> {

  TextEditingController title = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate ?? DateTime.now();
  }

  Future<void> _saveMemo() async {
    try {
      final response = await http.post(Uri.parse(memo),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": title.text,
          "date": DateFormat('yyyy-MM-dd').format(selectedDate!),
          "email": widget.email
        }),
      );

      if (response.statusCode == 200) {
        print("메모 성공!");
        Navigator.pop(context, true);
      } else {
        print("요청 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("예외 발생: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(top: 285, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('제목', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Padding(padding: EdgeInsets.only(top: 20)),
            TextFormField(
              controller: title,
              decoration: InputDecoration(
                hintText: '${selectedDate?.month}월 ${selectedDate?.day}일에 일정 추가',
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 50)),
            Text('날짜', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Padding(padding: EdgeInsets.only(top: 20)),
            OutlinedButton(
              onPressed: () {

              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2.5,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.calendar_today),
                    Text('${DateFormat('yyyy년 MM월 dd일').format(selectedDate!)}'),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(padding: EdgeInsets.only(top: 285)),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('취소', style: TextStyle(fontSize: 20)),
                ),
                Padding(padding: EdgeInsets.only(left: 100)),
                TextButton(
                  onPressed: () {
                    _saveMemo();
                  },
                  child: Text('저장', style: TextStyle(fontSize: 20)),
                ),
                Padding(padding: EdgeInsets.only(right: 50)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}