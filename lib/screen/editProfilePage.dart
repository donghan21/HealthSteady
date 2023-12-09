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
  List<dynamic> goalSentence= [];
  dynamic statusMessage = "";
  TextEditingController _statusMessageController = TextEditingController();
  TextEditingController _goalSentenceController = TextEditingController();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _fetchInfo();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchInfo() async {
    CollectionReference users = db.collection('users');
    DocumentReference user = users.doc(FirebaseAuth.instance.currentUser!.email);
    DocumentSnapshot snapshot = await user.get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    goalSentence = data['goal_sentence'];
    statusMessage = data['status_message'];
    _statusMessageController.text = statusMessage;
    _goalSentenceController.text = goalSentence.join(' / ');
    print('_statusMessageController.text : ${_statusMessageController.text}');    
    return;
  }

  @override
  Widget build(BuildContext context) {
    W = MediaQuery.of(context).size.width;
    H = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('회원정보 수정', style: TextStyle(color: Colors.white, fontSize: 20.0)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),),
      
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.fromLTRB(W*0.03, H*0.03, W*0.03, H*0.03),
        child: SingleChildScrollView(
          child: Column( children: [   
            SizedBox(height: H * 0.04),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(height: H * 0.06, child: Text('  상태 메시지', style: TextStyle(color: Colors.white, fontSize: 20.0)))),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),border: Border.all(color: Colors.white, width: 2.0)),
              height: H * 0.1, child: TextField(
                controller: _statusMessageController,
                maxLines: 5,
                style: TextStyle(color: Colors.white, fontSize: 20.0),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '상태 메시지를 입력해주세요.',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15.0),
                  contentPadding: EdgeInsets.fromLTRB(W*0.03, H*0.03, W*0.03, H*0.03),
                ),          
              ),
              ),
            Divider(color: Colors.white, indent: W*0.03, endIndent: W*0.03),          
            SizedBox(height: H * 0.04),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(height: H * 0.06, child: Text('  운동 목표', style: TextStyle(color: Colors.white, fontSize: 20.0)))),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),border: Border.all(color: Colors.white, width: 2.0)),
              height: H * 0.2, child: TextField(
                controller: _goalSentenceController,
                maxLines: 5,
                style: TextStyle(color: Colors.white, fontSize: 20.0),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: ' 운동목표를 입력해주세요. \n / 를 통해 구분할 수 있습니다. \nex) 팔굽혀펴기 20회 하기 / 1km 뛰기',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15.0),
                  contentPadding: EdgeInsets.fromLTRB(W*0.03, H*0.03, W*0.03, H*0.03),
                ),           
               
                
              )),
            Center(
              child: InkWell(
                onTap: () async {
                  CollectionReference users = db.collection('users');
                  DocumentReference user = users.doc(FirebaseAuth.instance.currentUser!.email);  
                  List<String> _tempList = _goalSentenceController.text.split('/');
                  print('goalList before trim : $_tempList');
                  List<String> _goalList = _tempList.map((e) => e.trim()).toList();   
                  print('goalList after trim : $_goalList');                          
                  
                  
                  await user.update({
                    'status_message' : _statusMessageController.text,
                    'goal_sentence' : _goalList,                
                  });
                  Fluttertoast.showToast(
                    msg: '정보를 수정했습니다.',
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
      
      ),
    );
  }
}