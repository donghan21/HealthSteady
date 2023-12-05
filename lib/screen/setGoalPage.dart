import 'package:flutter/material.dart';
import '../utils/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class SetGoalPage extends StatefulWidget {
  const SetGoalPage({super.key});

  @override
  State<SetGoalPage> createState() => _SetGoalPageState();
}

class _SetGoalPageState extends State<SetGoalPage> {
  late double W;
  late double H;
  Day _monday = Day(name : '월', isChecked: true, startTime: TimeOfDay(hour: 15, minute: 30), endTime: TimeOfDay(hour: 18, minute: 0));


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    W = MediaQuery.of(context).size.width;
    H = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('운동목표 수정', style: TextStyle(color: Colors.white, fontSize: 20.0)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),),
      
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.fromLTRB(W*0.03, H*0.03, W*0.03, H*0.03),
        child: Column( children: [   
          SizedBox(height: H * 0.04,
            child: Row(children: [
            SizedBox(width: W*0.02,),
            SizedBox(width: W * 0.3, child: Center(child: Text('요일', style: TextStyle(color: Colors.white, fontSize: 20,)))),
            SizedBox(width: W * 0.3, child: Center(child: Text('시작 시간', style: TextStyle(color: Colors.white, fontSize: 20.0)))),
            SizedBox(width: W*0.3, child: Center(child: Text('종료 시간', style: TextStyle(color: Colors.white, fontSize: 20))))
          ]),),
          Divider(color: Colors.white, indent: W*0.03, endIndent: W*0.03),
          DayRow(day: _monday),
          
            
      
        ]),
      ),
      
      ),
    );
  }
}

class Day {
  bool isChecked;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String name;

  Day({
    required this.isChecked,
    required this.startTime,
    required this.endTime,
    required this.name,
  });
}

class DayRow extends StatefulWidget {
  final Day day;
  
    DayRow({required this.day});

  @override
  _DayRowState createState() => _DayRowState();
}

class _DayRowState extends State<DayRow> {
  late double H;
  late double W;

  @override
  Widget build(BuildContext context) {
    H = MediaQuery.of(context).size.height;
    W = MediaQuery.of(context).size.width;
    return SizedBox(
      height: H * 0.08,
      child: Row(
        children: [
          SizedBox(
            width: W * 0.15,
            child: Checkbox(
              activeColor: Colors.red,
              value: widget.day.isChecked,
              onChanged: (bool? value) {
                setState(() {
                  widget.day.isChecked = value!;
                });
              },
            ),
          ),
          SizedBox(width: W * 0.17, child: Center(child: Text(widget.day.name, style: TextStyle(color: Colors.white, fontSize: 18)))),
          SizedBox(
            width: W * 0.3,
            child: TextButton( 
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),           
              child: Text(widget.day.startTime.format(context)),
              onPressed: widget.day.isChecked ? () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: widget.day.startTime,
                );
                if (picked != null) {
                  setState(() {
                    widget.day.startTime = picked;
                  });
                }
              } : null,
            ),
          ),
          SizedBox(
            width: W * 0.3,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text(widget.day.endTime.format(context)),
              onPressed: widget.day.isChecked ? () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: widget.day.endTime,
                );
                if (picked != null) {
                  setState(() {
                    widget.day.endTime = picked;
                  });
                }
              } : null,
            ),
          ),
        ]
      ),
    );
  }
}