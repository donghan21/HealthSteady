import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double H;
  late double W;
  bool _signInResult = false;
  bool _isLoading = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  bool checkControllers() {
    if (_emailController.text == '' || _passwordController.text == '') {
      Fluttertoast.showToast(msg: '모든 항목을 입력해주세요.');
      return false;
    } else {
      return true;
    }
  }

  Future<bool> signIn() async {
    if (!checkControllers()) {
      return false;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: '존재하지 않는 이메일입니다.');
        return false;
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: '비밀번호가 틀렸습니다.');
        return false;
      }
      Fluttertoast.showToast(msg: '로그인에 실패했습니다.');
      debugPrint('error: $e');
      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: '로그인에 실패했습니다.');
      debugPrint('error: $e');
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: H * 0.05),
                SizedBox(
                  height: H * 0.05,
                  width: W * 0.7,
                  child: const Center(
                    child: Text(
                      '헬스테디',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: H * 0.2,
                ),
                Container(
                    height: H * 0.07,
                    width: W * 0.82,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                            height: H * 0.07,
                            width: W * 0.15,
                            child: const Center(
                                child: Icon(Icons.person, color: Colors.white))),
                        SizedBox(
                            height: H * 0.07,
                            width: W * 0.65,
                            child: TextField(
                              controller: _emailController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.grey),
                                  hintText: '  이메일', border: InputBorder.none),
                            )),
                      ],
                    ),),
                SizedBox(height: H * 0.05),
                Container(
                    height: H * 0.07,
                    width: W * 0.82,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                            height: H * 0.07,
                            width: W * 0.15,
                            child: const Center(
                                child: Icon(Icons.lock, color: Colors.white))),
                        SizedBox(
                            height: H * 0.07,
                            width: W * 0.65,
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.grey),
                                  hintText: '  비밀번호', border: InputBorder.none),
                            )),
                      ],
                    )),
                SizedBox(height: H * 0.15),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    _signInResult = await signIn();
                    setState(() {
                      _isLoading = false;
                    });
                    if (_signInResult) {
                      Navigator.pushReplacementNamed(context, '/myhome');
                    }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      minimumSize: MaterialStateProperty.all<Size>(
                          Size(W * 0.7, H * 0.07))),
                      
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          '로그인',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                ),
                SizedBox(height: H * 0.15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('계정이 없으신가요?', style: TextStyle(color: Colors.white)),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signUp');
                        },
                        child: const Text(
                          '회원가입',
                          style: TextStyle(color: Colors.red),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
