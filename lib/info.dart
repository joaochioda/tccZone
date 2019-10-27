import 'package:flutter/material.dart';

class Points extends StatelessWidget {
  getPoints() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Informações adicionais"),
          leading: new Container(),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                "Favoritar uma essência:",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            ListTile(
              title: Text(
                  "Basta deslizar para a esquerda/direita"),
            ),
            ListTile(
              title: Text(
                "Visualizar essências e suas marcas",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            ListTile(
              title: Text(
                  "Caso queira atualizar a lista, basta arrastar a tela para baixo"),
            ),
            ListTile(
              title: Text(
                "Aprovar/desaprovar uma essência:",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            ListTile(
              title: Text(
                  "Deslizar esquerda = reprovar \nDeslizar para direita = aprovar"),
            ),
            ListTile(
              title: Text(
                "Sistema de pontos:",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            ListTile(
              title: Text(
                  "Ao propor a criação de uma essência/edição e for aceita, o criador recebe 3 pontos e as pessoas que aceitaram recebem 1.\nPara a essência/edição serem aceitas são necessários 3 votos (criador não conta)"),
            ),
            ListTile(
              title: Text(
                "Pontos:",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            ListTile(
              title: Text(
                  "Os pontos são uma forma de incentivar os usuários a alimentar o APP, como forma de recompensá-los, no final de cada mês serão sorteados produtos com base na pontuação dos usuários"),
            ),
          ],
        )));
  }
}
