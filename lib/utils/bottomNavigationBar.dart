import 'package:flutter/material.dart';

BottomNavigationBar getBottomNavigationBar(
    BuildContext context, int currentIndex) {
  return BottomNavigationBar(
    currentIndex: currentIndex,
    onTap: (int index) {
      switch (index) {          
        case 0:
          if(currentIndex != 0)
          {Navigator.pushReplacementNamed(context, '/home');}
          break;
        case 1:
          if(currentIndex != 1) 
          {Navigator.pushReplacementNamed(context, '/rank');}
          break;
        case 2:
          if(currentIndex != 2) 
          {Navigator.pushReplacementNamed(context, '/setting');}
          break;
      }
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
  );
}
