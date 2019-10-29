import 'package:flutter/material.dart';
import 'entities.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';
import 'package:toast/toast.dart';

class EditEssencia extends StatefulWidget {
  final Essencia essencia;

  EditEssencia({Key key, @required this.essencia}) : super(key: key);

  @override
  _EditEssenciaState createState() => new _EditEssenciaState(essencia);
}

class _EditEssenciaState extends State<EditEssencia> {
  final _formKey = GlobalKey<FormState>();
  String gosto;
  String sabor;
  String comentario;
  String nome;
  String proposta;

  Essencia essencia;
  _EditEssenciaState(this.essencia);

  Submit() {
    if (_formKey.currentState.validate()) {
       registerEssencia();
      return true;
    }
  }

  registerEssencia() async {
    var url = 'https://pure-scrubland-45679.herokuapp.com/editapprove';
    Map data = {
      "essenciaAntiga": {"id": essencia.id},
      "essenciaNova": {
        "gosto": gosto,
        "sabor": sabor,
        "comentario": comentario,
        "nome": nome,
        "proposta": proposta,
        "marca": {
          "id": essencia.marca.id,
          "marca": essencia.marca.marca,
        }
      },
      "owner": {
        "id": idMe,
      }
    };

    var body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    
    // if(response.statusCode == 200) {
    //   Toast.show("Toast plugin app", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          title: new Text("Editar essência"),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: essencia.nome,
                    decoration: InputDecoration(labelText: "Nome"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Por favor preencha o campo";
                      }
                      nome = value;
                    },
                    onSaved: (value) => nome = value,
                  ),
                  TextFormField(
                    initialValue: essencia.gosto,
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
                    initialValue: essencia.proposta,
                    decoration: InputDecoration(labelText: "Proposta"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Por favor preencha o campo";
                      }
                      proposta = value;
                    },
                    onSaved: (value) => proposta = value,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: () {
                            if (Submit() == true) {
                               Navigator.pop(context, "Edição criada ! Esperando aprovação dos membros");
                            }
                          },
                          child: Text("Propor edição da essência"),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )));
  }


}
