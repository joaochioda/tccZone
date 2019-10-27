import 'package:flutter/material.dart';
import 'package:logint/home.dart';
import 'entities.dart';
import 'editEssencia.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailsEssencia extends StatefulWidget {
  final Essencia essencia;
  final String screen;
  DetailsEssencia({Key key, @required this.essencia, @required this.screen}) : super(key: key);

  @override
  _DetailsEssencia createState() => new _DetailsEssencia(essencia,screen);
}

class _DetailsEssencia extends State<DetailsEssencia> {
  Essencia essencia;
  String screen;
  _DetailsEssencia(this.essencia,this.screen);
  String text;
  final _formKey = GlobalKey<FormState>();

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditEssencia(
                essencia: essencia,
              )),
    );

    if (result != null) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text("$result")));
    }
  }
 Submit() {
    if (_formKey.currentState.validate()) {
       registerComentario();
      return true;
    }
  }

registerComentario() async{
var url = 'https://pure-scrubland-45679.herokuapp.com/essencia/${essencia.id}/message';
Map data = {
  
    "idOwner": idMe,
  
  "text": text,
};
var body = json.encode(data);
await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
}
  void _showMaterialDialog(int marcaIndex) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            content: Container(
                width: 100,
                height: 300,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                decoration:
                                    InputDecoration(labelText: "Comentário"),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Por favor preencha o campo";
                                  }
                                  text = value;
                                },
                              ),
                            ],
                          ),
                        )),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            onPressed: () {
                              if (Submit() == true && screen == "favorite") {
                                Navigator.pop(context);
                              } 
                              else if(Submit() == true && screen == "search") {
                                 Navigator.of(context, rootNavigator: true).pop();
                              
                              }
                            },
                            child: Text("Salvar"),
                          ),
                        ),
                        RaisedButton(
                          padding: const EdgeInsets.all(12.0),
                          textColor: Colors.white,
                          color: Colors.blue,
                          onPressed: () =>
                              Navigator.of(context, rootNavigator: true).pop(),
                          child: new Text("Fechar"),
                        )
                      ],
                    ),
                  ],
                )),
          );
        });
  }

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: new Text("Detalhes da essencia"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _navigateAndDisplaySelection(context);
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(8, 2, 0, 0),
        child: Container(
          child: ListView(
            children: <Widget>[
              ListTile(
                title:
                    Text("Nome: ${essencia.nome != null ? essencia.nome : ''}"),
              ),
              ListTile(
                title: Text(
                    "Marca: ${essencia.marca.marca != null ? essencia.marca.marca : ''}"),
              ),
              ListTile(
                title: Text(
                    "Sabor: ${essencia.sabor != null ? essencia.sabor : ''}"),
              ),
              ListTile(
                title: Text(
                    "Gosto: ${essencia.gosto != null ? essencia.gosto : ''}"),
              ),
              ListTile(
                title: Text(
                    "Proposta: ${essencia.proposta != null ? essencia.proposta : ''}"),
              ),
              ListTile(
                title: Text(
                    "Reputação: ${essencia.reputacao != null ? essencia.reputacao : ''}"),
              ),
              ListTile(
                title: Text(
                    "Comentario: ${essencia.comentario != null ? essencia.comentario : ''}"),
              ),
              ListTile(
                title: Text("Comentários da comunidade: "),
              ),
              ListView.builder(
                itemCount: essencia.message.length == null
                    ? 0
                    : essencia.message.length,
                itemBuilder: (BuildContext context, int marcaIndex) {
                  return Container(
                    child: ListTile(
                        title: Text(
                            "${essencia.message[marcaIndex].nameOwner} - ${essencia.message[marcaIndex].date} \n=> ${essencia.message[marcaIndex].text}")),
                  );
                },
                shrinkWrap: true,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showMaterialDialog(1);
        },
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
