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
    print('I am here');
    return Scaffold(
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
    const RankPage(),
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
        icon: Icon(Icons.home),
        label: '홈',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: '랭킹',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: '설정',
      ),
    ],
    selectedItemColor: Colors.red,
      ),
    );
  }
}