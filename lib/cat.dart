import 'dart:convert';

import 'package:catcare/config.dart';
import 'package:catcare/signin.dart';
import 'package:catcare/signup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Cat extends StatefulWidget {
  final String email, password, name, phone;

  const Cat({Key? key, required this.email, required this.password, required this.name, required this.phone}) : super(key: key);

  @override
  State<Cat> createState() => _CatState();
}

class _CatState extends State<Cat> {

  final _formKey = GlobalKey<FormState>();

  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  bool mSelected = false;
  bool fSelected = false;

  TextEditingController name = TextEditingController();
  String gender = '';
  TextEditingController birth = TextEditingController();
  TextEditingController breed = TextEditingController();

  Future<void> _register() async {
    try {
      final response = await http.post(Uri.parse(signup),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.email,
          "password": widget.password,
          "name": widget.name,
          "phone": widget.phone,
        }),
      );

      if (response.statusCode == 200) {
        print("user 성공!");
      } else {
        print("요청 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("예외 발생: $e");
    }

    try {
      final response = await http.post(Uri.parse(cat),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name.text,
          "birth": birth.text,
          "gender": gender,
          "breed": breed.text,
          "email" : widget.email,
        }),
      );

      if (response.statusCode == 200) {
        print("cat 성공!");
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
        padding: EdgeInsets.only(top:100, left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Text("우리집 고양이를", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black)),
              Text("소개해 주세요🐱", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black)),
              Padding(padding: EdgeInsets.only(top: 60)),
              Row(
                children: [
                  Text('이름은 무엇인가요?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('*', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                ],
              ),
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                  hintText: "이름을 알려주세요",
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Row(
                children: [
                  Text('성별은 무엇인가요?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('*', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          mSelected = true;
                          fSelected = false;
                          gender = 'M';
                        });
                      },
                      child: Text('남아', style: TextStyle(color: mSelected ? Colors.white : Colors.blue)),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          mSelected ? Colors.blue : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 20)),
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          mSelected = false;
                          fSelected = true;
                          gender = 'F';
                        });
                      },
                      child: Text('여아', style: TextStyle(color: fSelected ? Colors.white : Colors.blue)),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          fSelected ? Colors.blue : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Text('생일은 언제인가요?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextFormField(
                readOnly: true,
                controller: birth = TextEditingController(
                  text: selectedDate == null ? '' : '${selectedDate?.year}-${selectedDate?.month}-${selectedDate?.day}',
                ),
                onTap: () {
                  _selectDate(context);
                },
                decoration: InputDecoration(
                  hintText: '생일을 선택해 주세요',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Row(
                children: [
                  Text('어떤 묘종인가요?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              TextFormField(
                controller: breed,
                decoration: InputDecoration(
                  hintText: "묘종을 알려주세요",
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 50)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('이전으로'),
                  ),
                  Padding(padding: EdgeInsets.only(right: 150)),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _register();
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                              content: Text("회원가입이 완료되었습니다."),
                              actions: [
                                Center(
                                  child: ElevatedButton(
                                    style: TextButton.styleFrom(backgroundColor: Colors.black),
                                    child: Text("로그인페이지로 이동"),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()));
                                    },
                                  ),
                                ),
                              ],
                            )
                        );
                      } else {
                        print("회원가입 실패");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      minimumSize: Size(100,50),
                      backgroundColor: Colors.black,
                    ),
                    child: Text("다음", style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}