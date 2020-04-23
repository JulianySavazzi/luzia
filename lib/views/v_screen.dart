import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:link/link.dart';
import 'package:luzia/call_views/pickup/pickup_layout.dart';
import 'package:url_launcher/url_launcher.dart';

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
  //Route previousRoute;
  //FirebaseRepository _repository = FirebaseRepository();

  //vídeo
  String url = 'https://drive.google.com/file/d/1wHwlMOPKEBJM11MLQBfXIWNfYD7-0SNS/view?usp=sharing';


  int _selectedIndex = 0; //índice do item

  static const TextStyle optionStyle =
      TextStyle(color: Colors.black, fontFamily: 'Montserrat', fontSize: 20.0);

  static const List<Widget> _widgetOptions = <Widget>[
    //Lista de itens do ButtomNavigatorBar
    //item 1
    Link(//trocar link pelo url_launcher
      child: Text(
        'Sou voluntário',
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.underline,
            fontSize: 20.0),
      ),
      //url: "https://drive.google.com/file/d/1j_NJcvyvOFpj_AqtHwHatdfPfhQ2iEPI/view?usp=sharing",
      url: "https://youtube.com",
      //url: "https://drive.google.com/file/d/1wHwlMOPKEBJM11MLQBfXIWNfYD7-0SNS/view?usp=sharing",
    ),
    //item 2
    Text(
      'Sou voluntário', //Texto que aparece na tela
      style: optionStyle,
    ),
    //item 3
    Text(
      'Como usar o Luzia', //Texto que aparece na tela
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; //índice do item selecionado
    });
  }

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
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Container(
              child: Center(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //SizedBox(width: 10.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Início'),
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Voluntário'),
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            title: Text('Ajuda'),
            backgroundColor: Colors.black,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreenAccent.shade700,
        onTap: _onItemTapped,
        backgroundColor: Colors.cyan.shade100,
      ),
    ));
  }

//  @protected
//  @mustCallSuper
//  void didChangePrevious(Route previousRoute) {}

}
