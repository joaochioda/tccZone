import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'entities.dart';
import 'home.dart';

List<Essencia> essenciaG = [];

class Favoritas extends StatefulWidget {
  Favoritas({Key key}) : super(key: key);

  @override
  _Favoritas createState() => new _Favoritas();
}

class _Favoritas extends State<Favoritas> {
  getEssencias() async {
    var data = await http
        .get("https://pure-scrubland-45679.herokuapp.com/person/$idMe");
    var jsonData = json.decode(data.body);
    List<Essencia> essenciaList = [];
    for (var u in jsonData["essencias"]) {
      Marca marc = Marca(u["marca"]["id"], u["marca"]["marca"]);
      Essencia essencia = Essencia(u["id"], marc, u["gosto"], u["sabor"],
          u["comentario"], u["reputacao"], u["status"], u["nome"], u["proposta"]);
      essenciaList.add(essencia);
    }

    if (essenciaList.length > 0 && essenciaG.length == 0) {
      if (this.mounted) {
        setState(() {
          essenciaG = essenciaList;
        });
      }
    }
    if (essenciaG.length != essenciaList.length) {
      if (this.mounted) {
        setState(() {
          essenciaG = essenciaList;
        });
      }
    }

    return true;
  }

   void _showMaterialDialog(int marcaIndex) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            content: Container(
                width: 300,
                height: 400,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                          "Nome: ${essenciaG[marcaIndex].nome}"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                          "Sabor: ${essenciaG[marcaIndex].sabor}"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                          "Proposta: ${essenciaG[marcaIndex].proposta}"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                          "Gosto: ${essenciaG[marcaIndex].gosto}"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                          "Marca: ${essenciaG[marcaIndex].marca.marca}"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                          "Comentário: ${essenciaG[marcaIndex].comentario}"),
                    ),
                    SizedBox(height: 40),
                    RaisedButton(
                      padding: const EdgeInsets.all(8.0),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                      child: new Text("Fechar"),
                    )
                  ],
                )),
          );
        });
  }

  removeEssencia(index) async {
    var url = 'https://pure-scrubland-45679.herokuapp.com/person/$idMe/essencia/${essenciaG[index].id}';
   
     await http.delete(url,
        headers: {"Content-Type": "application/json"});

        await getEssencias();
  }

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          title: new Text("Essências favoritas"),
          leading: new Container(),
        ),
        body: Container(
            child: FutureBuilder(
                future: getEssencias(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(child: Center(child: Text("Loading...")));
                  } else {
                    return ListView.builder(
                        itemCount: essenciaG.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            direction: DismissDirection.endToStart,
                            key: ObjectKey(essenciaG[index]),
                            child: ListTile(
                              title: Text(essenciaG[index].nome),
                              subtitle: Text(essenciaG[index].marca.marca),
                              onTap: () {
                                _showMaterialDialog(index);
                              },
                            ),
                            onDismissed: (direction) {
                              removeEssencia(index);
                            },
                            background: Container(color: Colors.red),
                            secondaryBackground: Container(
                              child: Icon(Icons.delete),
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                            ),
                          );
                        });
                  }
                })));
  }
}
