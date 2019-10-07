import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detailsEssencia.dart';
import 'registerEssencia.dart';


  String sabor;
  String gosto;
  String comentario;

  List<Essencia> essenciaG = [];
  List<Marca> marcaG = [];

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


Future<Null> refreshPage() async {
  _getUsers(true);
}

void _showModalSheet(int j, int l) {
  Essencia essencia = getTapped(j, l);
    showModalBottomSheet(context: context, builder: (builder) {
      return Container(
        padding: EdgeInsets.all(40.0),
        child: ListTile(
        title: Text('Clique aqui \nPara ver mais detalhes da "${essencia.gosto}"'),
        onTap:  () {
          
          Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return new DetailsEssencia(essencia: essencia,);
            }));
        },
        )
      );
    });
}

  _getUsers(refresh) async {
    if (essenciaG.isEmpty || refresh==true) {
      var data =
          await http.get("https://pure-scrubland-45679.herokuapp.com/essencia");

      var data1 =
          await http.get("https://pure-scrubland-45679.herokuapp.com/marca");
      var jsonData = json.decode(data.body);
      var jsonData1 = json.decode(data1.body);

      List<Essencia> users = [];
      List<Marca> marca = [];

      for (var u in jsonData) {
        Marca marc = Marca(u["marca"][0]["id"], u["marca"][0]["marca"]);

        Essencia user = Essencia(u["id"], marc, u["gosto"], u["sabor"],
            u["comentario"], u["reputacao"]);

        users.add(user);
      }

      for (var u in jsonData1) {
        Marca marc = Marca(u["id"], u["marca"]);
        marca.add(marc);
      }
      if (this.mounted) {
        setState(() {
          essenciaG = users;
          marcaG = marca;
        });
      }
      return true;
    }
    return true;
  }

  getEssencia(int j, int l) {
    List<Essencia> ess = [];
    for (int i = 0; i < essenciaG.length; i++) {
      if (essenciaG[i].marca.id == marcaG[j].id) {
        ess.add(essenciaG[i]);
      }
    }
    return ess[l].sabor;
  }

  getWidth(int k) {
    int contador = 0;
    for (int i = 0; i < essenciaG.length; i++) {
      if (essenciaG[i].marca.id == marcaG[k].id) {
        contador++;
      }
    }
    return contador;
  }

  getTapped(int j, int l) {
    List<Essencia> ess = [];

    for (int i = 0; i < essenciaG.length; i++) {
      if (essenciaG[i].marca.id == marcaG[j].id) {
        ess.add(essenciaG[i]);
      }
    }

  return ess[l];
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(title: new Text("Lista de essências")),
      body: new RefreshIndicator(
        onRefresh: refreshPage,
     child: new  Container(
          child: FutureBuilder(
              future: _getUsers(false),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(child: Center(child: Text("Loading...")));
                } else {
                  return ListView.builder(
                      itemCount: marcaG == null ? 0 : marcaG.length,
                      itemBuilder: (BuildContext context, int marcaIndex) {
                        return Container(
                          
                          
                            child: ExpansionTile(
                          title: ListTile(
                            title: Text(marcaG[marcaIndex].marca),
                          ),
                          children: <Widget>[
                            ListView.builder(
                              itemBuilder: (context, index) {
                                return Container(
                                    child: ListTile(
                                  title: Text(getEssencia(marcaIndex, index)),
                                  onTap: () => _showModalSheet(marcaIndex, index),
                                ));
                              },
                              itemCount: getWidth(marcaIndex),
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                            )
                          ],
                        ));
                        
                      });
                }
              }))),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return new RegisterEssencia();
            }));
        },
        backgroundColor: Colors.deepPurple,
      ),
    );
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
