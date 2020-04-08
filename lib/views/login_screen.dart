import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:link/link.dart';
import 'package:luzia/utils/firebase_repository.dart';
import 'users_screen.dart';

//Tela de login/sig in por autenticação do google e facebook pelo firebase

class LoginScreen extends StatefulWidget {
  //String usada para dar nome á rota que leva a essa tela do app
  //Static const é para criarmos uma constante da classe, assim podemos referenciar a classe e não um objeto da classe
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
//Esse State é pra você poder setar um status para os botões, não sei se vamos usar mas já fiz pensando nisso
}

//OBS: o app não está muito responsivo, fui testar ele com a tela virada no celular e não deu pra navegar, mas no modo retrato funcionou
//tentei deixar o app responsivo fazendo o que eu vi em um tutorial mas não tive muito sucesso,
//o link do tutorial está no fichamento

class _LoginScreenState extends State<LoginScreen> {
  //FIREBASE FUNCTIONS
  FirebaseRepository _repository = FirebaseRepository();

  FirebaseUser myUser;

  bool isLoginPressed = false;

  bool isLinkPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Luzia',
          style: TextStyle(
            fontFamily: 'LiuJianMaoCao',
            color: Colors.black,
            fontSize: 50.0,
          ),
        ),
      ),
      backgroundColor: Colors.cyan.shade200,
      body: SafeArea(
        child: Stack(children: <Widget>[
          Positioned(
            top: 85.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
                color: Colors.white,
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Positioned(
              top: 30.0,
              left: (MediaQuery.of(context).size.width / 2) - 85,
              child: Container(
                height: 200,
                child: Stack(children: <Widget>[
                  Container(
                    height: 180,
                    width: 180,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                            child: Hero(
                          //Hero indica a transição de página dando foco no elemento com a tag
                          tag: 'logo',
                          child: Container(
                            //LOGO APP
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("images/logo.png"),
                              ),
                            ),
                          ),
                        ))
                      ],
                    ),
                  )
                ]),
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Container(
              margin: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 120, horizontal: 10),
                          //Espaço entre a logo e a Imagem
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: Image(
                            //Imagem sobre voluntariado da tela de login
                            image: AssetImage('images/loginscreen.png'),
                            semanticLabel:
                                'Pessoas felizes fazendo voluntariado',
                            width: 300,
                            height: 160,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //Barra de progresso
                        isLoginPressed
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.lightGreenAccent),
                                ),
                              )
                            : SizedBox(
                                height: 10.0,
                              ),
                        Container(
                          width: 250.0,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              color: Colors.lightGreenAccent[100],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // Icon(Icons.visibility),
                                  CircleAvatar(
                                    backgroundColor:
                                        Colors.lightGreenAccent.shade100,
                                    backgroundImage:
                                        AssetImage("images/google.png"),
                                    radius: 10.0,
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    'Entrar com o Google',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Montserrat',
                                        fontSize: 15.0),
                                  )
                                ],
                              ),
                              onPressed: () {
                                createDialog(context);
                                //alert dialog de termos de uso
                                //se aceitar termos de uso, autenticação de usuário
                                //Google sign
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              color: Colors.lightGreenAccent[100],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor:
                                        Colors.lightGreenAccent.shade100,
                                    backgroundImage:
                                        AssetImage("images/facebook.png"),
                                    radius: 10.0,
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    'Entrar com o Facebook',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Montserrat',
                                        fontSize: 15.0),
                                  )
                                ],
                              ),
                              onPressed: () {
                                //alert para termos de uso
                                //se aceitar termos de uso, chamar autenticação
                                //se autenticação ok
                                //ir para a tela do usuário
                                facebookDialog(context);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    isLinkPressed
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.lightGreenAccent),
                            ),
                          )
                        : SizedBox(
                            height: 10.0,
                          ),
                    Container(
                      width: 250,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Link(
                                child: Text(
                                  //Onde será o link para o site
                                  'Termos de uso e Política de Privacidade',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Montserrat',
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                  ),
                                ),
                                url: 'http://www.google.com',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  // ********************************************************************************** //

  //Método para mostrar o diálogo ao logar com o google
  createDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Atenção"),
            content:
                Text("Você aceita os termos de política de uso e privacidade?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Não aceito"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Aceito"),
                onPressed: () => performLogin(),
              ),
            ],
            elevation: 24.0,
          );
        });
  }

  //Método para realizar o log in com o google. Caso dê erro, um toast aparece com a mensagem.
  void performLogin() {
    setState(() {
      isLoginPressed = true;
    });
    _repository.signIn().then((FirebaseUser user) {
      if (user != null) {
        authenticateUser(user);
      } else {
        Fluttertoast.showToast(
            msg: "Houve um erro ao efetuar o log-in",
            toastLength: Toast.LENGTH_LONG,
            textColor: Colors.red[300],
            gravity: ToastGravity.BOTTOM);
      }
    });
  }

  //Método usado para controlar autenticação de usuários:
  //Se o usuário é novo, passa para tela tipo de usuario,
  //caso contrário para sua respectiva tela. Pois o usuário pode
  //desinstalar o app etc.
  void authenticateUser(FirebaseUser user) {
    _repository.authenticateUser(user).then((isNewUser) {
      setState(() {
        isLoginPressed = false;
      });
      if (isNewUser) {
        _repository.addDataToDb(user).then((value) {
          Navigator.pushNamed(context, UsersScreen.id);
        });
      } else {
        Navigator.pushNamed(context, UsersScreen.id);
      }
    });
  }

  //**************** Facebook Login *******************

  //Método para mostrar o diálogo de termos de uso ao logar com facebook
  facebookDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Atenção"),
            content:
                Text("Você aceita os termos de política de uso e privacidade?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Não aceito"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Aceito"),
                onPressed: () => logIn(), //login com facebook
              ),
            ],
            elevation: 24.0,
          );
        });
  }

  //login com o facebook
  void logIn() {
    _repository.loginWithFacebook().then((response) {
      if (response != null) {
        myUser = response;
        authenticateUser(myUser); //autenticação de usuário do firebase
        setState(() {
          isLoginPressed = true;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Houve um erro ao efetuar o log-in",
            toastLength: Toast.LENGTH_LONG,
            textColor: Colors.red[300],
            gravity: ToastGravity.BOTTOM);
      }
    });
  }
}
