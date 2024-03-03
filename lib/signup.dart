import 'dart:async';
import 'dart:convert';

import 'package:catcare/cat.dart';
import 'package:http/http.dart' as http;
import 'package:catcare/config.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  late bool status;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      _checkId();
    });
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();

  Future<void> _checkId() async {
    try {
      final response = await http.post(Uri.parse(checkId),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email.text}),
      );

      if (response.statusCode == 200) {
        status = true;
      } else {
        status = false;
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
              Text(
                "회원가입",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 60)
              ),
              Text('이메일', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: email,
                decoration: InputDecoration(
                  hintText: "이메일 입력",
                ),
                validator: (value) {
                  bool emailVlid = RegExp(
                      r"^[a-z0-9._-]+@[a-z]+\.[a-z]")
                      .hasMatch(value!);
                  if(value.isEmpty) {
                    return "이메일을 입력해 주세요.";
                  } else if(!emailVlid) {
                    return "잘못된 형식의 이메일 주소입니다.";
                  } else if(!status) {
                    return "이미 사용중인 아이디입니다.";
                  }
                },
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Text('비밀번호', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: password,
                decoration: InputDecoration(
                  hintText: "비밀번호 입력",
                ),
                obscureText: true,
                validator: (value) {
                  bool pwdVlid = RegExp(
                      r"^[a-zA-Z0-9`~!@#$%^&*()-_=+]{8,24}")
                      .hasMatch(value!);
                  if(value.isEmpty) {
                    return "비밀번호를 입력해 주세요.";
                  } else if(value.length < 8 || value.length > 24 || !pwdVlid) {
                    return "8~24자리(영문자/숫자/특수문자)로 입력할 수 있어요.";
                  }
                },
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Text('비밀번호 확인', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintText: "비밀번호 확인",
                ),
                obscureText: true,
                validator: (value) {
                  bool pwdVlid = RegExp(
                      r"^[a-zA-Z0-9`~!@#$%^&*()-_=+]{8,24}")
                      .hasMatch(value!);
                  if(value!.isEmpty) {
                    return "비밀번호를 확인해 주세요.";
                  } else if(value != password.value.text) {
                    return "비밀번호가 일치하지 않습니다.";
                  }
                },
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Text('이름', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: name,
                decoration: InputDecoration(
                  hintText: "이름 입력",
                ),
                validator: (value) {
                  if(value!.isEmpty) {
                    return "이름을 입력해 주세요.";
                  }
                },
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Text('휴대폰 번호', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: phone,
                decoration: InputDecoration(
                  hintText: "휴대폰 번호 입력",
                ),
                validator: (value) {
                  bool phoneVlid = RegExp(
                      r"^\d{10,11}")
                      .hasMatch(value!);
                  if(value.isEmpty) {
                    return "전화번호를 입력해 주세요.";
                  } else if(!phoneVlid) {
                    return "잘못된 형식의 전화번호입니다.";
                  }
                },
              ),
              Padding(padding: EdgeInsets.only(top: 50)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Cat(email: email.text, password: password.text, name: name.text, phone: phone.text)));
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