import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:logint/home.dart';
import 'package:logint/search.dart';
import 'package:logint/points.dart';

class BttNav extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FirstScreen();
  }
}

class FirstScreen extends State<BttNav> {
  int _selectedPage =0;
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  
  final _pageOptions = [
    Home(),
    Search(),
    Points()
  ];

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: _pageOptions[_selectedPage],
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          color: Colors.blue[400],
          backgroundColor: Colors.deepPurple,
          items: <Widget>[
            Icon(Icons.home, size: 25),
            Icon(Icons.search, size: 25),
            Icon(Icons.toys, size: 25),
          ],
          onTap: (index) {
            setState(() {
              _selectedPage = index;
            });
          },
        ),
      );
    // return Scaffold(
    //   body: _pageOptions[_selectedPage],
    //   bottomNavigationBar: BottomNavigationBar(
    //       currentIndex: _selectedPage,
    //       onTap: (int index) {
    //         setState(() {
    //           _selectedPage = index;
    //         });
    //       },
        
    //       items: [
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.home),
    //           title: Text('Home'),
    //         ),
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.search),
    //           title: Text('Busca'),
    //         ),
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.score),
    //           title: Text('Pontos'),
    //         ),
    //       ],
    //     ),
    // );
  }
}