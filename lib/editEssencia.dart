import 'package:flutter/material.dart';
import 'entities.dart';

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

  registerEssencia() {
    print("oi");
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
                  initialValue: essencia.sabor,
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
                  initialValue: essencia.comentario,
                  decoration: InputDecoration(labelText: "Comentário"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Por favor preencha o campo";
                    }
                    comentario = value;
                  },
                   onSaved: (value) => comentario = value,
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
            )
            ));
  }
}
