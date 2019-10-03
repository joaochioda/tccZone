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
  final _pageOptions = [
    Home(),
    Search(),
    Points()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedPage,
          onTap: (int index) {
            setState(() {
              _selectedPage = index;
            });
          },
        
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Busca'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.score),
              title: Text('Pontos'),
            ),
          ],
        ),
    );
  }
}