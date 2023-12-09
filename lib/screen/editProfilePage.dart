import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late double W;
  late double H;
  FirebaseFirestore db = FirebaseFirestore.instance;
  late Day _monday;
  late Day _tuesday;
  late Day _wednesday;
  late Day _thursday;
  late Day _friday;
  late Day _saturday;
  late Day _sunday;

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

  Future<List<Day>> getDaysFromDatabase() async {
    List<Day> days = [];
    CollectionReference users = db.collection('users');
    DocumentReference user = users.doc(FirebaseAuth.instance.currentUser!.email);
    DocumentSnapshot snapshot = await user.get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    var goalMap = data['goal'];
    print('goalMap : $goalMap');
    if(goalMap['monday'] == null) {
      days.add(Day(name : '월', isChecked: false, startTime: TimeOfDay(hour: 0, minute: 00), endTime: TimeOfDay(hour: 0, minute: 0)));
    } else {
      days.add(Day(name : '월', isChecked: true, startTime: TimeOfDay(hour: int.parse(goalMap['monday'][0].split(':')[0]), minute: int.parse(goalMap['monday'][0].split(':')[1])), endTime: TimeOfDay(hour: int.parse(goalMap['monday'][1].split(':')[0]), minute: int.parse(goalMap['monday'][1].split(':')[1]))));
    }
    if(goalMap['tuesday'] == null) {
      days.add(Day(name : '화', isChecked: false, startTime: TimeOfDay(hour: 0, minute: 00), endTime: TimeOfDay(hour: 0, minute: 0)));
    } else {
      days.add(Day(name : '화', isChecked: true, startTime: TimeOfDay(hour: int.parse(goalMap['tuesday'][0].split(':')[0]), minute: int.parse(goalMap['tuesday'][0].split(':')[1])), endTime: TimeOfDay(hour: int.parse(goalMap['tuesday'][1].split(':')[0]), minute: int.parse(goalMap['tuesday'][1].split(':')[1]))));
    }
    if(goalMap['wednesday'] == null) {
      days.add(Day(name : '수', isChecked: false, startTime: TimeOfDay(hour: 0, minute: 00), endTime: TimeOfDay(hour: 0, minute: 0)));
    } else {
      days.add(Day(name : '수', isChecked: true, startTime: TimeOfDay(hour: int.parse(goalMap['wednesday'][0].split(':')[0]), minute: int.parse(goalMap['wednesday'][0].split(':')[1])), endTime: TimeOfDay(hour: int.parse(goalMap['wednesday'][1].split(':')[0]), minute: int.parse(goalMap['wednesday'][1].split(':')[1]))));
    }
    if(goalMap['thursday'] == null) {
      days.add(Day(name : '목', isChecked: false, startTime: TimeOfDay(hour: 0, minute: 00), endTime: TimeOfDay(hour: 0, minute: 0)));
    } else {
      days.add(Day(name : '목', isChecked: true, startTime: TimeOfDay(hour: int.parse(goalMap['thursday'][0].split(':')[0]), minute: int.parse(goalMap['thursday'][0].split(':')[1])), endTime: TimeOfDay(hour: int.parse(goalMap['thursday'][1].split(':')[0]), minute: int.parse(goalMap['thursday'][1].split(':')[1]))));
    }
    if(goalMap['friday'] == null) {
      days.add(Day(name : '금', isChecked: false, startTime: TimeOfDay(hour: 0, minute: 00), endTime: TimeOfDay(hour: 0, minute: 0)));
    } else {
      days.add(Day(name : '금', isChecked: true, startTime: TimeOfDay(hour: int.parse(goalMap['friday'][0].split(':')[0]), minute: int.parse(goalMap['friday'][0].split(':')[1])), endTime: TimeOfDay(hour: int.parse(goalMap['friday'][1].split(':')[0]), minute: int.parse(goalMap['friday'][1].split(':')[1]))));
    }
    if(goalMap['saturday'] == null) {
      days.add(Day(name : '토', isChecked: false, startTime: TimeOfDay(hour: 0, minute: 00), endTime: TimeOfDay(hour: 0, minute: 0)));
    } else {
      days.add(Day(name : '토', isChecked: true, startTime: TimeOfDay(hour: int.parse(goalMap['saturday'][0].split(':')[0]), minute: int.parse(goalMap['saturday'][0].split(':')[1])), endTime: TimeOfDay(hour: int.parse(goalMap['saturday'][1].split(':')[0]), minute: int.parse(goalMap['saturday'][1].split(':')[1]))));
    }
    if(goalMap['sunday'] == null) {
      days.add(Day(name : '일', isChecked: false, startTime: TimeOfDay(hour: 0, minute: 00), endTime: TimeOfDay(hour: 0, minute: 0)));
    } else {
      days.add(Day(name : '일', isChecked: true, startTime: TimeOfDay(hour: int.parse(goalMap['sunday'][0].split(':')[0]), minute: int.parse(goalMap['sunday'][0].split(':')[1])), endTime: TimeOfDay(hour: int.parse(goalMap['sunday'][1].split(':')[0]), minute: int.parse(goalMap['sunday'][1].split(':')[1]))));
    }
    print('days : ${days[0].startTime.format(context)}');
    return days;
  }

  @override
  Widget build(BuildContext context) {
    W = MediaQuery.of(context).size.width;
    H = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('주간목표 수정', style: TextStyle(color: Colors.white, fontSize: 20.0)),
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
          FutureBuilder<List<Day>>(future: getDaysFromDatabase(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.red));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              _monday = snapshot.data![0];
              _tuesday = snapshot.data![1];
              _wednesday = snapshot.data![2];
              _thursday = snapshot.data![3];
              _friday = snapshot.data![4];
              _saturday = snapshot.data![5];
              _sunday = snapshot.data![6];

              List<Day> days = [_monday, _tuesday, _wednesday, _thursday, _friday, _saturday, _sunday];
              
              return Column(
                children: days.map((day) => DayRow(day: day)).toList(),
                );
            }
          },         
          ),
          SizedBox(height: H * 0.04),
          Center(
            child: InkWell(
              onTap: () async {
                CollectionReference users = db.collection('users');
                DocumentReference user = users.doc(FirebaseAuth.instance.currentUser!.email);
                DocumentSnapshot snapshot = await user.get();
                Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
                List<dynamic>? others = data['goal']['others'];
                Map<String, dynamic> goalMap = {};
                goalMap.addAll({'others' : others});
                if(_monday.isChecked) {
                  List<String> monday = [];
                  monday.add('${_monday.startTime.hour.toString().padLeft(2, '0')}:${_monday.startTime.minute.toString().padLeft(2, '0')}');
                  monday.add('${_monday.endTime.hour.toString().padLeft(2, '0')}:${_monday.endTime.minute.toString().padLeft(2, '0')}');
                  goalMap.addAll({'monday' : monday});
                } else {
                  goalMap.addAll({'monday' : null});
                }
                if(_tuesday.isChecked) {
                  List<String> tuesday = [];
                  tuesday.add('${_tuesday.startTime.hour.toString().padLeft(2, '0')}:${_tuesday.startTime.minute.toString().padLeft(2, '0')}');
                  tuesday.add('${_tuesday.endTime.hour.toString().padLeft(2, '0')}:${_tuesday.endTime.minute.toString().padLeft(2, '0')}');
                  goalMap.addAll({'tuesday' : tuesday});
                } else {
                  goalMap.addAll({'tuesday' : null});
                }
                if(_wednesday.isChecked) {
                  List<String> wednesday = [];
                  wednesday.add('${_wednesday.startTime.hour.toString().padLeft(2, '0')}:${_wednesday.startTime.minute.toString().padLeft(2, '0')}');
                  wednesday.add('${_wednesday.endTime.hour.toString().padLeft(2, '0')}:${_wednesday.endTime.minute.toString().padLeft(2, '0')}');
                  goalMap.addAll({'wednesday' : wednesday});
                } else {
                  goalMap.addAll({'wednesday' : null});
                }
                if(_thursday.isChecked) {
                  List<String> thursday = [];
                  thursday.add('${_thursday.startTime.hour.toString().padLeft(2, '0')}:${_thursday.startTime.minute.toString().padLeft(2, '0')}');
                  thursday.add('${_thursday.endTime.hour.toString().padLeft(2, '0')}:${_thursday.endTime.minute.toString().padLeft(2, '0')}');
                  goalMap.addAll({'thursday' : thursday});
                } else {
                  goalMap.addAll({'thursday' : null});
                }
                if(_friday.isChecked) {
                  List<String> friday = [];
                  friday.add('${_friday.startTime.hour.toString().padLeft(2, '0')}:${_friday.startTime.minute.toString().padLeft(2, '0')}');
                  friday.add('${_friday.endTime.hour.toString().padLeft(2, '0')}:${_friday.endTime.minute.toString().padLeft(2, '0')}');
                  goalMap.addAll({'friday' : friday});
                } else {
                  goalMap.addAll({'friday' : null});
                }
                if(_saturday.isChecked) {
                  List<String> saturday = [];
                  saturday.add('${_saturday.startTime.hour.toString().padLeft(2, '0')}:${_saturday.startTime.minute.toString().padLeft(2, '0')}');
                  saturday.add('${_saturday.endTime.hour.toString().padLeft(2, '0')}:${_saturday.endTime.minute.toString().padLeft(2, '0')}');
                  goalMap.addAll({'saturday' : saturday});
                } else {
                  goalMap.addAll({'saturday' : null});
                }
                if(_sunday.isChecked) {
                  List<String> sunday = [];
                  sunday.add('${_sunday.startTime.hour.toString().padLeft(2, '0')}:${_sunday.startTime.minute.toString().padLeft(2, '0')}');
                  sunday.add('${_sunday.endTime.hour.toString().padLeft(2, '0')}:${_sunday.endTime.minute.toString().padLeft(2, '0')}');
                  goalMap.addAll({'sunday' : sunday});
                } else {
                  goalMap.addAll({'sunday' : null});
                }
                
                
                await user.update({'goal' : goalMap});
                Fluttertoast.showToast(
                  msg: '운동목표를 수정했습니다.',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                );          
              },
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),border: Border.all(color: Colors.white, width: 2.0)), 
                height: H * 0.05, 
                width: W * 0.3,
                child: Center(
                  child: Text('수정하기', style: TextStyle(color: Colors.white, fontSize: 20.0)))),
            )),
          
            
      
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
      height: H * 0.09,
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