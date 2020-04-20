import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luzia/call_views/pickup/pickup_layout.dart';

//Tela para voluntários

class VoluntarioScreen extends StatefulWidget {
  //String usada para dar nome á rota que leva a essa tela do app
  //Static const é para criarmos uma constante da classe, assim podemos referenciar a classe e não um objeto da classe
  static const String id = 'v_screen';

  @override
  _VoluntarioScreenState createState() => _VoluntarioScreenState();
  //Esse State é pra você poder setar um status para os botões, não sei se vamos usar mas já fiz pensando nisso
}

//OBS: o app não está muito responsivo, fui testar ele com a tela virada no celular e não deu pra navegar, mas no modo retrato funcionou
//tentei deixar o app responsivo fazendo o que eu vi em um tutorial mas não tive muito sucesso,
//o link do tutorial está no fichamento

class _VoluntarioScreenState extends State<VoluntarioScreen> {
  Route previousRoute;
  //FirebaseRepository _repository = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
        //mudança para pickuplayout, integração com chamada
        scaffold: Scaffold(
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
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                      //VOLUNTÁRIO
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.lightGreenAccent[100],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //SizedBox(width: 10.0),
                          Text(
                            'Sou voluntário',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontSize: 20.0),
                          )
                        ],
                      ),
                      onPressed: () {
                        //Navigator.pushNamed(context, PickupScreen.id);
                      }),
                ),
              ),
            ),
          ),
        ]),
      ),
    ));
  }

  @protected
  @mustCallSuper
  void didChangePrevious(Route previousRoute) {}
}
