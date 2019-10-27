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

class Essencia {
  final int id;
  final Marca marca;
  final String gosto;
  final String comentario;
  final String sabor;
  final int reputacao;
  final String status;
  final String nome;
  final String proposta;
  final String image;
  final List<Message> message;

  Essencia(this.id, this.marca, this.gosto, this.sabor, this.comentario,
      this.reputacao, this.status, this.nome, this.proposta, this.image, this.message);

}

class Message {
  final int id;
  final String date;
  final String text;
  final String nameOwner;
  final String emailOwner;
  final int idOwner;

  Message(this.id, this.date, this.text, this.nameOwner, this.emailOwner, this.idOwner);

}

class Marca {
  final int id;
  final String marca;
  final String image;

  Marca(this.id, this.marca, this.image);
}

class WaitApprove {
  final int id;
  final Essencia essencia;
  final SimplePerson owner;
  final List<SimplePerson> peoplePro;
  final List<SimplePerson> peopleAgainst;
  final String message;
  final String status;

  WaitApprove(this.id,this.essencia, this.owner, this.peoplePro, this.peopleAgainst, this.message, this.status);
}

class EditApprove {
  final int id;
  final Essencia essenciaNova;
  final Essencia essenciaAntiga;
  final SimplePerson owner;
  final List<SimplePerson> peoplePro;
  final List<SimplePerson> peopleAgainst;

  EditApprove(this.id,this.essenciaNova,this.essenciaAntiga ,this.owner, this.peoplePro, this.peopleAgainst);
}

class Person {
  final int id;
  final String name;
  final String estado;
  final String cidade;
  final String token;
  final String email;
  final String pontos;
  final List<Essencia> essencias;

  Person(this.id, this.name, this.estado, this.cidade, this.token, this.email,this.pontos,this.essencias);
}

class SimplePerson {
  final int id;
  final String name;
  final String email;

  SimplePerson(this.id, this.name, this.email);
  
}

class IdNamePerson {
  final int id;
  final String name;

  IdNamePerson(this.id, this.name);
  
}
