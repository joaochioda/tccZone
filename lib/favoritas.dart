import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'entities.dart';
import 'home.dart';
import 'detailsEssencia.dart';
import './api/getFavorite.dart';

List<Essencia> essenciaG = [];
List<Message> messageG = [];

class Favoritas extends StatefulWidget {
  Favoritas({Key key}) : super(key: key);

  @override
  _Favoritas createState() => new _Favoritas();
}

class _Favoritas extends State<Favoritas> {

  getEssencias() async {

    Favorite favorite = await getFavorite();

     if (favorite.essenciaList.length > 0 && essenciaG.length == 0 || favorite.message != messageG) {
      if (this.mounted) {
        setState(() {
          favorite.essenciaList.sort((a, b) => a.marca.marca
              .toString()
              .toLowerCase()
              .compareTo(b.marca.marca.toString().toLowerCase()));
          essenciaG = favorite.essenciaList;
          messageG = favorite.message;
        });
      }
    }
    if (essenciaG.length != favorite.essenciaList.length) {
      if (this.mounted) {
        setState(() {
          favorite.essenciaList.sort((a, b) => a.marca.marca
              .toString()
              .toLowerCase()
              .compareTo(b.marca.marca.toString().toLowerCase()));
          essenciaG = favorite.essenciaList;
        });
      }
    }

    return favorite.essenciaList;
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


