import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../utils/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onButtonPressed;
  const HomePage({super.key, required this.onButtonPressed});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late double H;
  late double W;
  FirebaseFirestore db = FirebaseFirestore.instance;
  //late List<dynamic> groupList = [];
  late TabController _tabController;  

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() { 
      if(_tabController.previousIndex != _tabController.index) {
        print('tabcontroller index : ${_tabController.index}');
        setState(() {});
      }
    });
    //_tabController = TabController(length: 2, vsync: this);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setState(() {
    //     initGroups();
    //   });
    // });
  }

  Future<List<DocumentReference>> _fetchGroups() async {
    CollectionReference users = db.collection('users');
    DocumentSnapshot userDocument =
        await users.doc(FirebaseAuth.instance.currentUser!.email!).get();
     Map<String, dynamic> data = userDocument.data() as Map<String, dynamic>;
    List<DocumentReference> groupList = List<DocumentReference>.from(data['group']);
    //_tabController = TabController(length: groupList.length, vsync: this);
    return groupList;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _fetchMembers(DocumentReference group) async {
    // CollectionReference groups = db.collection('groups');
    // DocumentSnapshot groupDocument =
    //     await groups.doc(FirebaseAuth.instance.currentUser!.email!).get();
    // var memberList = groupDocument['member'];
    DocumentSnapshot groupDocument = await group.get();
    var data = groupDocument.data() as Map<String, dynamic>;
    List<DocumentReference> memberList = List<DocumentReference>.from(data['member']);
    print('memberlist : $memberList');

    List<Map<String, dynamic>> memberInfoList = [];
    for (var member in memberList) {
      DocumentSnapshot memberDocument = await member.get();
      print('memberdocument data : ${memberDocument.data()}');
      memberInfoList.add(memberDocument.data() as Map<String, dynamic>);
    }

    return memberInfoList;
  }

  @override
  Widget build(BuildContext context) {
    H = MediaQuery.of(context).size.height;
    W = MediaQuery.of(context).size.width;
    return FutureBuilder<List<DocumentReference>>(
        future: _fetchGroups(),
        builder: (context, groupsnapshot) {
          if (groupsnapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: W, height: H,
              color: Colors.black,
              );
          } else if (groupsnapshot.hasError) {
            return Text('Error: ${groupsnapshot.error}');
          } else {
            _tabController =
                TabController(length: groupsnapshot.data!.length, vsync: this);
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.black,
                //bottomNavigationBar: getBottomNavigationBar(context, 0),
                body: Column(children: [
                  GestureDetector(
                    onTap: () {
                      widget.onButtonPressed();
                    },
                    child: Container(
                        color: Colors.red,
                        height: H * 0.22,
                        width: W,
                        child: const  Column(
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
                  ),
                  Container(
                    height: H * 0.04,
                    width: W,
                    color: Colors.black,
                    child: TabBar(
                      indicator: BoxDecoration(),
                      controller: _tabController,
                      indicatorColor: Colors.red,
                      labelColor: Colors.red,
                      unselectedLabelColor: const Color.fromARGB(255, 73, 5, 5),
                      tabs: groupsnapshot.data!.asMap().entries
                          .map((entry) {
                            return Tab(child: Icon(Icons.circle, size: 10));
                          })
                          .toList(),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: groupsnapshot.data!
                          .map(
                            (group) => FutureBuilder(
                                future: _fetchMembers(group),
                                builder: (context, membersnapshot) {
                                  if (membersnapshot.hasData) {
                                    print('index : ${_tabController.index}');
                                    return Column(
                                      children: [
                                        GridView.builder(
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    childAspectRatio: 2 /
                                                        3 // Number of items in a row
                                                    ),
                                            shrinkWrap: true,
                                            itemCount: membersnapshot.data!.length,
                                            itemBuilder: (context, index) {
                                              int actualMinutes =
                                                  membersnapshot.data![index]
                                                      ['workout_time']['actual'];
                                              int goalMinutes =
                                                  membersnapshot.data![index]
                                                      ['workout_time']['goal'];
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
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.black,
                                                              border: Border.all(
                                                                  color:
                                                                      Colors.white,
                                                                  width: 2),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(10),
                                                            ),
                                                            child:
                                                                Column(children: [
                                                              SizedBox(
                                                                  height: H * 0.01),
                                                              SizedBox(
                                                                  height: H * 0.05,
                                                                  child: Text(
                                                                    membersnapshot.data![
                                                                            index][
                                                                        'nickname'],
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold),
                                                                  )),
                                                              Container(
                                                                height: H * 0.15,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image: Image.asset(
                                                                            'assets/images/memoticon1.png')
                                                                        .image,
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: H * 0.05),
                                                              SizedBox(
                                                                height: H * 0.04,
                                                                child: Text(
                                                                  '이번주 운동 횟수 ${membersnapshot.data![index]['workout_number']['actual']}회 (목표 ${membersnapshot.data![index]['workout_number']['goal']}회)',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 15,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: H * 0.04,
                                                                child: Text(
                                                                  '이번주 운동 시간 ${actualMinutes ~/ 60}:${actualMinutes % 60} (목표 ${goalMinutes ~/ 60}:${(goalMinutes % 60).toString().padLeft(2, '0')})',
                                                                  style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 15,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: H * 0.04,
                                                                child: membersnapshot.data![index]['status_message'] != null ? Text(
                                                                  '상태 메시지 : ${membersnapshot.data![index]['status_message']}',
                                                                  style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 15,
                                                                  ),
                                                                ) : Text('상태 메시지가 없습니다', style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 15,
                                                                )),
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
                                                      membersnapshot.data![index]
                                                          ['nickname'],
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                        '${actualMinutes ~/ 60}h ${(actualMinutes % 60).toString().padLeft(2, '0')}m',
                                                        style:  TextStyle(
                                                            color: Colors.white))
                                                  ],
                                                ),
                                              );
                                            }),
                                            SizedBox(height: H*0.03),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => RankPage(memberList : membersnapshot.data!)));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.white, width: 2.0),
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.black,
                                          ),
                                          height: H * 0.07,
                                          width: W * 0.42,
                                        
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: W * 0.1,
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.star_border,
                                                    color: Colors.white,
                                                    size: 40,
                                                  ),
                                                ),),
                                              SizedBox(
                                                width: W * 0.3,
                                                child: Center(child: Text('랭킹 보기', style: TextStyle(color: Colors.white, fontSize: 20.0),)),),
                                              
                                              
                                            ],
                                          ),
                                        ),
                                      )
                                      ],
                                    );
                                  } else {
                                    return Container(
                                      color: Colors.black,
                                      child: const Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  }
                                }),
                          )
                          .toList(),

                      // child: FutureBuilder(
                      //     future: _fetchMembers(),
                      //     builder: (context, snapshot) {
                      //       if (snapshot.hasData) {
                      //         return GridView.builder(
                      //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      //                 crossAxisCount: 3,
                      //                 childAspectRatio: 2 / 3 // Number of items in a row
                      //                 ),
                      //             shrinkWrap: true,
                      //             itemCount: snapshot.data!.length,
                      //             itemBuilder: (context, index) {
                      //               int actualMinutes =
                      //                   snapshot.data![index]['workout_time']['actual'];
                      //               int goalMinutes =
                      //                   snapshot.data![index]['workout_time']['goal'];
                      //               return GestureDetector(
                      //                 onTap: () {
                      //                   showDialog(
                      //                       context: context,
                      //                       builder: (context) {
                      //                         // return AlertDialog(
                      //                         //   title: Text(snapshot.data![index]['nickname']),
                      //                         //   content: Text('운동시간: ${minutes ~/ 60}h ${minutes % 60}m'),
                      //                         //   actions: [
                      //                         //     TextButton(onPressed: () {
                      //                         //       Navigator.pop(context);
                      //                         //     }, child: Text('확인'))
                      //                         //   ],
                      //                         // );
                      //                         return Dialog(
                      //                           child: Container(
                      //                             height: H * 0.5,
                      //                             width: W * 0.8,
                      //                             decoration: BoxDecoration(
                      //                               color: Colors.black,
                      //                               border: Border.all(
                      //                                   color: Colors.white, width: 2),
                      //                               borderRadius:
                      //                                   BorderRadius.circular(10),
                      //                             ),
                      //                             child: Column(children: [
                      //                               SizedBox(height: H * 0.01),
                      //                               SizedBox(
                      //                                   height: H * 0.05,
                      //                                   child: Text(
                      //                                     snapshot.data![index]
                      //                                         ['nickname'],
                      //                                     style: const TextStyle(
                      //                                         color: Colors.white,
                      //                                         fontSize: 20,
                      //                                         fontWeight:
                      //                                             FontWeight.bold),
                      //                                   )),
                      //                               Container(
                      //                                 height: H * 0.15,
                      //                                 decoration: BoxDecoration(
                      //                                   image: DecorationImage(
                      //                                     image: Image.asset(
                      //                                             'assets/images/memoticon1.png')
                      //                                         .image,
                      //                                     fit: BoxFit.contain,
                      //                                   ),
                      //                                 ),
                      //                               ),
                      //                               SizedBox(height: H * 0.05),
                      //                               SizedBox(
                      //                                 height: H * 0.04,
                      //                                 child: Text(
                      //                                   '이번주 운동 횟수 ${snapshot.data![index]['workout_number']['actual']}회 (목표 ${snapshot.data![index]['workout_number']['goal']}회)',
                      //                                   style: const TextStyle(
                      //                                     color: Colors.white,
                      //                                     fontSize: 15,
                      //                                   ),
                      //                                 ),
                      //                               ),
                      //                               SizedBox(
                      //                                 height: H * 0.04,
                      //                                 child: Text(
                      //                                   '이번주 운동 시간 ${actualMinutes ~/ 60}:${actualMinutes % 60} (목표 ${goalMinutes ~/ 60}:${(goalMinutes % 60).toString().padLeft(2, '0')})',
                      //                                   style: TextStyle(
                      //                                     color: Colors.white,
                      //                                     fontSize: 15,
                      //                                   ),
                      //                                 ),
                      //                               ),
                      //                               SizedBox(
                      //                                 height: H * 0.04,
                      //                                 child: Text(
                      //                                   '상태 메시지 : ${snapshot.data![index]['status_message']}',
                      //                                   style: TextStyle(
                      //                                     color: Colors.white,
                      //                                     fontSize: 15,
                      //                                   ),
                      //                                 ),
                      //                               )
                      //                             ]),
                      //                           ),
                      //                         );
                      //                       });
                      //                 },
                      //                 child: Column(
                      //                   children: [
                      //                     Container(
                      //                       height: H * 0.15,
                      //                       decoration: BoxDecoration(
                      //                         image: DecorationImage(
                      //                           image: Image.asset(
                      //                                   'assets/images/memoticon1.png')
                      //                               .image,
                      //                           fit: BoxFit.contain,
                      //                         ),
                      //                       ),
                      //                     ),
                      //                     Text(
                      //                       snapshot.data![index]['nickname'],
                      //                       style: TextStyle(
                      //                           color: Colors.white,
                      //                           fontSize: 15,
                      //                           fontWeight: FontWeight.bold),
                      //                     ),
                      //                     Text(
                      //                         '${actualMinutes ~/ 60}h ${(actualMinutes % 60).toString().padLeft(2, '0')}m',
                      //                         style: TextStyle(color: Colors.white))
                      //                   ],
                      //                 ),
                      //               );
                      //             });
                      //       } else {
                      //         return const Center(child: CircularProgressIndicator());
                      //       }
                      //     }),
                    ),
                  )
                ]),
                floatingActionButton: FloatingActionButton(
                  child: const Icon(Icons.group_add, color: Colors.white,),
                  heroTag : _tabController.index,
                  backgroundColor: Colors.red,
                  onPressed: () {
                    if(_tabController.index == 0) {
                    Navigator.pushNamed(context, '/invite');
                    } else {
                   
                    Fluttertoast.showToast(
                        msg: "그룹장만 초대할 수 있습니다.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    }
                  },
                ),
              ),
            );
          }
        });
  }
}
