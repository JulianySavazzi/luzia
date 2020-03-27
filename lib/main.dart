import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luzia/utils/firebase_repository.dart';
import 'package:luzia/views/dv_screen.dart';
import 'package:luzia/views/v_screen.dart';
import 'package:luzia/views/login_screen.dart';
import 'package:luzia/views/users_screen.dart';

void main() => runApp(LuziaApp());

class LuziaApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<LuziaApp> {
  FirebaseRepository _repository = FirebaseRepository();
  FirebaseUser type;

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((FirebaseUser currentUser) {
      _repository.searchVolunteer(currentUser);
      setState(() {
        type = currentUser; // NAO FUNCIONA
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luzia',
      home: FutureBuilder(
          future: _repository.getCurrentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.hasData) {
              if (type != null) {
                // NAO FUNCIONA
                return VoluntarioScreen();
              } else {
                return DefVisualScreen();
              }
            } else {
              return LoginScreen();
            }
          }),
      //tela inicial do app
      //id é uma constante da classe, então não se coloca ()
      routes: {
        //rotas para indicar as telas do app
        LoginScreen.id: (context) => LoginScreen(),
        UsersScreen.id: (context) => UsersScreen(),
        DefVisualScreen.id: (context) => DefVisualScreen(),
        VoluntarioScreen.id: (context) => VoluntarioScreen(),
      },
    );
  }
}
