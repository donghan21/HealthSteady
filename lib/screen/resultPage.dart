import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResultPage extends StatefulWidget {
  final int result;

  const ResultPage({super.key, required this.result});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late double H;
  late double W;

  @override
  void initState() {
    super.initState();
    _addWorkoutTime(widget.result);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  _addWorkoutTime(int result) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference users = db.collection('users');
    DocumentReference user = users.doc(FirebaseAuth.instance.currentUser!.email);
    user.update({
      'workout_time.actual' : FieldValue.increment(result~/60),
    });
  }


  @override
  Widget build(BuildContext context) {
    H = MediaQuery.of(context).size.height;
    W = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Column(children: [
            Container(height: H * 0.05, color: Colors.black),
            Container(height: H * 0.08, color: Colors.white, child: Row(
              children: [
                SizedBox(width : W * 0.15, child: IconButton(onPressed: () {
                  Navigator.pop(context);
                }, icon: const Icon(Icons.arrow_back_ios, color: Colors.black,))
                ),
                SizedBox(width: W * 0.15),
                SizedBox(width: W * 0.4, child: Center(child: Text('운동 종료', style: TextStyle(color: Colors.red, fontSize: 30.0, fontWeight: FontWeight.w500)))),
              ]
            ),
            ),
            SizedBox(height: H * 0.05),
            SizedBox(height: H * 0.08, child: Row(children: [
              SizedBox(width: W * 0.15, child: Icon(Icons.thumb_up),),
              SizedBox(width: W * 0.7 ,child: Center(child: Text('오늘도 수고하셨습니다!', style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500)))),
              SizedBox(width: W*0.15, child: Icon(Icons.thumb_up),),
            ])),
            SizedBox(height: H * 0.05),
            SizedBox(height: H * 0.05, child: Text('오늘의 운동 시간', style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500))),
            SizedBox(height: H * 0.1, child: Center(child: Text('${widget.result ~/ 60}분 ${widget.result % 60}초', style: TextStyle(color: Colors.black, fontSize: 50.0, fontWeight: FontWeight.w500)))),
            SizedBox(height: H * 0.04),
            Container(height: H * 0.04, width: W, color: Colors.red, child: Center(child: Text('현재 나의 랭킹은 1위입니다!', style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500)))),
            Container(height: H * 0.3, width: W, child: Image.asset('assets/images/memoticon1.png')),
            Container(height: H * 0.1, width: W, child: Center(child: Text('2일 연속 운동하고 있어요!', style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500)))),



          ],)
        ),
      ),
    );
  }
}