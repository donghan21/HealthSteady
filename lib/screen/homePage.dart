import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../utils/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late double H;
  late double W;
  FirebaseFirestore db = FirebaseFirestore.instance;

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

  Future<List<dynamic>> _fetchMembers() async {
    CollectionReference groups = db.collection('groups');
    DocumentSnapshot groupDocument =
        await groups.doc(FirebaseAuth.instance.currentUser!.email!).get();
    var memberList = groupDocument['member'];

    List<dynamic> memberInfoList = [];
    for (var member in memberList) {
      DocumentSnapshot memberDocument = await member.get();
      memberInfoList.add(memberDocument.data());
    }

    return memberInfoList;
  }

  @override
  Widget build(BuildContext context) {
    H = MediaQuery.of(context).size.height;
    W = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: getBottomNavigationBar(context, 0),
        body: Column(children: [
          Container(
              color: Colors.red,
              height: H * 0.22,
              width: W,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'START',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'WORKOUT',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'NOW',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          Expanded(
            child: FutureBuilder(
                future: _fetchMembers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 2 / 3 // Number of items in a row
                            ),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          int actualMinutes =
                              snapshot.data![index]['workout_time']['actual'];
                          int goalMinutes =
                              snapshot.data![index]['workout_time']['goal'];
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    // return AlertDialog(
                                    //   title: Text(snapshot.data![index]['nickname']),
                                    //   content: Text('운동시간: ${minutes ~/ 60}h ${minutes % 60}m'),
                                    //   actions: [
                                    //     TextButton(onPressed: () {
                                    //       Navigator.pop(context);
                                    //     }, child: Text('확인'))
                                    //   ],
                                    // );
                                    return Dialog(
                                      child: Container(
                                        height: H * 0.5,
                                        width: W * 0.8,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(children: [
                                          SizedBox(height: H * 0.01),
                                          SizedBox(
                                              height: H * 0.05,
                                              child: Text(
                                                snapshot.data![index]
                                                    ['nickname'],
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Container(
                                            height: H * 0.15,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: Image.asset(
                                                        'assets/images/memoticon1.png')
                                                    .image,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: H * 0.05),
                                          SizedBox(
                                            height: H * 0.04,
                                            child: Text(
                                              '이번주 운동 횟수 ${snapshot.data![index]['workout_number']['actual']}회 (목표 ${snapshot.data![index]['workout_number']['goal']}회)',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: H * 0.04,
                                            child: Text(
                                              '이번주 운동 시간 ${actualMinutes ~/ 60}:${actualMinutes % 60} (목표 ${goalMinutes ~/ 60}:${(goalMinutes % 60).toString().padLeft(2, '0')})',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: H * 0.04,
                                            child: Text(
                                              '상태 메시지 : ${snapshot.data![index]['status_message']}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          )
                                        ]),
                                      ),
                                    );
                                  });
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: H * 0.15,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: Image.asset(
                                              'assets/images/memoticon1.png')
                                          .image,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Text(
                                  snapshot.data![index]['nickname'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    '${actualMinutes ~/ 60}h ${(actualMinutes % 60).toString().padLeft(2, '0')}m',
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                          );
                        });
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          )
        ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            Navigator.pushNamed(context, '/invite');
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
