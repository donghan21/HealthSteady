import 'package:flutter/material.dart';
import '../utils/index.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(     
            backgroundColor: Colors.white,       
            title: Text('종료하시겠습니까?'),
            content: Text('앱을 종료하시겠습니까?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('아니오', style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('예', style: TextStyle(color: Colors.black)),
              ),
            ]
          )
        ) ?? false;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
      HomePage(
        onButtonPressed: () {
          setState(() {
            _currentIndex = 1;
          });
        }
      ),
      const WorkoutPage(),
      const SettingPage(),
      ] ,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,        
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
         items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: '내 그룹',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: '운동하기',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: '내 설정',
        ),
      ],
      selectedItemColor: Colors.red,
        ),
      ),
    );
  }
}