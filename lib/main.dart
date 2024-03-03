import 'package:catcare/calendar.dart';
import 'package:catcare/report.dart';
import 'package:catcare/screen.dart';
import 'package:catcare/setting.dart';
import 'package:catcare/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {

  await initializeDateFormatting();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Flutter',
      theme: ThemeData(
        primaryColor: Color(0xFF000000),
      ),
      home: const Signin(),
    );
  }
}

class CatPage extends StatefulWidget {
  final String email;

  const CatPage({Key? key, required this.email}) : super(key: key);

  @override
  State<CatPage> createState() => _CatPageState();
}

class TabPage extends StatefulWidget {
  @override
  _CatPageState createState() => _CatPageState();
}

class _CatPageState extends State<CatPage> {
  int _selectedIndex = 1;

  // List _pages = [Screen(), Report(), Calendar(), Setting()];
  late List _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      Screen(),
      Report(email: widget.email),
      Calendar(email: widget.email),
      Setting(email: widget.email),
    ];

    print(widget.email);
  }

  DateTime? backKeyPressedTime;

  Future<bool> onWillPop() {
    if(backKeyPressedTime == null || DateTime.now().difference(backKeyPressedTime!) > Duration(seconds: 2)) {
      backKeyPressedTime = DateTime.now();
      Fluttertoast.showToast(msg: "'뒤로'버튼을 한번 더 누르시면 종료됩니다.");
      return Future.value(false);
    }
    SystemNavigator.pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          body: _pages[_selectedIndex], // 페이지와 연결
          bottomNavigationBar: BottomNavigationBar(
            onTap: _onItemTapped, // 클릭 이벤트
            currentIndex: _selectedIndex, // 현재 선택된 index
            type: BottomNavigationBarType.fixed, // item이 4개 이상일 경우 추가
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt),
                label: '영상',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.insert_chart),
                label: '리포트',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: '건강 수첩',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: '설정',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    // state 갱신
    setState(() {
      _selectedIndex = index; // index는 item 순서로 0, 1, 2, 3으로 구성
    });
  }
}