import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:luzia/constants/strings.dart';
import 'package:luzia/model/call.dart';
import 'package:luzia/model/users.dart';
import 'package:luzia/utils/call_methods.dart';
import 'package:luzia/utils/firebase_repository.dart';
import 'package:luzia/utils/permissions.dart';
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
  // FirebaseRepository _repository = FirebaseRepository();
  Firestore db = Firestore.instance;
  // var ajuda = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                      await callMethods.endCall(call: widget.call);
                      Fluttertoast.showToast(
                          msg: "Chamada encerrada!",
                          toastLength: Toast.LENGTH_LONG,
                          textColor: Colors.white,
                          gravity: ToastGravity.CENTER);
                      // await callMethods.endCall(call: widget.call);
                    },
                  ),
                  SizedBox(width: 25),
                  IconButton(
                      tooltip: 'Atender chamada',
                      icon: Icon(Icons.call),
                      iconSize: 50,
                      color: Colors.green,
                      onPressed: () async {
                        // setState(() {}); // THE VOLUNTEER ANSWERED;
                        // addHelp(); //add help to volunteer join call
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

  // void addHelp() {
  //   _repository.getCurrentUser().then((FirebaseUser user) async {
  //     //get current volunteer
  //     if (user != null) {
  //       //current volunteer is not null
  //       Users volunteer = await _repository
  //           .getUserDetails(user.uid); // users map receive firebase user
  //       ajuda = volunteer.ajuda;
  //       addHelpToVolunteer(
  //           user, ajuda); //incremented help for current volunteer in database
  //     } else {
  //       Fluttertoast.showToast(
  //           msg: "Houve um erro",
  //           toastLength: Toast.LENGTH_LONG,
  //           textColor: Colors.red[300],
  //           gravity: ToastGravity.BOTTOM);
  //     }
  //   });
  // }
  //
  // Future<void> addHelpToVolunteer(FirebaseUser currentUser, int ajuda) async { //update volunteer's ajuda attribute in db
  //   String vId; // id for current volunteer
  //   vId = currentUser.uid.toString();
  //   db.collection(USERS_COLLECTION).document(vId).updateData({
  //     'ajuda':  ajuda + 1,
  //   });
  // }
}
