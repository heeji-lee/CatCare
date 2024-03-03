import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  final String email;

  const Report({Key? key, required this.email}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {

  List<bool> isSelected = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 100),
      child: Center(
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Text(
                    '냥수무강 리포트',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.blue
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 40)
                  ),
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(5),
                    selectedColor: Colors.grey,
                    fillColor: Colors.white,
                    renderBorder: true,
                    children: [Text('일간', style: TextStyle(color: Colors.blue)), Text('주간', style: TextStyle(color: Colors.blue)), Text('월간', style: TextStyle(color: Colors.blue))],
                    onPressed: (int index) {
                      for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                        setState(() {
                          isSelected[buttonIndex] = buttonIndex == index;
                        });
                      }
                    }, isSelected: isSelected,
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}