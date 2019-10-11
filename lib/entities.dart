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
  final String gosto;
  final String sabor;
  final Marca marca;
  final String comentario;
  final int reputacao;
  final String status;

  Essencia(this.id, this.marca, this.gosto, this.sabor, this.comentario,
      this.reputacao, this.status);
}

class Marca {
  final int id;
  final String marca;

  Marca(this.id, this.marca);
}

class WaitApprove {
  final Essencia essencia;
  final Person owner;
  final List<Person> peoplePro;
  final List<Person> peopleAgainst;
  final String message;
  final String status;

  WaitApprove(this.essencia, this.owner, this.peoplePro, this.peopleAgainst, this.message, this.status);
}

class Person {
  final int id;
  final String name;
  final String estado;
  final String cidade;
  final String token;
  final String email;

  Person(this.id, this.name, this.estado, this.cidade, this.token, this.email);
}
