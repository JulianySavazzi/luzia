import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:luzia/utils/firebase_repository.dart';
import 'dv_screen.dart';
import 'v_screen.dart';

FirebaseRepository _repository = FirebaseRepository();

bool isLoginPressed = false;
bool voluntario = false;

//vars for type and help number by users
String tipo = "";
int ajuda = 0;

class UsersScreen extends StatefulWidget {
  static const String id = 'users_screen';

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
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
                          //Hero page transition by tag
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
                          //space between logo and text
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
                                tipo = "D";
                                ajuda = null;
                                //DV screen
                                addType();
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
                                tipo = "V";
                                ajuda = 0;
                                //V screen
                                addType();
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

//Add type for user
  void addType() {
    setState(() {
      isLoginPressed = true;
    });
    _repository.getCurrentUser().then((FirebaseUser user) {
      if (user != null) {
        authenticateType(user, tipo, ajuda);
      } else {
        Fluttertoast.showToast(
            msg: "Houve um erro",
            toastLength: Toast.LENGTH_LONG,
            textColor: Colors.red[300],
            gravity: ToastGravity.BOTTOM);
      }
    });
  }

  //Auth type for user
  void authenticateType(FirebaseUser user, String tipo, int ajuda) {
    _repository.authenticateUser(user).then((isNewUser) {
      setState(() {
        isLoginPressed = true;
      });
      if (!isNewUser) {
        _repository.addType(user, tipo, ajuda).then((value) {
          if (ajuda == 0) {
            setState(() {
              voluntario = true;
            });
            Navigator.pushNamed(context, VoluntarioScreen.id);
            print(VoluntarioScreen);
          } else {
            Navigator.pushNamed(context, DefVisualScreen.id);
          }
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
}
