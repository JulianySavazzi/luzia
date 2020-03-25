import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
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
      backgroundColor: Colors.cyan.shade300,
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
                            //Precisa etiquetar a imagem, ainda não vi como faz
                            image: AssetImage('images/loginscreen.jpg'),
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
                        SizedBox(
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
                                //colocar alert para termos de uso
                                //se aceitar termos de uso, chamar autenticação
                                //se autenticação ok
                                //ir para a tela do usuário
                                Navigator.pushNamed(
                                    context, UsersScreen.id);
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
                                //colocar alert para termos de uso
                                //se aceitar termos de uso, chamar autenticação
                                //se autenticação ok
                                //ir para a tela do usuário
                                Navigator.pushNamed(
                                    context, UsersScreen.id);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
}
