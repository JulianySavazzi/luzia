import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luzia/model/users.dart';
import 'package:luzia/utils/firebase_repository.dart';
import 'package:luzia/views/dv_screen.dart';
import 'package:luzia/views/v_screen.dart';
import 'package:luzia/views/login_screen.dart';
import 'package:luzia/views/users_screen.dart';
import 'package:luzia/utils/firebase_methods.dart';

void main() => runApp(LuziaApp());

class LuziaApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<LuziaApp> {
  FirebaseRepository _repository = FirebaseRepository();
  FirebaseUser type;
  FirebaseMethods _firebaseMethods = FirebaseMethods();
  Users user;
  Firestore firestore;
  //resultado do voluntario
  bool result = false;

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((FirebaseUser currentUser) {
      _repository.searchVolunteer(currentUser);
        type = currentUser;
    });
  }

  //pegar voluntário
  //NÃO FUNCIONOU, SE EU CONSEGUISSE COMPARAR O ID DO USUÁRIO LOGADO COM O DO VOLUNTÁRIO ACHO QUE DARIA
//  void getVoluntario() async {
//    final voluntario = await firestore.collection('users').where('tipo', isEqualTo: 'V').getDocuments();
//    if(voluntario != null && _repository.getCurrentUser() != null){
//      if(type.uid == _repository.getCurrentUser()){
//        setState(() {
//          result = true;
//        });
//      }
//    } else{
//      setState(() {
//        result = false;
//      });
//    }
//  }

   Future<Users> userDetails(firebaseUser) async {
    // retrieving User details
     //firebaseUser = user;
    user = await _repository.getUserDetails(firebaseUser.uid);
    if(user.tipo == "V"){
      setState(() {
        result = true; //voluntário
      });
    } else {
      setState(() {
        result = false; //deficiente visual
      });
    }
    return user;
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luzia',
      home: FutureBuilder(
          future: _repository.getCurrentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot)  {
            if (snapshot.hasData) {
              // initializing firebase user
              FirebaseUser firebaseUser = snapshot.data;
              //retrieving User details
              userDetails(firebaseUser);
              // This line is responsible for checking the user type and returning the nced
                return result == true ? VoluntarioScreen() : DefVisualScreen();
            } else {
              return LoginScreen();
            }
          }
          ),
      theme: ThemeData(
        primaryColor: Colors.cyan,
      ),
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
