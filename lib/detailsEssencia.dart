import 'package:flutter/material.dart';
import 'search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailsEssencia extends StatefulWidget {
  final Essencia essencia;

  DetailsEssencia({Key key, @required this.essencia}) : super(key: key);

  @override
  _DetailsEssencia createState() => new _DetailsEssencia(essencia);
}

class _DetailsEssencia extends State<DetailsEssencia> {
  Essencia essencia;
  _DetailsEssencia(this.essencia);

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: new Text("Detalhes da essencia"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(8, 2, 0, 0),
        child: Container(
          child: ListView(
            children: <Widget>[                    
              ListTile(
                title: Text("Sabor: ${essencia.sabor}"),
              ),
              ListTile(
                title: Text("Gosto: ${essencia.gosto}"),
              ),
              ListTile(
                title: Text("Marca: ${essencia.marca.marca}"),
              ),
              ListTile(
                title: Text("Reputação: ${essencia.reputacao}"),
              ),
                ListTile(
                title: Text("Comentario: ${essencia.comentario}"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
