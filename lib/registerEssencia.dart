import 'package:flutter/material.dart';
import 'search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'entities.dart';
import 'home.dart';

class RegisterEssencia extends StatefulWidget {
  RegisterEssencia({Key key}) : super(key: key);

  @override
  _RegisterEssencia createState() => new _RegisterEssencia();
}

class _RegisterEssencia extends State<RegisterEssencia> {
  final _formKey = GlobalKey<FormState>();
  String gosto;
  String sabor;
  String comentario;
  String nome;
  String proposta;

  List<DropdownMenuItem<Marca>> _dropdownMenuItemsEstado;
  Marca _selectedCompanyEstado;

  Submit() {
    if (_formKey.currentState.validate()) {
      registerEssencia();
      return true;
    }
  }

  registerEssencia() async {
    var url = 'https://pure-scrubland-45679.herokuapp.com/essencia';
    Map data = {
      "gosto": gosto,
      "sabor": sabor,
      "comentario": comentario,
      "nome": nome,
      "proposta": proposta,
      "marca": 
        {
          "id": _selectedCompanyEstado.id,
          "marca": _selectedCompanyEstado.marca,
        }
      
    };
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    var jsonData = json.decode(response.body);
    Marca marc =
        Marca(jsonData["marca"]["id"], jsonData["marca"]["marca"],null);
    Essencia essencia = Essencia(
        jsonData["id"],
        marc,
        jsonData["gosto"],
        jsonData["sabor"],
        jsonData["comentario"],
        jsonData["reputacao"],
        jsonData["nome"],
        jsonData["image"],
        jsonData["proposta"],
        jsonData["status"]);

    Map data1 = {
      "essencia": {
        "id": essencia.id,
        "gosto": essencia.gosto,
        "sabor": essencia.sabor,
        "comentario": essencia.comentario,
        "nome": essencia.nome,
        "proposta": essencia.proposta,
        "marca": 
          {
            "id": essencia.marca.id,
            "marca": essencia.marca.marca,
          },
        "image": null
        
      },
      "owner": {
        "id":idMe,
        }
    };

    var body1 = json.encode(data1);

    var url1 = 'https://pure-scrubland-45679.herokuapp.com/waitapprove';

    await http.post(url1,
        headers: {"Content-Type": "application/json"}, body: body1);

  }

  populateDropDown() async {
    if (_dropdownMenuItemsEstado == null) {
      _dropdownMenuItemsEstado = buildDropdownMenuItemsEstado(marcaG);
      _selectedCompanyEstado = _dropdownMenuItemsEstado[0].value;
      return true;
    }
    return true;
  }

  List<DropdownMenuItem<Marca>> buildDropdownMenuItemsEstado(List companies) {
    List<DropdownMenuItem<Marca>> items = List();

    for (Marca company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.marca),
        ),
      );
    }

    return items;
  }

  onChangeDropdownItem(Marca selectedCompany) {
    setState(() {
      _selectedCompanyEstado = selectedCompany;
    });
  }

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          title: new Text("Registrar nova essencia"),
        ),
        body: SingleChildScrollView(
            child: FutureBuilder(
                future: populateDropDown(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == "false") {
                    return Container(child: Center(child: Text("Loading...")));
                  } else {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Nome"),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Por favor preencha o campo";
                                }
                                nome = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: "Gosto"),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Por favor preencha o campo";
                                }
                                gosto = value;
                              },
                              onSaved: (value) => gosto = value,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: "Sabor"),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Por favor preencha o campo";
                                }
                                sabor = value;
                              },
                              onSaved: (value) => sabor = value,
                            ),
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Comentário"),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Por favor preencha o campo";
                                }
                                comentario = value;
                              },
                            ),
                             
                             TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Proposta"),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Por favor preencha o campo";
                                }
                                proposta = value;
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 20.0,
                                    )),
                                Text("Selecione a marca da essência"),
                                DropdownButton(
                                  value: _selectedCompanyEstado,
                                  items: _dropdownMenuItemsEstado,
                                  onChanged: onChangeDropdownItem,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton(
                                    onPressed: () {
                                      if (Submit() == true) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text("Registrar essência"),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                })));
  }
}
