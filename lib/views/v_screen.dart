import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luzia/call_views/pickup/pickup_layout.dart';
import 'package:luzia/utils/firebase_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseRepository _repository = FirebaseRepository();
final FirebaseMessaging _fcm = FirebaseMessaging();

class VoluntarioScreen extends StatefulWidget {
  static const String id = 'v_screen';

  @override
  _VoluntarioScreenState createState() => _VoluntarioScreenState();
}

class _VoluntarioScreenState extends State<VoluntarioScreen> {

  @override
  //FUNCTIONS TO HANDLE NOTIFICATIONS
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(message['notification']['title']),
                content: Text(message['notification']['body']),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Não Aceito"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Aceito"),
                    onPressed: () {
                      Navigator.pushNamed(context, VoluntarioScreen.id);
                    },
                  ),
                ],
                elevation: 24.0,
              ));
    }, onLaunch: (Map<String, dynamic> message) async {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(message['notification']['title']),
                content: Text(message['notification']['body']),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Não Aceito"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Aceito"),
                    onPressed: () {
                      Navigator.pushNamed(context, VoluntarioScreen.id);
                    },
                  ),
                ],
                elevation: 24.0,
              ));
    }, onResume: (Map<String, dynamic> message) async {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(message['notification']['title']),
                content: Text(message['notification']['body']),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Não Aceito"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Aceito"),
                    onPressed: () {
                      Navigator.pushNamed(context, VoluntarioScreen.id);
                    },
                  ),
                ],
                elevation: 24.0,
              ));
    });
  }

  int _selectedIndex = 0; //item index

  //static const List<Widget> _widgetOptions = <Widget>[ //required for BottomNavigationBarItem
  List<Widget> _widgetOptions = <Widget>[
    //required for BottomNavigationBarItem
    //Items list for ButtomNavigatorBar
    //item 1
    FutureBuilder(
        future: _repository.getVolunteers(),
        builder: (context, snapshot) {
          //if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            //Error loading volunteer page return circular progressIndicator
            print(snapshot.connectionState); //print connectionState in output
            print(snapshot.hasData); //print hasData in output
            return Center(
                child: Container(
              height: 300,
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Somos ${snapshot.data.length} voluntários!',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                      fontSize: 25.0,
                    ),
                  ),
                  Image(
                    image: AssetImage('images/vhome.jpg'),
                    semanticLabel: 'Várias pessoas voluntárias',
                  ),
                ],
              ),
            ));
          } //if
          else {
            print(snapshot.connectionState); //print connectionState in output
            print(snapshot.hasData); //print hasData in output
            return CircularProgressIndicator();
          } //Connection State Condition
        }),
    //item 2
    FutureBuilder(
        future: _repository.getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
                child: Container(
              height: 310,
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage:
                        CachedNetworkImageProvider(snapshot.data.photo),
                  ),
                  Text(
                    '${snapshot.data.nome}',
                    style: TextStyle(
                        fontFamily: 'LiuJianMaoCao',
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'VOLUNTÁRIO(A)',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24.0,
                      letterSpacing: 2.0,
                    ),
                  ),
                  Divider(
                    color: Colors.black26,
                  ),
                  Text(
                    'Já ajudei ${snapshot.data.ajuda} vezes!',
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'Montserrat',
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ));
          } else {
            print(snapshot.connectionState); //print connectionState in output
            print(snapshot.hasData); //print hasData in output
            return CircularProgressIndicator();
          }
        }),
    //item 3
    Center(
      child: Container(
        height: 310.0,
        width: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              color: Colors.lightGreenAccent[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.movie),
                  SizedBox(width: 10.0),
                  Text(
                    'Como usar o Luzia',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontSize: 15.0),
                  )
                ],
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
                    headers: <String, String>{
                      'my_header_key': 'my_header_value'
                    },
                  );
                } else {
                  throw 'Não é possível abrir $url';
                }
              },
            ),
            SizedBox(
              height: 50.0,
            ),
            Text(
              'Caso encontrar algum erro, sugestão ou reclamação:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              color: Colors.lightGreenAccent[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.email),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    'Entrar em contato',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontSize: 15.0),
                  )
                ],
              ),
              onPressed: () async {
                String url =
                    'mailto:<luzia.developers@gmail.com>?subject=Contato&body=';
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: false,
                    forceWebView: false,
                    headers: <String, String>{
                      'my_header_key': 'my_header_value'
                    },
                  );
                } else {
                  throw 'Erro ao abrir $url';
                }
              },
            ),
          ],
        ),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; //item index selected in buttonNavigationBar
    });
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
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
            icon: Icon(Icons.person),
            title: Text('Perfil'),
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
}
