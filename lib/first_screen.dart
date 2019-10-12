import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:logint/favoritas.dart';
import 'package:logint/home.dart';
import 'package:logint/search.dart';
import 'package:logint/info.dart';
import 'sign_in.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'entities.dart';


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
    Favoritas(),
    Points(),
  ];

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: _pageOptions[_selectedPage],
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          color: Colors.blue[400],
          backgroundColor: Colors.deepPurple[100],
          items: <Widget>[
            Icon(Icons.home, size: 25),
            Icon(Icons.search, size: 25),
            Icon(Icons.favorite, size: 25),
            Icon(Icons.info, size: 25),

          ],
          onTap: (index) {
            setState(() {
              _selectedPage = index;
            });
          },
        ),
      );
  }
}