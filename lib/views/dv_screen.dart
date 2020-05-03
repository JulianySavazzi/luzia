import 'dart:io';
import 'dart:ui';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:luzia/call_views/pickup/pickup_screen.dart';
import 'package:luzia/model/call.dart';
import 'package:luzia/model/users.dart';
import 'package:luzia/utils/permissions.dart';
import 'package:luzia/provider/user_provider.dart';
import 'package:luzia/utils/call_utilities.dart';
import 'package:luzia/utils/firebase_repository.dart';
import 'package:provider/provider.dart';
import 'package:luzia/services/push_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Route previousRoute;
FirebaseRepository _repository = FirebaseRepository();
//PushNotificationService _fcm = PushNotificationService();
final FirebaseMessaging _fcm = FirebaseMessaging();

List<Users> volunteers;
Call call;
Users oneVolunteer = new Users();
Users sender = new Users();
bool answered = PickupScreen(call: call).answered;
int tries = 0;

//Add UserProvider to refresh users
UserProvider userProvider;

class DefVisualScreen extends StatefulWidget {
  static const String id = 'dv_screen';
  final Duration time;

  DefVisualScreen({this.time});

  @override
  _DefVisualScreenState createState() => _DefVisualScreenState();
}

class _DefVisualScreenState extends State<DefVisualScreen> {
  @override
  void initState() {
    super.initState();
    //NOTIFICATION
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
    }, onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
    }, onResume: (Map<String, dynamic> message) async {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(message['notification']['title']),
            content: Text(message['notification']['body']),
            //actions: <Widget>[
             // FlatButton(
             //   child: Text("Não Aceito"),
             //   onPressed: () {
             //     Navigator.of(context).pop();
             //   },
             // ),
             // FlatButton(
             //   child: Text("Aceito"),
             //   onPressed: () {
                  //TODO FAZER A LIGAÇÃO;
             //     Navigator.of(context).pop();
             //   },
             // ),
            //],
            elevation: 24.0,
          ));
    });
    //Add UsersProviders refresh, using this to
    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshUser();
    });
    _repository.getCurrentUser().then((FirebaseUser currentUser) {
      _repository.searchVolunteers(currentUser).then((List<Users> list) {
        setState(() {
          sender = Users(
            uid: currentUser.uid,
            nome: currentUser.displayName,
          );
          volunteers = list;
        });
      });
    });
  }

  //Select random volunteer, and save chosen volunteer
  Users selectingVolunteers(Users volunteer) {
    final random = new Random();
    var i = random.nextInt(volunteers.length);
    volunteer = Users(
        uid: volunteers[i].uid,
        nome: volunteers[i].nome,
        ajuda: volunteers[i].ajuda,
        tipo: volunteers[i].tipo);

    oneVolunteer = volunteer;

    return volunteer;
  }

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
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Container(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.lightGreenAccent[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //SizedBox(width: 10.0),
                    Text(
                      'Ligar para voluntário',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                          fontSize: 20.0),
                    )
                  ],
                ),
                onPressed: () async {
                  selectingVolunteers(oneVolunteer);
                  await Permissions.cameraAndMicrophonePermissionsGranted()
                      ? CallUtils.dial(
                          from: sender,
                          to: oneVolunteer,
                          context: context,
                        )
                      : Navigator.pop(context);
                },
              ),
            )),
          )
        ])));
  }

  //METHOD FOR ENTERING A LOOP UNTIL A VOLUNTEER IS SELECTED

//  search() async {
//    do {
//      selectingVolunteers(oneVolunteer);
//    } while (tries < 5);
//  }

  searchAlgorithm() async {
    selectingVolunteers(oneVolunteer);
    await Permissions.cameraAndMicrophonePermissionsGranted()
        ? CallUtils.dial(
            from: sender,
            to: oneVolunteer,
            context: context,
          )
        : answerTrue();
    for (int i = 0; i < 5; i++) {
      selectingVolunteers(oneVolunteer);
      await Permissions.cameraAndMicrophonePermissionsGranted()
          ? CallUtils.dial(
              from: sender,
              to: oneVolunteer,
              context: context,
            )
          : answerTrue();
    }
  }
}

startTimer() {
  Stopwatch _stopwatch = Stopwatch();
  _stopwatch.start();
  sleep(Duration(seconds: 30));
  _stopwatch.stop();
}

answerTrue() {
  switch (answered) {
    case true:
      break;

    default:
      return startTimer();
  }
}
