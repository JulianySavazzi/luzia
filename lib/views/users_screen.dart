import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:luzia/utils/firebase_repository.dart';
import 'dv_screen.dart';
import 'v_screen.dart';

//Tela para diferenciar o usuário com deficiência visual do voluntário

class UsersScreen extends StatefulWidget {
  //String usada para dar nome á rota que leva a essa tela do app
  //Static const é para criarmos uma constante da classe, assim podemos referenciar a classe e não um objeto da classe
  static const String id = 'users_screen';

  @override
  _UsersScreenState createState() => _UsersScreenState();
//Esse State é pra você poder setar um status para os botões, não sei se vamos usar mas já fiz pensando nisso
}

//OBS: o app não está muito responsivo, fui testar ele com a tela virada no celular e não deu pra navegar, mas no modo retrato funcionou
//tentei deixar o app responsivo fazendo o que eu vi em um tutorial mas não tive muito sucesso,
//o link do tutorial está no fichamento

class _UsersScreenState extends State<UsersScreen> {
//FIREBASE FUNCTIONS
  FirebaseRepository _repository = FirebaseRepository();

  bool isLoginPressed = false;
  bool voluntario = false;

  //Route previousRoute = 'login_screen' as Route;
  Route previousRoute;

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
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 100, horizontal: 10),
                          //Espaço entre a logo e o texto
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 50, horizontal: 5),
                          child: Text(
                            '"' +
                                'O milagre não é dar vida ao corpo extinto,\n' +
                                'Ou luz ao cego, ou eloquência ao mundo...\n' +
                                'Nem mudar água pura em vinho tinto...\n' +
                                'Milagre é acreditarem nisso tudo.' +
                                '"\n' +
                                'Mario Quintana\n',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 15,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
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
                              //DEFICIENTE VISUAL
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              color: Colors.lightGreenAccent[100],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.visibility_off),
                                  SizedBox(width: 10.0),
                                  Text(
                                    'Sou deficiente visual',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Montserrat',
                                        fontSize: 15.0),
                                  )
                                ],
                              ),
                              onPressed: () {
                                //tela do deficiente visual
                                addDv();
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: RaisedButton(
                              //VOLUNTÁRIO
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              color: Colors.lightGreenAccent[100],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.visibility),
                                  SizedBox(width: 10.0),
                                  Text(
                                    'Sou voluntário',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Montserrat',
                                        fontSize: 15.0),
                                  )
                                ],
                              ),
                              onPressed: () {
                                //tela do voluntário
                                addVolunteer();
                              },
                            ),
                          ),
                        ),
                      ],
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

  // ***************************************************************** //

//Método para adicionar voluntário
  void addVolunteer() {
    setState(() {
      isLoginPressed = true;
    });
    _repository.getCurrentUser().then((FirebaseUser user) {
      if (user != null) {
        authenticateVolunteer(user);
      } else {
        Fluttertoast.showToast(
            msg: "Houve um erro",
            toastLength: Toast.LENGTH_LONG,
            textColor: Colors.red[300],
            gravity: ToastGravity.BOTTOM);
      }
    });
  }

  void authenticateVolunteer(FirebaseUser user) {
    _repository.authenticateUser(user).then((isNewUser) {
      setState(() {
        isLoginPressed = false;
      });
      if (!isNewUser) {
        _repository.addVolunteer(user).then((value) {
          Navigator.pushNamed(context, VoluntarioScreen.id);
          didChangePrevious(previousRoute);
          setState(() {
            voluntario = true;
          });
          //return VoluntarioScreen(); não funciona
        });
      } else {
        Fluttertoast.showToast(
            msg: "Erro ao adicionar tipo de usuário",
            toastLength: Toast.LENGTH_LONG,
            textColor: Colors.red[300],
            gravity: ToastGravity.BOTTOM);
      }
    });
  }
  // ***************************************************************** //

  //Método para adicionar Dv

  void addDv() {
    setState(() {
      isLoginPressed = true;
    });
    _repository.getCurrentUser().then((FirebaseUser user) {
      if (user != null) {
        authenticateDv(user);
        setState(() {
          voluntario = false;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Houve um erro",
            toastLength: Toast.LENGTH_LONG,
            textColor: Colors.red[300],
            gravity: ToastGravity.BOTTOM);
      }
    });
  }

  void authenticateDv(FirebaseUser user) {
    _repository.authenticateUser(user).then((isNewUser) {
      setState(() {
        isLoginPressed = false;
      });
      if (!isNewUser) {
        _repository.addDv(user).then((value) {
          Navigator.pushNamed(context, DefVisualScreen.id);
          didChangePrevious(previousRoute); //não sei se realemte funcionou
          //return DefVisualScreen(); não funciona
        });
      } else {
        Fluttertoast.showToast(
            msg: "Erro ao adicionar tipo de usuário",
            toastLength: Toast.LENGTH_LONG,
            textColor: Colors.red[300],
            gravity: ToastGravity.BOTTOM);
      }
    });
  }

  @protected
  @mustCallSuper
  void didChangePrevious(Route previousRoute) {}
}
