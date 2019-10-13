import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logint/sign_in.dart';
import 'first_screen.dart';

class Estado {
  final int id;
  final String nome;
  Estado(this.id, this.nome);
}

class Cidade {
  final int id;
  final String nome;
  Cidade(this.id, this.nome);
}

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _Register createState() => new _Register();
}

class _Register extends State<Register> {
  List<DropdownMenuItem<Estado>> _dropdownMenuItemsEstado;
  Estado _selectedCompanyEstado;
  List<DropdownMenuItem<Cidade>> _dropdownMenuItemsCidade;
  Cidade _selectedCompanyCidade;
  bool changeCidade = true;

  @override
  void initState() {
    super.initState();
  }

  getCidade(int idI) async {
    if (changeCidade == true) {
      String id = idI.toString();
      var data = await http.get(
          "https://servicodados.ibge.gov.br/api/v1/localidades/estados/" +
              id +
              "/municipios");

      List<Cidade> users = [];
      var jsonData = json.decode(data.body);

      for (var u in jsonData) {
        Cidade user = Cidade(u["id"], u["nome"]);
        users.add(user);
      }
      users.sort((a, b) => a.nome.compareTo(b.nome));

      _dropdownMenuItemsCidade = buildDropdownMenuItemsCidade(users);
      _selectedCompanyCidade = _dropdownMenuItemsCidade[0].value;

      return true;
    } else {
      return true;
    }
  }

  getEstado() async {
    if (_dropdownMenuItemsEstado == null) {
      var data = await http
          .get("https://servicodados.ibge.gov.br/api/v1/localidades/estados");

      List<Estado> users = [];
      var jsonData = json.decode(data.body);

      for (var u in jsonData) {
        Estado user = Estado(u["id"], u["nome"]);
        users.add(user);
      }
      users.sort((a, b) => a.nome.compareTo(b.nome));

      _dropdownMenuItemsEstado = buildDropdownMenuItemsEstado(users);
      _selectedCompanyEstado = _dropdownMenuItemsEstado[0].value;
      await getCidade(_selectedCompanyEstado.id);

      return true;
    } else {
      await getCidade(_selectedCompanyEstado.id);
      return true;
    }
  }

  List<DropdownMenuItem<Estado>> buildDropdownMenuItemsEstado(List companies) {
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

  List<DropdownMenuItem<Cidade>> buildDropdownMenuItemsCidade(List companies) {
    List<DropdownMenuItem<Cidade>> items = List();

    for (Cidade company in companies) {
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text("Queretemos te conhecer"),
      ),
      body: Container(
        child: FutureBuilder(
          future: getEstado(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == "false") {
              return Container(child: Center(child: Text("Loading...")));
            } else {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: "Nome"),
                        validator: (value){
                          if (value.isEmpty) {
                            return "Por favor preencha o campo";
                          }
                          name = value;
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
                            value: _selectedCompanyEstado,
                            items: _dropdownMenuItemsEstado,
                            onChanged: onChangeDropdownItem,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
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
                          Text("Selecione a cidade onde mora"),
                          DropdownButton(
                            value: _selectedCompanyCidade,
                            items: _dropdownMenuItemsCidade,
                            onChanged: onChangeDropdownItemCidade,
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
                              onPressed: Submit,
                              child: Text("Criar conta"),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
     
    );
  }

  void Submit() {
    if (formKey.currentState.validate()) {
      createAccount();
    }
  }

  createAccount() async {
    var url = 'https://pure-scrubland-45679.herokuapp.com/person';
    Map data = {
      "name": name,
      "estado": _selectedCompanyEstado.nome,
      "cidade": _selectedCompanyCidade.nome,
      "token": token,
      "email": email,
    };

    var body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.body.toString() == "true") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return BttNav();
          },
        ),
      );
    }
  }

  onChangeDropdownItem(Estado selectedCompany) {
    setState(() {
      _selectedCompanyEstado = selectedCompany;
      changeCidade = true;
    });
  }

  onChangeDropdownItemCidade(Cidade selectedCompany) {
    setState(() {
      changeCidade = false;
      _selectedCompanyCidade = selectedCompany;
    });
  }
}
