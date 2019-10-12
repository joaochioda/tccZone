import 'package:flutter/material.dart';
import 'package:logint/api/requests.dart';
import 'package:logint/entities.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'first_screen.dart';

class WaitApprovee extends StatefulWidget {
  WaitApprovee({Key key}) : super(key: key);

  @override
  _WaitApprovee createState() => new _WaitApprovee();
}

class _WaitApprovee extends State<WaitApprovee> {
  List<WaitApprove> waitApprove;
  approveDeny(id, type) async {
    String typ;
    if (type == true) {
      typ = "approve";
      var url =
          ("https://pure-scrubland-45679.herokuapp.com/waitapprove/${waitApprove[id].id}/${typ}");
      Map data = {
        "id": idMe,
      };
      var body = json.encode(data);

      await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);
    } else {
      typ = "deny";
      var url =
          ("https://pure-scrubland-45679.herokuapp.com/waitapprove/${waitApprove[id].id}/${typ}");
      Map data = {
        "person": {
          "id": idMe,
        },
        "String": "",
      };
      var body = json.encode(data);

      await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);
    }
  }

  getWaitApprove(reload) async {
    if (waitApprove == null || reload == true) {
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

        SimplePerson owner = SimplePerson(u["owner"]["id"],u["owner"]["name"],u["owner"]["email"]);
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

        WaitApprove waitApprove = WaitApprove(u["id"], essencia, owner, people,
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

  getNames(int index) {
    String result = '';
    for (var n in waitApprove[index].peoplePro) {
      result = result + n.name + "\n";
    }
    if (result == '') {
      return "Ninguém por enquanto";
    }
    return result;
  }

  void _showMaterialDialog(int marcaIndex) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            content: Container(
                width: 400,
                height: 400,
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
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                          "Criador do post: ${waitApprove[marcaIndex].owner.name}"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                          "Pessoas que já aprovaram: ${getNames(marcaIndex)}"),
                    ),
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

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: new Text("Aprovar essências"),
      ),
      body: Container(
          child: FutureBuilder(
              future: getWaitApprove(false),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(child: Center(child: Text("Loading...")));
                } else {
                  return ListView.builder(
                      padding: const EdgeInsets.all(15.0),
                      itemCount: waitApprove == null ? 0 : waitApprove.length,
                      itemBuilder: (BuildContext context, int marcaIndex) {
                        return Dismissible(
                          key: ObjectKey(waitApprove[marcaIndex]),
                          child: ListTile(
                              title:
                                  Text(waitApprove[marcaIndex].essencia.sabor),
                              onTap: () {
                                _showMaterialDialog(marcaIndex);
                              }),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.endToStart) {
                              approveDeny(marcaIndex, false);
                              getWaitApprove(true);
                              print("reprovou");
                            } else {
                              approveDeny(marcaIndex, true);
                              getWaitApprove(true);
                              print("aprovou");
                            }
                          },
                          background: slideRightBackground(),
                          secondaryBackground: slideLeftBackground(),
                        );
                      });
                }
              })),
    );
  }
}

Widget slideRightBackground() {
  return Container(
    color: Colors.green,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.thumb_up,
            color: Colors.white,
          ),
          Text(
            " Aprovar",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}

Widget slideLeftBackground() {
  return Container(
    color: Colors.red,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.thumb_down,
            color: Colors.white,
          ),
          Text(
            " Reprovar",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}
