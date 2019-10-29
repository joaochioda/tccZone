import 'dart:convert';
import '../entities.dart';
import 'package:http/http.dart' as http;
import 'package:logint/home.dart';

getFavorite() async {
  var data =
      await http.get("https://pure-scrubland-45679.herokuapp.com/person/$idMe");
  var jsonData = json.decode(data.body);
  List<Essencia> essenciaList = [];
  List<Message> message = [];
  List<Message> messageList = [];

  for (var u in jsonData["essencias"]) {
    message = [];
    for (var j in u["message"]) {
      Message mes = Message(j["id"], j["date"], j["text"], j["nameOwner"],
          j["emailOwner"], j["idOwner"]);
      message.add(mes);
      messageList.add(mes);
    }

    Marca marc =
        Marca(u["marca"]["id"], u["marca"]["marca"], u["marca"]["image"]);
    Essencia essencia = Essencia(
        u["id"],
        marc,
        u["gosto"],
        u["reputacao"],
        u["status"],
        u["nome"],
        u["proposta"],
        u["image"],
        message);
    essenciaList.add(essencia);
  }

  Favorite favor = Favorite(essenciaList, message);

  return favor;
}

getEssencia(int id) async {
  var data = await http
      .get("https://pure-scrubland-45679.herokuapp.com/essencia/${id}");
  var jsonData = json.decode(data.body);
  List<Message> message = [];
  List<Message> messageList = [];

  for (var j in jsonData["message"]) {
    Message mes = Message(j["id"], j["date"], j["text"], j["nameOwner"],
        j["emailOwner"], j["idOwner"]);
    message.add(mes);
    messageList.add(mes);
  }

  Marca marc = Marca(jsonData["marca"]["id"], jsonData["marca"]["marca"],
      jsonData["marca"]["image"]);
  Essencia essencia = Essencia(
      jsonData["id"],
      marc,
      jsonData["sabor"],
      jsonData["reputacao"],
      jsonData["status"],
      jsonData["nome"],
      jsonData["proposta"],
      jsonData["image"],
      message);

  return essencia;
}
