import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({super.key});

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  late double H;
  late double W;
  TextEditingController _searchController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

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

  Future<List<dynamic>> _fetchUsers() async {
    var userList = [];
    var users = await db.collection('users').get();
    for (var user in users.docs) {
      userList.add(user.data());
    }
    print ('userList : $userList');
    return userList;
  }

  Future<void> _sendInvitation(String invitedEmail, String inviterEmail) async {
    CollectionReference groups = db.collection('groups');
    DocumentReference group = groups.doc(inviterEmail);

    CollectionReference users = db.collection('users');
    DocumentReference inviter = users.doc(inviterEmail);
    DocumentReference invited = users.doc(invitedEmail);

    print('group : $group, inviter : $inviter, invited : $invited');

    await db.collection('invitation').doc(inviterEmail).set({
      'group': group,
      'inviter': inviter,
      'invited': invited,
    });

    Fluttertoast.showToast(
      msg: '초대장을 보냈습니다.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    H = MediaQuery.of(context).size.height;
    W = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Container(
              height: H * 0.15,
              width: W,
              color: Colors.red,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'FIND',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'YOUR BUDDY',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              height: H * 0.1,
              width: W,
              color: Colors.white,
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: W * 0.02, right: W * 0.02),
                      child: const Icon(
                        Icons.search,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '계정 검색 (이메일 또는 닉네임)',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: FutureBuilder(future: _fetchUsers(), builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data![index]['email'], style: TextStyle(color: Colors.white)),
                          subtitle: Text(snapshot.data![index]['nickname'], style: TextStyle(color: Colors.white)),
                          trailing: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                            ),                          
                            onPressed: () {_sendInvitation(snapshot.data![index]['email'], currentUserEmail);},
                            child: const Text('초대하기', style: TextStyle(color: Colors.white),),
                          ),
                        );
                      });
                } else {
                  return Container(color: Colors.black, child: const Center(child: CircularProgressIndicator()));
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
