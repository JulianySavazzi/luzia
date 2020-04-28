import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:luzia/model/call.dart';
import 'package:luzia/model/users.dart';
import 'package:luzia/utils/call_methods.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:luzia/utils/firebase_methods.dart';
import 'package:luzia/utils/firebase_repository.dart';
import 'package:luzia/constants/strings.dart';
import 'package:luzia/utils/permissions.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import '../call_screen.dart';

class PickupScreen extends StatelessWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();
  static const String id = 'pickup_screen';
  //FIREBASE FUNCTIONS
  FirebaseRepository _repository = FirebaseRepository();
  var ajuda = 0;
  bool _isPlaying = false;

  _playRingtone() async {
    //Starting the ringtone sound
    if (_isPlaying) {
      FlutterRingtonePlayer.stop(); //parar
    }
    FlutterRingtonePlayer.playNotification(); //tocar
  }

  PickupScreen({
    @required this.call,
  });

  @override
  Widget build(BuildContext context) {
    _playRingtone(); //start ringtone
    //_isPlaying = true;
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
                      //_isPlaying = false;
                      if (_isPlaying) {
                        FlutterRingtonePlayer.stop();
                      }
                      await callMethods.endCall(call: call);
                      Fluttertoast.showToast(
                          msg: "Chamada encerrada!",
                          toastLength: Toast.LENGTH_LONG,
                          textColor: Colors.white,
                          gravity: ToastGravity.CENTER);
                      await callMethods.endCall(call: call);
                    },
                  ),
                  SizedBox(width: 25),
                  IconButton(
                      tooltip: 'Atender chamada',
                      icon: Icon(Icons.call),
                      iconSize: 50,
                      color: Colors.green,
                      onPressed: () async {
                        //_isPlaying = false;
                        if (_isPlaying) {
                          FlutterRingtonePlayer.stop();
                        }
                        await Permissions
                                .cameraAndMicrophonePermissionsGranted()
                            ?
                            //Adicionar ajuda
                            //ajuda++;
                            //addHelp(); //adiciona ajuda ao voluntário que atende a ligação
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CallScreen(call: call),
                                ),
                              )
                            : {};
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Adicionar ajuda ao voluntário que atende ligação
  void addHelp() {
    _repository.getCurrentUser().then((FirebaseUser user) async {
      if (user != null) {
        Users volunteer = await _repository.getUserDetails(user.uid);
        ajuda = volunteer.ajuda;
        addHelpToVolunteer(user);
        print(user.email);
        print(ajuda);
      } else {
        Fluttertoast.showToast(
            msg: "Houve um erro",
            toastLength: Toast.LENGTH_LONG,
            textColor: Colors.red[300],
            gravity: ToastGravity.BOTTOM);
      }
    });
  }

//Adicionando numero de ajudas ao voluntário
  Future<void> addHelpToVolunteer(FirebaseUser currentUser) async {
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
    print(user.ajuda); //mostrar ajuda
  }
}
