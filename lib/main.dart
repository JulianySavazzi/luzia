import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luzia/views/dv_screen.dart';
import 'package:luzia/views/v_screen.dart';
import 'package:luzia/views/login_screen.dart';
import 'package:luzia/views/users_screen.dart';

void main() => runApp(LuziaApp());

class LuziaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luzia',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      initialRoute: LoginScreen.id,
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
