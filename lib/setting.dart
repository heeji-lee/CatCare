import 'dart:convert';

import 'package:catcare/config.dart';
import 'package:catcare/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Setting extends StatefulWidget {
  final String email;

  const Setting({Key? key, required this.email}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  dynamic data;
  dynamic cat_name, gender, birth, breed, email, password, user_name, phone;

  Future<void> userdata() async {
    try {
      final response = await http.post(Uri.parse(setting),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.email,
        }),
      );

      if (response.statusCode == 200) {
        data = json.decode(response.body);
        cat_name = data[0]['cat_name'];
        gender = data[0]['gender'];
        birth = data[0]['birth'];
        breed = data[0]['breed'];
        email = data[0]['email'];
        password = data[0]['password'];
        user_name = data[0]['user_name'];
        phone = data[0]['phone'];
      } else {
        print("요청 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("예외 발생: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    userdata();
  }

  String _gender(String gender) {
    if (gender == 'M') {
      return '♂';
    } else {
      return '♀';
    }
  }

  String calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return '$age';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 100),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                '설정',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.blue
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 80)),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '나의 반려동물 정보',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.grey
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 125)),
                        Text(
                          '수정',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 15)),
                    Center(
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              child: CircleAvatar(
                                backgroundImage: AssetImage('assets/images/cat.jpg'),
                                radius: 40.0,
                              ),
                              padding: EdgeInsets.only(left: 20),
                              alignment: Alignment.centerLeft,
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text('이름', style: TextStyle(color: Colors.grey)),
                                            Padding(padding: EdgeInsets.only(top: 15)),
                                            Text('생년월일', style: TextStyle(color: Colors.grey)),
                                          ],
                                        ),
                                        Padding(padding: EdgeInsets.only(left: 10)),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                data != null ? Text(cat_name) : Text(''),
                                                Padding(padding: EdgeInsets.only(left: 5)),
                                                data != null ? Text(_gender(gender), style: TextStyle(fontSize:20, color: Colors.blue)) : Text(''),
                                              ],
                                            ),
                                            Padding(padding: EdgeInsets.only(top: 7)),
                                            Row(
                                              children: [
                                                data != null ? Text(birth != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(birth)) : ''): Text(''),
                                                Padding(padding: EdgeInsets.only(left: 5)),
                                                Text('(', style: TextStyle(color: Colors.blue)),
                                                data != null ? Text(birth != null ? calculateAge(DateTime.parse(birth)) : '0', style: TextStyle(color: Colors.blue)): Text('0', style: TextStyle(color: Colors.blue)),
                                                Text('세)', style: TextStyle(color: Colors.blue)),
                                              ],
                                            ),
                                            Padding(padding: EdgeInsets.only(bottom: 5)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                            ),
                          ],
                        ),
                        height: 130,
                        width: 300,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                height: 200,
                width: 325,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              // Padding(padding: EdgeInsets.only(top: 20)),
              // Container(
              //   padding: EdgeInsets.all(15),
              //   child: Column(
              //     children: [
              //       Row(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             '기기 연동 및 관리',
              //             style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: 18,
              //                 color: Colors.grey
              //             ),
              //           ),
              //           Padding(padding: EdgeInsets.only(left: 145)),
              //           Image.asset("assets/images/menu.png", width: 20, height: 30, color: Colors.grey),
              //         ],
              //       ),
              //       Padding(padding: EdgeInsets.only(top: 10)),
              //       Container(
              //         child: Row(
              //           children: [
              //             Padding(padding: EdgeInsets.only(left: 20)),
              //             Image.asset("assets/images/phone.png", width: 70, height: 100, color: Colors.grey),
              //             Padding(
              //               padding: EdgeInsets.only(left: 10),
              //               child: Column(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: [
              //                   Row(
              //                     children: [
              //                       Column(
              //                         children: [
              //                           Text('기기명', style: TextStyle(color: Colors.grey)),
              //                           Padding(padding: EdgeInsets.only(top: 15)),
              //                           Text('기종', style: TextStyle(color: Colors.grey)),
              //                         ],
              //                       ),
              //                       Padding(padding: EdgeInsets.only(left: 10)),
              //                       Column(
              //                         crossAxisAlignment: CrossAxisAlignment.start,
              //                         children: [
              //                           Row(
              //                             children: [
              //                               Text('Glaxy Z Flip3 5G'),
              //                             ],
              //                           ),
              //                           Padding(padding: EdgeInsets.only(top: 14)),
              //                           Row(
              //                             children: [
              //                               Text('SM-F711N'),
              //                             ],
              //                           ),
              //                         ],
              //                       ),
              //                     ],
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //         height: 130,
              //         width: 300,
              //         color: Colors.white,
              //       )
              //     ],
              //   ),
              //   height: 200,
              //   width: 325,
              //   decoration: BoxDecoration(
              //     color: Color(0xFFEEEEEE),
              //     borderRadius: BorderRadius.circular(25),
              //   ),
              // ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '계정 관리',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.grey
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 25)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: (){

                              }, style: TextButton.styleFrom(minimumSize: Size(200,40), backgroundColor: Colors.white),
                              child: Text(
                                '회원 정보 수정',
                                style: TextStyle(color: Color(0xFF000000)),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 10)),
                            ElevatedButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()));
                              }, style: TextButton.styleFrom(minimumSize: Size(200,40), backgroundColor: Colors.white),
                              child: Text(
                                '로그아웃',
                                style: TextStyle(color: Color(0xFF000000)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                height: 200,
                width: 325,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(25),
                ),
              )
            ]
          )
        )
    );
  }
}