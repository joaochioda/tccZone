import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'entities.dart';
import 'home.dart';
import 'detailsEssencia.dart';

List<Essencia> essenciaG = [];
List<Message> messageG = [];

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
    List<Message> message = [];
    List<Message> messageList = [];

    for (var u in jsonData["essencias"]) {
      message = [];
      for (var j in u["message"]) {
        Message mes = Message(j["id"],j["date"], j["text"],j["nameOwner"],j["emailOwner"],j["idOwner"]);
        message.add(mes);
        messageList.add(mes);
      }


      Marca marc =
          Marca(u["marca"]["id"], u["marca"]["marca"], u["marca"]["image"]);
      Essencia essencia = Essencia(
          u["id"],
          marc,
          u["gosto"],
          u["sabor"],
          u["comentario"],
          u["reputacao"],
          u["status"],
          u["nome"],
          u["proposta"],
          u["image"],
          message);
      essenciaList.add(essencia);
    }

    if (essenciaList.length > 0 && essenciaG.length == 0 || messageList.length != messageG.length) {
      if (this.mounted) {
        setState(() {
          essenciaList.sort((a, b) => a.marca.marca
              .toString()
              .toLowerCase()
              .compareTo(b.marca.marca.toString().toLowerCase()));
          essenciaG = essenciaList;
          messageG = messageList;
        });
      }
    }
    if (essenciaG.length != essenciaList.length) {
      if (this.mounted) {
        setState(() {
          essenciaList.sort((a, b) => a.marca.marca
              .toString()
              .toLowerCase()
              .compareTo(b.marca.marca.toString().toLowerCase()));
          essenciaG = essenciaList;
        });
      }
    }

    return essenciaList;
  }

  removeEssencia(index) async {
    var url =
        'https://pure-scrubland-45679.herokuapp.com/person/$idMe/essencia/${essenciaG[index].id}';

    await http.delete(url, headers: {"Content-Type": "application/json"});

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
                if (snapshot.data != null && snapshot.data.length == 0) {
                  return Container(
                      child:
                          Center(child: Text("Nenhuma essência cadastrada")));
                }
                if (snapshot.data == null) {
                  return Container(child: Center(child: Text("Loading...")));
                } else {
                  return ListView.builder(
                      padding: const EdgeInsets.all(15.0),
                      itemCount: essenciaG.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          key: ObjectKey(essenciaG[index]),
                          child: ListTile(
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                essenciaG[index].marca.image,
                              )),
                              title: Text(essenciaG[index].nome),
                              subtitle: Text(essenciaG[index].marca.marca),
                              // onTap: () {
                              //   _showMaterialDialog(index);
                              // },
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute<Null>(
                                        builder: (BuildContext context) {
                                  return new DetailsEssencia(
                                    essencia: essenciaG[index], screen: "favorite",
                                  );
                                }));
                              }),
                          onDismissed: (direction) {
                            removeEssencia(index);
                          },
                          background: Container(
                            padding: const EdgeInsets.all(15.0),
                            child: Icon(Icons.delete),
                            color: Colors.red,
                            alignment: Alignment.centerLeft,
                          ),
                          secondaryBackground: Container(
                            padding: const EdgeInsets.all(15.0),
                            child: Icon(Icons.delete),
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                          ),
                        );
                      });
                }
              })),
     
    );
  }
}


