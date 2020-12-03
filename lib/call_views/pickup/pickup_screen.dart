import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:luzia/constants/strings.dart';
import 'package:luzia/model/call.dart';
import 'package:luzia/model/users.dart';
import 'package:luzia/utils/call_methods.dart';
import 'package:luzia/utils/firebase_methods.dart';
import 'package:luzia/utils/firebase_repository.dart';
import 'package:luzia/utils/permissions.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../call_screen.dart';

class PickupScreen extends StatefulWidget {
  final Call call;
  final Users oneVolunteer;
  static const String id = 'pickup_screen';

  PickupScreen({
    @required this.call, @required this.oneVolunteer
  });

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();
  final StopWatchTimer _stopWatchTimer =
      StopWatchTimer(); // Create instance for timer
  var time;
  FirebaseRepository _repository = FirebaseRepository();

  var ajuda = 0;

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    await _stopWatchTimer.dispose(); // for stopwatch timer
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('init state atendeu = $atendeu');
    _stopWatchTimer.onExecute.add(StopWatchExecute.start); // Start timer
    _stopWatchTimer.rawTime.listen((value) {
      time = StopWatchTimer.getDisplayTime(value);
      print('Time: $time');
    });
    print('Time: $time');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.cyan.shade50,
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                //hero animation with tag
                tag: 'text',
                child: ScaleAnimatedTextKit(
                  text: ["Você tem uma ligação do Luzia!"],
                  textStyle: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Montserrat',
                      fontStyle: FontStyle.italic),
                  isRepeatingAnimation: true,
                  totalRepeatCount: 1000,
                  scalingFactor: .8,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Hero(
                //Hero animation with tag
                tag: 'logo',
                child: Image.asset(
                  "images/logo.png",
                  height: 100,
                  width: 100,
                ),
              ),
              SizedBox(height: 75),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    tooltip: 'Encerrar chamada',
                    icon: Icon(Icons.call_end),
                    color: Colors.redAccent,
                    iconSize: 50,
                    onPressed: () async {
                      print('Time: $time');
                      await callMethods.endCall(call: widget.call);
                      Fluttertoast.showToast(
                          msg: "Chamada encerrada!",
                          toastLength: Toast.LENGTH_LONG,
                          textColor: Colors.white,
                          gravity: ToastGravity.CENTER);
                      await callMethods.endCall(call: widget.call);
                    },
                  ),
                  SizedBox(width: 25),
                  IconButton(
                      tooltip: 'Atender chamada',
                      icon: Icon(Icons.call),
                      iconSize: 50,
                      color: Colors.green,
                      onPressed: () async {
                        setState(() {}); // THE VOLUNTEER ANSWERED;
                        addHelp(); //add help to volunteer join call
                        await Permissions
                                .cameraAndMicrophonePermissionsGranted()
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CallScreen(call: widget.call),
                                ),
                              )
                            : Navigator.pop(context);
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addHelp() {
    _repository.getCurrentUser().then((FirebaseUser user) async {
      //get current volunteer
      if (user != null) {
        //current volunteer is not null
        Users volunteer = await _repository
            .getUserDetails(user.uid); // users map receive firebase user
        ajuda = volunteer.ajuda;
        addHelpToVolunteer(
            user, ajuda); //incremented help for current volunteer in database
      } else {
        Fluttertoast.showToast(
            msg: "Houve um erro",
            toastLength: Toast.LENGTH_LONG,
            textColor: Colors.red[300],
            gravity: ToastGravity.BOTTOM);
      }
    });
  }

  Future<void> addHelpToVolunteer(FirebaseUser currentUser, int ajuda) async {
    Users user = Users(
      uid: currentUser.uid,
      nome: currentUser.displayName,
      email: currentUser.email,
      tipo: "V",
      photo: currentUser.photoUrl,
      ajuda: ajuda + 1,
    );
    FirebaseMethods.firestore
        .collection(USERS_COLLECTION)
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }
}
