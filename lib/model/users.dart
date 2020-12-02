class Users {
  String uid;
  String nome;
  String email;
  String tipo;
  String photo;
  int ajuda;
  int tentativa; //for count tries to call volunteer
  String token;

  Users(
      {this.uid,
      this.nome,
      this.email,
      this.tipo,
      this.photo,
      this.ajuda,
        this.tentativa,
      this.token,});

  Map toMap(Users user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['nome'] = user.nome;
    data['email'] = user.email;
    data['tipo'] = user.tipo;
    data['photo'] = user.photo;
    data['ajuda'] = user.ajuda;
    data['tentativa'] = user.tentativa;
    data['token'] = user.token;
    return data;
  }

  Users.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.nome = mapData['nome'];
    this.email = mapData['email'];
    this.tipo = mapData['tipo'];
    this.photo = mapData['photo'];
    this.ajuda = mapData['ajuda'];
    this.tentativa = mapData['tentativa'];
    this.token = mapData['token'];
  }
}
