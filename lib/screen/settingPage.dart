import 'package:flutter/material.dart';
import '../utils/index.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late double W;
  late double H;


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
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.fromLTRB(W*0.03, H*0.03, W*0.03, H*0.03),
        child: Column( children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(width: W*0.25, child: Image.asset('assets/images/memoticon1.png')),
              Text(FirebaseAuth.instance.currentUser!.email.toString(), style: TextStyle(color: Colors.white, fontSize: 20.0))
            ],
          ),
          SizedBox(height: H * 0.02),
          Divider(color: Colors.white, indent: W*0.03, endIndent: W*0.03),
          SizedBox(height: H * 0.06, width: W*0.8, child: Row(children: [
            Text('회원정보 수정', style: TextStyle(color: Colors.white, fontSize: 20.0)),
            Expanded(child: Align(alignment: Alignment.centerRight,child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20.0)))
          ])),
          Divider(color: Colors.white, indent: W*0.03, endIndent: W*0.03),
          SizedBox(height: H * 0.06, width: W*0.8, child: Row(children: [
            Text('운동목표 수정', style: TextStyle(color: Colors.white, fontSize: 20.0)),
            Expanded(child: Align(alignment: Alignment.centerRight,child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20.0)))
          ])),
          Divider(color: Colors.white, indent: W*0.03, endIndent: W*0.03),
          SizedBox(height: H * 0.06, width: W*0.8, child: Row(children: [
            Text('헬스장 설정', style: TextStyle(color: Colors.white, fontSize: 20.0)),
            Expanded(child: Align(alignment: Alignment.centerRight,child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20.0)))
          ])),
          Divider(color: Colors.white, indent: W*0.03, endIndent: W*0.03),
          SizedBox(height: H * 0.06, width: W*0.8, child: Row(children: [
            Text('알람 설정', style: TextStyle(color: Colors.white, fontSize: 20.0)),
            Expanded(child: Align(alignment: Alignment.centerRight,child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20.0)))
          ])),
          Divider(color: Colors.white, indent: W*0.03, endIndent: W*0.03),
          SizedBox(height: H * 0.06, width: W*0.8, child: Row(children: [
            Text('자주묻는 질문', style: TextStyle(color: Colors.white, fontSize: 15.0)),
            Expanded(child: Align(alignment: Alignment.centerRight,child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20.0)))
          ])),
          SizedBox(height: H * 0.06, width: W*0.8, child: Row(children: [
            Text('앱 가이드', style: TextStyle(color: Colors.white, fontSize: 15.0)),
            Expanded(child: Align(alignment: Alignment.centerRight,child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20.0)))
          ])),
          SizedBox(height: H * 0.06, width: W*0.8, child: Row(children: [
            Text('앱 정보', style: TextStyle(color: Colors.white, fontSize: 15.0)),
            Expanded(child: Align(alignment: Alignment.centerRight,child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20.0)))
          ])), 
          SizedBox(height: H * 0.1),
          Row(children: [
            
            SizedBox(width: W*0.14),
            InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Container(width: W*0.24, height: H*0.05,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey),child: Center(child: Text('로그아웃', style: TextStyle(color: Colors.white, fontSize: 15.0))))),
            SizedBox(width: W*0.18),   
            Container(width: W*0.24, height: H*0.05,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red),child: Center(child: Text('회원탈퇴', style: TextStyle(color: Colors.white, fontSize: 15.0)))),
    
               ]),     
      
        ]),
      ),
      
      ),
    );
  }
}