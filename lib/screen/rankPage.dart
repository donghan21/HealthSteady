import 'package:flutter/material.dart';
import '../utils/index.dart';
import 'dart:math' as math;

class RankPage extends StatefulWidget {
  final List<Map<String, dynamic>> memberList;

  const RankPage({super.key, required this.memberList});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  late double H;
  late double W;

  @override
  void initState() {
    super.initState();
    widget.memberList.sort((a, b) {
      return b['workout_time']['actual'].compareTo(a['workout_time']['actual']);
    });
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
    H = MediaQuery.of(context).size.height;
    W = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '랭킹',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                height: H * 0.25,
                width: W,
                color: Colors.red,
                child: Column(
                  children: [
                    SizedBox(
                      height: H * 0.08,
                      child: const Center(
                          child: Text(
                        'RANK 1',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    SizedBox(
                        height: H * 0.17,
                        child: Image.asset(
                          'assets/images/memoticon1.png',
                          fit: BoxFit.contain,
                        )),
                  ],
                )),
            CustomPaint(
              size: Size(W,
                  (W / 5).floorToDouble()), // Change this to your desired size
              painter: SemiCirclePainter(),
              child: SizedBox(
                height: (W / 5).floorToDouble(),
                width: W,
                child: Column(
                  children: [
                    Text(
                      widget.memberList[0]['nickname'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.memberList[0]['workout_time']['actual'] ~/ 60}시간 ${widget.memberList[0]['workout_time']['actual'] % 60}분',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListView.builder(
              itemBuilder: (context, index) {
                return SizedBox(
                  height: H * 0.1,
                  width: W,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '${index + 1}',
                        style: TextStyle(
                            color: index < 3 ? Colors.white : Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                          height: H * 0.1,
                          child: Image.asset(
                            'assets/images/memoticon1.png',
                            fit: BoxFit.contain,
                          )),
                      Text(
                        widget.memberList[index]['nickname'],
                        style: TextStyle(
                            color: index < 3 ? Colors.white : Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.memberList[index]['workout_time']['actual'] ~/ 60}시간 ${widget.memberList[index]['workout_time']['actual'] % 60}분',
                        style: TextStyle(
                          fontSize: 20,
                          color: index < 3 ? Colors.white : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: widget.memberList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}

class SemiCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red; // Change this to your desired color
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(size.width / 2, 0),
          width: size.width,
          height: size.height * 2),
      0,
      math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
