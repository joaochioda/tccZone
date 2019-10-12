import 'package:flutter/material.dart';


class Favoritas extends StatefulWidget {
  Favoritas({Key key}) : super(key: key);

  @override
  _Favoritas createState() => new _Favoritas();
}


class _Favoritas extends State<Favoritas> {

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: new Text("Essências favoritas"),
        leading: new Container(),
      ),
      body: Container()
    );
  }
}