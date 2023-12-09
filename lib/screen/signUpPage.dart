import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late double H;
  late double W;
  bool _signUpResult = false;
  bool _isLoading = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordCheckController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  bool checkControllers() {
    if (_emailController.text == '' ||
        _passwordController.text == '' ||
        _passwordCheckController.text == '' ||
        _nameController.text == '') {
      Fluttertoast.showToast(msg: '모든 항목을 입력해주세요.');
      return false;
    } else if (_passwordController.text != _passwordCheckController.text) {
      Fluttertoast.showToast(msg: '비밀번호와 비밀번호 확인이 일치하지 않습니다.');
      return false;
    } else if (_passwordController.text.length < 6) {
      Fluttertoast.showToast(msg: '비밀번호는 6자리 이상이어야 합니다.');
      return false;
    } else {
      return true;
    }
  }

  Future<bool> signUp() async {
    if (!checkControllers()) {
      return false;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      CollectionReference groups = db.collection('groups');
      CollectionReference users = db.collection('users');
      DocumentReference groupsDocumentRef = groups.doc(_emailController.text);
      DocumentReference usersDocumentRef = users.doc(_emailController.text);

      await groupsDocumentRef.set({
        'manager' : usersDocumentRef,
        'member' : [usersDocumentRef],
        'member_number' : 1,
      });
      await db.collection('users').doc(_emailController.text).set({
        'email': _emailController.text,
        'nickname': _nameController.text,
        'group' : [groupsDocumentRef],
        'workout_time' : {
          'actual' : 0,
          'goal' : 0,
        },
        'workout_number' : {
          'actual' : 0,
          'goal' : 0,
        },
        'status_message' : null,
        'gym_loc': null,
        'goal' : {
          'monday' : null,
          'tuesday': null,
          'wednesday' : null,
          'thursday' : null,
          'friday' : null,
          'saturday' : null,
          'sunday' : null,
        },
        'goal_sentence' : [],
      });

      Fluttertoast.showToast(msg: '회원가입에 성공했습니다.');
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: '비밀번호가 너무 약합니다.');
        return false;
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: '이미 사용중인 이메일입니다.');
        return false;
      } else if (e.code == 'invalid-email') {
        Fluttertoast.showToast(msg: '이메일 형식이 올바르지 않습니다.');
        return false;
      } else {
        Fluttertoast.showToast(msg: '회원가입에 실패했습니다.');
        debugPrint(e.code.toString());
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '회원가입에 실패했습니다.');
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    H = MediaQuery.of(context).size.height;
    W = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: H * 0.05),
                Text(
                  '헬스테디',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: H * 0.15),
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.white, width: 2.0))),
                  height: H * 0.09,
                  width: W * 0.8,
                  child: TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: '이메일',
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.white, width: 2.0))),
                  height: H * 0.09,
                  width: W * 0.8,
                  child: TextField(
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp('[ㄱ-ㅎㅏ-ㅣ가-힣]')),
                    ],
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '6자리 이상',
                      labelText: '비밀번호',
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.white, width: 2.0))),
                  height: H * 0.09,
                  width: W * 0.8,
                  child: TextField(
                    controller: _passwordCheckController,
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp('[ㄱ-ㅎㅏ-ㅣ가-힣]')),
                    ],
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: '비밀번호 확인',
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: H * 0.05),
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.white, width: 2.0))),
                  height: H * 0.09,
                  width: W * 0.8,
                  child: TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),                    
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: '닉네임',
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: H * 0.1),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    _signUpResult = await signUp();
                    setState(() {
                      _isLoading = false;
                    });                              
                    if (_signUpResult) {
                      Navigator.pop(context);
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      minimumSize: MaterialStateProperty.all<Size>(
                          Size(W * 0.8, H * 0.07))),
                  child: _isLoading ? CircularProgressIndicator() : Text(
                    '회원가입',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
