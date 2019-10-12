import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:logint/home.dart';
import 'package:logint/search.dart';
import 'package:logint/points.dart';
import 'sign_in.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'entities.dart';
String idMe;

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

getMe() async {
  if(idMe == null){
    var url = 'https://pure-scrubland-45679.herokuapp.com/me';
    Map data = {"token": token, "email": email};

    var body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    idMe = response.body;

    setState(() {
      idMe = response.body;
    });
    return response.body;
  }
  }

  @override
  Widget build(BuildContext context) {
    getMe();
      return Scaffold(
        body: _pageOptions[_selectedPage],
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          color: Colors.blue[400],
          backgroundColor: Colors.deepPurple[100],
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
  }
}