import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Estado {
  final int id;
  final String nome;
  Estado(this.id, this.nome);
}

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _Register createState() => new _Register();
}

class _Register extends State<Register> {
  List<Estado> _companies;
  List<DropdownMenuItem<Estado>> _dropdownMenuItems;
  Estado _selectedCompany;

  @override
  void initState() {
    getEstado().then((val) {
      _dropdownMenuItems = buildDropdownMenuItems(val);
      _selectedCompany = _dropdownMenuItems[0].value;
    });
    super.initState();
  }

  Future<List<Estado>> getEstado() async {
    var data = await http
        .get("https://servicodados.ibge.gov.br/api/v1/localidades/estados");

    List<Estado> users = [];
    var jsonData = json.decode(data.body);

    for (var u in jsonData) {
      Estado user = Estado(u["id"], u["nome"]);
      users.add(user);
    }
    return users;
  }

  List<DropdownMenuItem<Estado>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Estado>> items = List();

    for (Estado company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.nome),
        ),
      );
    }

    return items;
  }

  final formKey = GlobalKey<FormState>();
  String name;
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Queremos te conhecer"),
      ),
      body: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: "Nome"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Por favor preencha o campo";
                    }
                    return null;
                  },
                  onSaved: (value) => name = value,
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
                    Text("Selecione o estado onde mora"),
                    DropdownButton(
                      value: _selectedCompany,
                      items: _dropdownMenuItems,
                      onChanged: onChangeDropdownItem,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text('Selecionado: ${_selectedCompany.nome}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: Submit,
                        child: Text("Criar conta"),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void Submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      print(name);
    }
  }

  onChangeDropdownItem(Estado selectedCompany) {
    print(selectedCompany.id);
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }
}
