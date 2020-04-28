import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luzia/call_views/pickup/pickup_layout.dart';
import 'package:luzia/model/users.dart';
import 'package:luzia/provider/user_provider.dart';
import 'package:luzia/utils/firebase_repository.dart';
import 'package:url_launcher/url_launcher.dart';

//Tela para voluntários

const String id = 'v_screen';
final usersRef = Firestore.instance.collection('users');
FirebaseRepository _repository = FirebaseRepository();
FirebaseUser currentUser;
Users user;
//Add UserProvider to refresh users
UserProvider userProvider;
var nome = user.nome;
var ajuda = user.ajuda;

class VoluntarioScreen extends StatefulWidget {
  final String profileId;

  VoluntarioScreen({this.profileId});

  static const String id = 'v_screen';

  @override
  _VoluntarioScreenState createState() => _VoluntarioScreenState();
}

class _VoluntarioScreenState extends State<VoluntarioScreen> {
  int _selectedIndex = 0; //índice do item
  static const TextStyle optionStyle =
      TextStyle(color: Colors.black, fontFamily: 'Montserrat', fontSize: 20.0);
  Users user;

  //static const List<Widget> _widgetOptions = <Widget>[ //required for BottomNavigationBarItem
  List<Widget> _widgetOptions = <Widget>[
    //required for BottomNavigationBarItem
    //Lista de itens do ButtomNavigatorBar
    //item 1
    Container(
      child: Text(
        'Início',
        style: optionStyle,
      ),
    ),
    //item 2
    FutureBuilder(
        future: _repository.getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
                child: Text(
              "Olá \n${snapshot.data.nome}\n Você já ajudou ${snapshot.data.ajuda} vezes.\n Você está logado como ${snapshot.data.email}",
            ));
          }
          return CircularProgressIndicator();
        }),
    //item 3
    Wrap(
      //Vídeo explicativo para voluntário
      children: <Widget>[
        Center(
          child: RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.lightGreenAccent[100],
            child: Text(
              'Como usar o Luzia', //Texto que aparece na tela
              style: optionStyle,
            ),
            onPressed: () async {
              //vídeo
              String url =
                  'https://drive.google.com/open?id=1w8dBZjhbbs924mZKFcJoAl-DFAqBZqMH';
              if (await canLaunch(url)) {
                await launch(
                  url,
                  forceSafariVC: false,
                  forceWebView: false,
                  headers: <String, String>{'my_header_key': 'my_header_value'},
                );
              } else {
                throw 'Não é possível abrir $url';
              }
            },
          ),
        ),
        //Entrar em contato
        SizedBox(
          width: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Text(
            'Caso encontrar algum erro, sugestão ou reclamação:',
            style: optionStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Center(
          child: RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.lightGreenAccent[100],
            child: Text(
              'Entrar em contato', //Texto que aparece na tela
              style: optionStyle,
            ),
            onPressed: () async {
              String url =
                  'mailto:<luzia.developers@gmail.com>?subject=Contato&body=';
              if (await canLaunch(url)) {
                await launch(
                  url,
                  forceSafariVC: false,
                  forceWebView: false,
                  headers: <String, String>{'my_header_key': 'my_header_value'},
                );
              } else {
                throw 'Erro ao abrir $url';
              }
            },
          ),
        ),
      ],
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
        //Footer
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

//  Future<FirebaseUser> getCurrentUser() async {
//    FirebaseUser currentUser;
//    currentUser = await _auth.currentUser();
//    return currentUser;
//  }
//
//  getUser() async {
//    FirebaseUser currentUser = await getCurrentUser();
//    DocumentSnapshot documentSnapshot =
//        await usersRef.document(currentUser.uid).get();
//    user = Users.fromDocument(documentSnapshot);
//  }

//  @protected
//  @mustCallSuper
//  void didChangePrevious(Route previousRoute) {}

}
