import 'package:flutter/material.dart';
import 'package:logint/entities.dart';
import 'package:logint/login_page.dart';
import 'package:logint/sign_in.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

int pontos;
int idMe;
String nameUser;
class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Home createState() => new _Home();
}

class _Home extends State<Home> {
  getPoints() async {
    if (idMe == null) {
      await getMe();
    }
    var data = await http.get(
        'https://pure-scrubland-45679.herokuapp.com/person/$idMe/pontos');
    var jsonData = json.decode(data.body);
    if (this.mounted) {
      if (pontos == jsonData) {
      } else {
        setState(() {
          pontos = jsonData;
        });
      }
      return true;
    }
  }

  getMe() async {
    if (idMe == null) {
      var url = 'https://pure-scrubland-45679.herokuapp.com/me';
      Map data = {"token": token, "email": email};

      var body = json.encode(data);
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);

      var jsonData = json.decode(response.body);
      IdNamePerson pe = IdNamePerson(jsonData["id"],jsonData["name"]);
      print(pe.name);
      print(pe.id);

      if (idMe != pe.id) {
        setState(() {
          idMe = pe.id;
          nameUser = pe.name;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: FutureBuilder(
              future: getPoints(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(child: Center(child: Text("Loading...")));
                } else {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.blue[100], Colors.blue[400]],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              imageUrl,
                            ),
                            radius: 60,
                            backgroundColor: Colors.transparent,
                          ),
                          SizedBox(height: 40),
                          Text(
                            'NAME:',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          Text(
                            nameUser,
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 40),
                          // SizedBox(height: 20),
                          Text(
                            'EMAIL',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          Text(
                            email,
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 30),
                          Text(
                            'Pontos',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          Text(
                            pontos.toString(),
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 40),
                          RaisedButton(
                            onPressed: () {
                              signOutGoogle();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) {
                                return LoginPage();
                              }), ModalRoute.withName('/'));
                            },
                            color: Colors.deepPurple,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Sign Out',
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white),
                              ),
                            ),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                          )
                        ],
                      ),
                    ),
                  );
                }
              })),
    );
  }
}
