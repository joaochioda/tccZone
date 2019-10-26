import 'package:flutter/material.dart';
import 'entities.dart';
import 'editEssencia.dart';

class DetailsEssencia extends StatefulWidget {
  final Essencia essencia;

  DetailsEssencia({Key key, @required this.essencia}) : super(key: key);

  @override
  _DetailsEssencia createState() => new _DetailsEssencia(essencia);
}

class _DetailsEssencia extends State<DetailsEssencia> {
  Essencia essencia;
  _DetailsEssencia(this.essencia);

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
              Navigator.of(context).push(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                return new EditEssencia(
                  essencia: essencia,
                );
              }));
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
                title: Text("Nome: ${essencia.nome}"),
              ),
              ListTile(
                title: Text("Marca: ${essencia.marca.marca}"),
              ),                    
              ListTile(
                title: Text("Sabor: ${essencia.sabor}"),
              ),
              ListTile(
                title: Text("Gosto: ${essencia.gosto}"),
              ),
              ListTile(
                title: Text("Proposta: ${essencia.proposta}"),
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
