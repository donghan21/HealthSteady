import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  late double W;
  late double H;
  FirebaseFirestore db = FirebaseFirestore.instance;
  ValueNotifier<bool> expandedNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> expandedNotifier2 = ValueNotifier<bool>(false);
  late List<ValueNotifier<bool>> checkboxNotifiers;
  bool _doingWorkout = false;

  Stopwatch stopwatch = Stopwatch();
  late Timer timer;
  late int result;

  TextEditingController _memoController = TextEditingController();

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

  Future<Map<String, dynamic>> _fetchData() async {
    CollectionReference users = db.collection('users');
    DocumentSnapshot user =
        await users.doc(FirebaseAuth.instance.currentUser!.email).get();
    Map<String, dynamic> data = user.data() as Map<String, dynamic>;
    return data;
  }

  String getWeekday() {
    var now = DateTime.now();
    var weekday = now.weekday;

    switch (weekday) {
      case DateTime.monday:
        return 'monday';
      case DateTime.tuesday:
        return 'tuesday';
      case DateTime.wednesday:
        return 'wednesday';
      case DateTime.thursday:
        return 'thursday';
      case DateTime.friday:
        return 'friday';
      case DateTime.saturday:
        return 'saturday';
      case DateTime.sunday:
        return 'sunday';
      default:
        return 'monday';
    }
  }

  void startOrResumeStopwatch() {
    if(!stopwatch.isRunning) {
      stopwatch.start();
      timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        setState(() {
          
        });
      });
    }
  }

  void pauseStopwatch() {
    if(stopwatch.isRunning) {
      stopwatch.stop();
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    H = MediaQuery.of(context).size.height;
    W = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
            future: _fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<dynamic> goal = snapshot.data!['goal_sentence'] ?? [];
                checkboxNotifiers = List<ValueNotifier<bool>>.generate(
                    goal.length, (index) => ValueNotifier<bool>(false));      
                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: H * 0.05),
                        if(_doingWorkout == false)
                        Container(
                            height: H * 0.05,
                            width: W,
                            color: Colors.white,
                            child: snapshot.data!['goal'][getWeekday()] != null
                                ? Center(
                                    child: Text(
                                    '오늘은 ${snapshot.data!['goal'][getWeekday()][0].split(':')[0]}시 ${snapshot.data!['goal'][getWeekday()][0].split(':')[1]}분에 헬스장에 가기로 했어요!',
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    maxLines: 1,
                                  ))
                                : const Center(
                                    child: Text(
                                    '오늘은 운동 예정일이 아닙니다',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    maxLines: 1,
                                  ))),
                        if(_doingWorkout == false)
                        Container(
                          width: W,
                          height: H*0.2,
                          color: Colors.white,
                          child: Row(children: [
                            SizedBox(width: W*0.1),
                            Container(
                              width: W*0.4,
                              child: Image.asset('assets/images/memoticon1.png'),
                            
                            ),
                            Container(
                              width: W*0.4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    
                                    flex: 1,
                                    child: Text(snapshot.data!['nickname'], style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                        
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 1,
                                    child: Center(child: Text('00 : 00', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold))),
                        
                                  ),
                                  Flexible(                                  
                                    flex: 1,
                                    child: ElevatedButton(
                                      onPressed: (){
                                        setState(() {
                                          _doingWorkout = true;
                                          startOrResumeStopwatch();
                                        });
                                      },
                                      child: Text('START', style: TextStyle( color: Colors.white, fontWeight: FontWeight.bold)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],)
                            )
                          ],)
                        ),
                        if(_doingWorkout == true)
                         Container(
                          height: H * 0.25,
                          width: W,
                          color: Colors.white,
                          child: Row(children: [
                            SizedBox(width: W*0.05),
                            Container(
                              width: W*0.4,
                              child: Image.asset('assets/images/memoticon1.png'),                          
                            ),
                            Container(
                              width: W*0.5,
                              child: Column(
                                
                                children: [
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 2,
                                    child: Center(child: Text('${stopwatch.elapsed.inMinutes} : ${(stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}', style: TextStyle(color: Colors.black, fontSize: 50, fontWeight: FontWeight.bold))),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children : [
                                        InkWell(
                                          onTap: () {
                                            if(stopwatch.isRunning) pauseStopwatch();
                                            else startOrResumeStopwatch();
                                           
                                          },
                                          child: Container(
                                            height: H * 0.05,
                                            width: W*0.18,
                                          child: Center(child: Text(stopwatch.isRunning ? 'PAUSE' : 'RESUME', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          ),
                                        ),
                                        SizedBox(width: W * 0.04),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _doingWorkout = false;
                                              result = stopwatch.elapsed.inSeconds;
                                              timer.cancel();
                                              stopwatch.stop();
                                              stopwatch.reset();
                                            });
                                            
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(result: result)));
                                            
                                          },
                                          child: Container(
                                            height: H * 0.05,
                                            width: W*0.18,
                                          child: Center(child: Text('STOP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          ),
                                        ),
                                      ]
                                    )
                                  )
                                ]
                              )
                            ),
                          ],)
                        ),
                        //WorkoutWidget(),
                        
                        ExpansionTile(
                          initiallyExpanded: true,
                          onExpansionChanged: (bool expanded) {
                            expandedNotifier.value = expanded;
                          },
                          title: Container(),
                          trailing: SizedBox(),
                          leading: FittedBox(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ValueListenableBuilder<bool>(
                                  valueListenable: expandedNotifier,
                                  builder: (BuildContext context, bool isExpanded,
                                      Widget? child) {
                                    return Icon(
                                        isExpanded
                                            ? Icons.arrow_drop_down
                                            : Icons.arrow_right,
                                        color: Colors.white,
                                        size: 30.0);
                                  },
                                ),
                                Text('나의 운동 목표',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0)),
                              ],
                            ),
                          ),
                          children: goal.length != 0
                              ? goal.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  String goal = entry.value;
                                  return Container(
                                    height: H * 0.05,
                                    width: W,
                                    color: Colors.black,
                                    child: Center(
                                      child: Row(
                                        children: [
                                          SizedBox(width: W * 0.05),
                                          ValueListenableBuilder<bool>(
                                            valueListenable:
                                                checkboxNotifiers[index],
                                            builder: (BuildContext context,
                                                bool isChecked, Widget? child) {
                                              return Checkbox(
                                                value: isChecked,
                                                onChanged: (bool? value) {
                                                  checkboxNotifiers[index].value =
                                                      value!;
                                                },
                                                activeColor: Colors.red,
                                              );
                                            },
                                          ),
                                          Text(
                                            goal,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList()
                              : [
                                  Container(
                                    height: H * 0.05,
                                    width: W,
                                    color: Colors.black,
                                    child: Center(
                                      child: Text(
                                        '운동 목표가 없습니다',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18),
                                        maxLines: 1,
                                      ),
                                    ),
                                  )
                                ],
                        ),
                        ExpansionTile(
                          initiallyExpanded: true,
                          onExpansionChanged: (bool expanded) {
                            expandedNotifier2.value = expanded;
                          },
                          title: Container(),
                          trailing: SizedBox(),
                          leading: FittedBox(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ValueListenableBuilder<bool>(
                                  valueListenable: expandedNotifier2,
                                  builder: (BuildContext context, bool isExpanded,
                                      Widget? child) {
                                    return Icon(
                                        isExpanded
                                            ? Icons.arrow_drop_down
                                            : Icons.arrow_right,
                                        color: Colors.white,
                                        size: 30.0);
                                  },
                                ),
                                Text('MEMO',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0)),
                              ],
                            ),
                          ),
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(W * 0.08, H * 0.03, W * 0.08, H * 0.03),//EdgeInsets.all(10) 
                              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.white, width: 2.0), borderRadius: BorderRadius.circular(15)),// EdgeInsets.all(10
                              height: H * 0.2,                  
                              width: W,
                              child: TextField(
                                controller: _memoController,                              
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                                maxLines: 10,
                              ),
                            )                        
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
        backgroundColor: Colors.black,
      ),
    );
  }
}
