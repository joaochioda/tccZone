import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MySearchPage(title: 'Buscar essência'),
    );
  }
}

class MySearchPage extends StatefulWidget {
  MySearchPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MySearchPageState createState() => new _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  List<Essencia> essenciaG = [];

   _getUsers() async {
    if (essenciaG.isEmpty) {
      var data =
          await http.get("https://pure-scrubland-45679.herokuapp.com/essencia");

      var jsonData = json.decode(data.body);

      List<Essencia> users = [];

      for (var u in jsonData) {
        Marca marc = Marca(u["marca"][0]["id"], u["marca"][0]["marca"]);

        Essencia user = Essencia(u["id"], marc, u["gosto"], u["sabor"],
            u["comentario"], u["reputacao"]);

        users.add(user);
      }
      if(this.mounted){
      setState(() {
        essenciaG = users;
      });
      }
      return true;
    }
    return true;
  }

  static final List<String> _listViewData = [
    "sabado",
    "cachorro",
    "salame",
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Lista de essências")),
        body: Container(
            child: FutureBuilder(
                future: _getUsers(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(child: Center(child: Text("Loading...")));
                  } else {
                    return ListView.builder(
                        itemCount: _listViewData == null ? 0 : 3,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              child: ExpansionTile(
                            title: ListTile(
                              title: Text(_listViewData[index]),
                            ),
                            children: <Widget>[
                              ListView.builder(
                                itemBuilder: (context, index) {
                                  return Container(
                                      child: ListTile(
                                    title: Text("oi"),
                                    onTap: () => print("oi"),
                                  ));
                                },
                                itemCount: 9,
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                              )
                            ],
                          ));
                        });
                  }
                })));
    // return new Scaffold(
    //   appBar: new AppBar(
    //     title: new Text(widget.title),
    //   ),
    //   body: Container(
    //       child: FutureBuilder(
    //         future: _getUsers(),
    //         builder: (BuildContext context, AsyncSnapshot snapshot){
    //           if(snapshot.data == null){
    //             return Container(
    //               child: Center(
    //                 child: Text("Loading...")
    //               )
    //             );
    //           } else {
    //             return ListView.builder(
    //               itemCount: snapshot.data.length,
    //               itemBuilder: (BuildContext context, int index) {
    //                 return ListTile(
    //                   leading: CircleAvatar(
    //                   ),
    //                   title: Text(snapshot.data[index].marca),
    //                   subtitle: Text(snapshot.data[index].gosto),

    //                 );
    //               },
    //             );
    //           }
    //         },
    //       ),
    //     ),
    //   );
  }
}

class Essencia {
  final int id;
  final String gosto;
  final String sabor;
  final Marca marca;
  final String comentario;
  final int reputacao;

  Essencia(this.id, this.marca, this.gosto, this.sabor, this.comentario,
      this.reputacao);
}

class Marca {
  final int id;
  final String marca;

  Marca(this.id, this.marca);
}
