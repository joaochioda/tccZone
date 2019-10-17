import 'package:flutter/material.dart';
import 'package:logint/entities.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'home.dart';

class WaitApprovee extends StatefulWidget {
  WaitApprovee({Key key}) : super(key: key);

  @override
  _WaitApprovee createState() => new _WaitApprovee();
}

class _WaitApprovee extends State<WaitApprovee> {
  List<WaitApprove> waitApprove;
  int countApprove;
  int countAgainst;
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
      int peoplePro;
      int peopleAgainst;
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

        SimplePerson owner = SimplePerson(
            u["owner"]["id"], u["owner"]["name"], u["owner"]["email"]);
        Marca marca = Marca(u["essencia"]["marca"][0]["id"],
            u["essencia"]["marca"][0]["marca"]);

        Essencia essencia = Essencia(
          u["essencia"]["id"],
          marca,
          u["essencia"]["gosto"],
          u["essencia"]["sabor"],
          u["essencia"]["comentario"],
          u["essencia"]["reputacao"],
          u["essencia"]["status"],
          u["essencia"]["nome"],
          u["essencia"]["proposta"],
        );

        WaitApprove waitApprove = WaitApprove(u["id"], essencia, owner, people,
            peopleA, u["message"], u["status"]);

        waitApproves.add(waitApprove);
        peoplePro = people.length;
        peopleAgainst = peopleA.length;
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
      result = result + n.name + "| ";
    }
    if (result == '') {
      return "Ninguém por enquanto";
    }
    return result;
  }

  getVoted(String type,int index) {
    if (type == "up") {
      return waitApprove[index].peoplePro.length.toString();
    }
    else {
      return waitApprove[index].peopleAgainst.length.toString();
    }
  }

  void _showMaterialDialog(int marcaIndex) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            content: Container(
                width: 400,
                height: 500,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                          "Nome: ${waitApprove[marcaIndex].essencia.nome}"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                          "Sabor: ${waitApprove[marcaIndex].essencia.sabor}"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                          "Proposta: ${waitApprove[marcaIndex].essencia.proposta}"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                          "Gosto: ${waitApprove[marcaIndex].essencia.gosto}"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                          "Marca: ${waitApprove[marcaIndex].essencia.marca.marca}"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                          "Comentário: ${waitApprove[marcaIndex].essencia.comentario}"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                          "Criador do post: ${waitApprove[marcaIndex].owner.name}"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                          "Pessoas que já aprovaram: ${getNames(marcaIndex)}"),
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
                          child: Row(children: <Widget>[
                            Flexible(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(getVoted("up", marcaIndex)),
                            )),
                            Flexible(
                              child: IconButton(
                                icon: Icon(Icons.thumb_up, color: Colors.green),
                                onPressed: () {
                                  approveDeny(marcaIndex, true);
                                  getWaitApprove(true);
                                },
                              ),
                            ),
                            Expanded(flex:5,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: ListTile(
                                  title: Text(
                                      waitApprove[marcaIndex].essencia.nome,
                                       textAlign: TextAlign.center,),
                                  onTap: () {
                                    _showMaterialDialog(marcaIndex);
                                  }),
                              )
                            ),
                            Flexible(
                              child: IconButton(
                                icon: Icon(Icons.thumb_down, color: Colors.red),
                                onPressed: () {
                                  approveDeny(marcaIndex, false);
                                  getWaitApprove(true);
                                },
                              ),
                            ),
                            Flexible(child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(getVoted("down",marcaIndex)),
                            )),
                          ]),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.endToStart) {
                              approveDeny(marcaIndex, false);
                              getWaitApprove(true);
                            } else {
                              approveDeny(marcaIndex, true);
                              getWaitApprove(true);
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
