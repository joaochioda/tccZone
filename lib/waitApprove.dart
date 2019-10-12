import 'package:flutter/material.dart';
import 'package:logint/api/requests.dart';
import 'package:logint/entities.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WaitApprovee extends StatefulWidget {
  WaitApprovee({Key key}) : super(key: key);

  @override
  _WaitApprovee createState() => new _WaitApprovee();
}

class _WaitApprovee extends State<WaitApprovee> {
  List<WaitApprove> waitApprove;

  getWaitApprove() async {
    if (waitApprove == null) {
      var data = await http
          .get("https://pure-scrubland-45679.herokuapp.com/waitapprove");
      var jsonData = json.decode(data.body);
      Person person;
      List<WaitApprove> waitApproves = [];
      for (var u in jsonData) {
        List<SimplePerson> people = [];

        for (var j in u["peoplePro"]) {
          SimplePerson po = SimplePerson(j["id"], j["name"], j["email"]);
          people.add(po);
        }

        List<SimplePerson> peopleA = [];

        for (var k in u["peopleAgainst"]) {
          SimplePerson po = SimplePerson(k["id"], k["name"], k["email"]);
          peopleA.add(po);
        }

        Marca marca = Marca(u["essencia"]["marca"][0]["id"],
            u["essencia"]["marca"][0]["marca"]);

        Essencia essencia = Essencia(
            u["essencia"]["id"],
            marca,
            u["essencia"]["gosto"],
            u["essencia"]["sabor"],
            u["essencia"]["comentario"],
            u["essencia"]["reputacao"],
            u["essencia"]["status"]);

        WaitApprove waitApprove = WaitApprove(u["id"], essencia, person, people,
            peopleA, u["message"], u["status"]);

        waitApproves.add(waitApprove);
      }
      if (this.mounted) {
        setState(() {
          waitApprove = waitApproves;
        });
      }
      return true;
    }
    return true;
  }

  void _showMaterialDialog(int marcaIndex) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            content: Container(
                width: 300.0,
                height: 300.0,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                          "Sabor: ${waitApprove[marcaIndex].essencia.sabor}"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                          "Gosto: ${waitApprove[marcaIndex].essencia.gosto}"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                          "Marca: ${waitApprove[marcaIndex].essencia.marca.marca}"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                          "Comentário: ${waitApprove[marcaIndex].essencia.comentario}"),
                    ),
                     RaisedButton(
                padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    color: Colors.blue,
                     onPressed: ()=> Navigator.of(context, rootNavigator: true).pop(),
                    child: new Text("Fechar"),
                     ) 
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
        title: new Text("Aprovar essências"),
      ),
      body: Container(
          child: FutureBuilder(
              future: getWaitApprove(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(child: Center(child: Text("Loading...")));
                } else {
                  return ListView.builder(
                      itemCount: waitApprove == null ? 0 : waitApprove.length,
                      itemBuilder: (BuildContext context, int marcaIndex) {
                        return Container(
                          child: ListTile(
                              title:
                                  Text(waitApprove[marcaIndex].essencia.sabor),
                              onTap: () {
                                _showMaterialDialog(marcaIndex);
                              }),
                        );
                      });
                }
              })),
    );
  }
}
