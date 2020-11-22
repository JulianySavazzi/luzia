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
import 'package:luzia/views/dv_screen.dart';

import '../call_screen.dart';

class PickupScreen extends StatefulWidget {
  final Call call;
  static const String id = 'pickup_screen';

  PickupScreen({
    @required this.call,
  });

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();
  CallMethods _callMethods = CallMethods();

  Call call_model = Call();
  // String callerId;
  // String callerName;
  // String receiverId;
  // String receiverName;
  // String channelId;
  // bool hasDialled;
  // bool accepted;
  // bool rejected;

  FirebaseRepository _repository = FirebaseRepository();

  var ajuda = 0;

  @override
  Widget build(BuildContext context) {
    //_playRingtone(); //start ringtone
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
                      flagEndCall();
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
                        flagJoinCall();
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

  void flagEndCall() {
    _repository.getCurrentUser().then((FirebaseUser user) async {
      //get current volunteer
      if (user != null) {
        //current volunteer is not null
        Users volunteer = await _repository.getUserDetails(user.uid); // users map receive firebase user
        // call.accepted = false;
        // call.rejected = true;
        //V = HASNOTDIALLED
        call_model.receiverId = volunteer.uid;
        call_model.receiverName = volunteer.nome;
        //call_model.hasDialled = false;
        call_model.rejected = true;
        call_model.accepted = false;
        // Map<String, dynamic> hasNotDialledMap = call_model.toMap(call_model);
        _callMethods.makeCall(call: call_model);
      }
    });
  }

  void flagJoinCall() {
    _repository.getCurrentUser().then((FirebaseUser user) async {
      //get current volunteer
      if (user != null) {
        //current volunteer is not null
        Users volunteer = await _repository.getUserDetails(user.uid); // users map receive firebase user
        // call.accepted = true;
        // call.rejected = false;
        //V = HASNOTDIALLED
        call_model.receiverId = volunteer.uid;
        call_model.receiverName = volunteer.nome;
        //call_model.hasDialled = false;
        call_model.rejected = false;
        call_model.accepted = true;
        // Map<String, dynamic> hasNotDialledMap = call_model.toMap(call_model);
        _callMethods.makeCall(call: call_model);
      }
    });
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
