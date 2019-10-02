import 'package:flutter/material.dart';

class Register extends StatelessWidget {
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
                  decoration: InputDecoration(
                    labelText: "Nome"
                  ),
                  validator: (value) {
                    if(value.isEmpty) {
                      return "Por favor preencha o campo";
                    }
                    return null;
                  },
                  onSaved: (value)=> name = value,
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
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  void Submit() {
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      print(name);
    }
  }
}

