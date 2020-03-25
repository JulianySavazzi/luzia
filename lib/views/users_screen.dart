import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              )
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child:Container(
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: 100, horizontal: 10),
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
                            '"'
                              +'O milagre não é dar vida ao corpo extinto,\n'
                              + 'Ou luz ao cego, ou eloquência ao mundo...\n'
                              + 'Nem mudar água pura em vinho tinto...\n'
                              + 'Milagre é acreditarem nisso tudo.'
                              + '"\n'
                              + 'Mario Quintana\n',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: ActionChip(
                            //button google auth
                            tooltip: 'Sou Deficiente Visual', //descrição do botão que o leitor de tela lê
                            avatar: CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 50.0,
                            ),
                            label: Text('Sou Deficiente Visual',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),

                            padding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 40.0,
                            ),
                            onPressed: (){
                              //Tela para usuários com deficiência visual
                              Navigator.pushNamed(context, DefVisualScreen.id);
                            },
                            backgroundColor: Colors.lightGreenAccent.shade100,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: ActionChip(
                            //button facebook auth
                            tooltip: 'Sou Votuntário', //descrição do botão que o leitor de tela lê
                            avatar: CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 50.0,
                            ),
                            label: Text('Sou Voluntário',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),

                            padding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 40.0,
                            ),
                            onPressed: (){
                              //Tela para voluntários
                              Navigator.pushNamed(context, VoluntarioScreen.id);
                            },
                            backgroundColor: Colors.lightGreenAccent.shade100,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ) ,
        ]),
      ),
    );
  }
}
