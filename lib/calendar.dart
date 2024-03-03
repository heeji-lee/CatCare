import 'dart:convert';
import 'dart:ui';

import 'package:catcare/config.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:catcare/memo.dart';
import 'package:http/http.dart' as http;

class Calendar extends StatefulWidget {
  final String email;

  const Calendar({Key? key, required this.email}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay, _selectedEvents;
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
        // _selectedEvents = _getEventsForDay(selectedDay);
      });
    }
  }

  Map<DateTime, List<String>> _events = {};
  Future<void> _memodata() async {
    try {
      final response = await http.post(Uri.parse(calendar),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.email
        }),
      );

      if (response.statusCode == 200) {
        dynamic data = json.decode(response.body);
        setState(() {
          for (var item in data) {
            DateTime date = DateTime.parse(item['date']);
            String title = item['titles'];
            if (_events[date] == null) {
              _events[date] = [];
            }
            _events[date]!.add(title);
          }
        });
        print(_events);
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
    _memodata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 80)),
            Text(
              '건강 다이어리',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.blue
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            SizedBox(
              width: 600,
              height: 400,
              child: TableCalendar(
                locale: 'ko_KR',
                headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: const TextStyle(
                      fontSize: 20.0,
                      color: Color(0xFF000000),
                    ),
                ),
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(1900,1,1),
                lastDay: DateTime.utc(2100,12,31),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: _onDaySelected,
                eventLoader: (day) {
                  return _events[day] ?? [];
                },
                calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Container(
                      width: 35,
                      decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          shape: BoxShape.circle),
                    );
                  }
                }),
              ),
            ),
            Container(
              width: 300,
              height: 150,
              child: ListView.builder(
                itemCount: _events[_selectedDay]?.length ?? 0,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_events[_selectedDay]![index]),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(padding: EdgeInsets.only(top: 20)),
                FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Memo(email: widget.email,selectedDate: _selectedDay)));
                  }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}