import 'dart:async';
import 'dart:convert';

import 'package:catcare/config.dart';
import 'package:catcare/main.dart';
import 'package:flutter/material.dart';
import 'package:catcare/signup.dart';
import 'package:http/http.dart' as http;

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {

  late bool status;
  bool _idpwdchk = false;
  bool _isAutoLogin = false;

  final _formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _pwdFocusNode = FocusNode();

  Future<void> _login() async {
    try {
      final response = await http.post(Uri.parse(signin),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email.text,
          "password": password.text,
        }),
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
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Center(
          child: Form(
            key: _formKey,// 가로축 가운데 정렬
            child: Column( // 세로 컬럼 생성
              mainAxisAlignment: MainAxisAlignment.center, // 새로축 가운데 정렬
              children: <Widget> [ // 컬럼에 들어갈 위젯들
                Text(
                  "LOGIN",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.black,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 40)
                ),
                TextFormField(
                  focusNode: _emailFocusNode,
                  decoration: InputDecoration(
                    hintText: "이메일 입력",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "이메일을 입력해 주세요.";
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  controller: email,
                ),
                TextFormField(
                  focusNode: _pwdFocusNode,
                  decoration: InputDecoration(
                    hintText: "비밀번호 입력",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "비밀번호를 입력해 주세요.";
                    }
                  },
                  keyboardType: TextInputType.visiblePassword,
                  controller: password,
                  obscureText: true,
                ),
                Row(
                    children: [
                      Checkbox(
                        value: _isAutoLogin,
                        onChanged: (value) {
                          setState(() {
                            _isAutoLogin = value!;
                          });
                        },
                      ),
                      Text("로그인 유지"),
                    ]
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(!_idpwdchk)
                      Text("아이디 또는 비밀번호가 일치하지 않습니다.", style: TextStyle(color: Colors.red)),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 30)),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login();
                      if(status) {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => CatPage(email: email.text)));
                      } else {
                        setState(() {
                          _idpwdchk = !_idpwdchk;
                        });
                        email.clear();
                        password.clear();
                      }
                    } else {
                      if (email.text.isEmpty) {
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      } else if(password.text.isEmpty) {
                        FocusScope.of(context).requestFocus(_pwdFocusNode);
                      }
                      print("로그인 실패");
                    }
                  },
                  style: TextButton.styleFrom(minimumSize: Size(150,50), backgroundColor: Colors.black),
                  child: Text("로그인", style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Text("ID/PW 찾기"),
                      onTap: () {

                      },
                    ),
                    Text(' | '),
                    GestureDetector(
                      child: Text("회원가입"),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
