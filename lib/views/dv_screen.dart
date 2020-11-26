//import 'dart:io';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:luzia/model/call.dart';
import 'package:luzia/model/users.dart';
import 'package:luzia/provider/user_provider.dart';
import 'package:luzia/utils/call_methods.dart';
import 'package:luzia/utils/call_utilities.dart';
import 'package:luzia/utils/firebase_repository.dart';
import 'package:luzia/utils/permissions.dart';
//import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

Route previousRoute;
FirebaseRepository _repository = FirebaseRepository();
final CallMethods callMethods = CallMethods();
//ProgressDialog pr;

List<Users> volunteers;
List<Users> volunteersAcceptedCall;
List<Users> volunteersRejectedCall;
Call call;
Users oneVolunteer = Users();
Users sender = Users();
int tries = 0;
int atendeu;

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
    setState(() {
      atendeu = 0; //start variable
    });
    //Add UsersProviders refresh, using this to
    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshUser();
    });
    _repository.getCurrentUser().then((FirebaseUser currentUser) {
      _repository.searchVolunteers().then((List<Users> list) {
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

  //flag volunteer join a call
  // Future<Users> flagVolunteer() async { //move to call screen
  //   _repository.flagVolunteerJoinACall(oneVolunteer).then((List<Users> list) {
  //     volunteersAcceptedCall = list;
  //   });
  //   for (var i = 0; i < volunteersAcceptedCall.length; i++) {
  //     if (volunteersAcceptedCall[i].uid == oneVolunteer.uid) {
  //       //check if selected volunteer join a call
  //       setState(() {
  //         atendeu = 1; //volunteer join a call
  //         print("atendeu = ");
  //         print(atendeu);
  //       });
  //       print("Accepted Call ");
  //       print(volunteersAcceptedCall[i].nome);
  //       print("Selected volunteer ");
  //       print(oneVolunteer.nome);
  //       return oneVolunteer;
  //     } else {
  //       _repository
  //           .flagVolunteerLeaveACall(oneVolunteer)
  //           .then((List<Users> list) {
  //         volunteersRejectedCall = list;
  //       });
  //       setState(() {
  //         atendeu = 2; //volunteer end call
  //         print("atendeu = ");
  //         print(atendeu);
  //       });
  //       print("Rejected Call ");
  //       print(volunteersRejectedCall[i].nome);
  //       print("Selected volunteer ");
  //       print(oneVolunteer.nome);
  //       return oneVolunteer;
  //     }
  //   }
  //   print("Selected volunteer ");
  //   print(oneVolunteer.nome);
  //   return oneVolunteer;
  // }

  //METHOD FOR ENTERING A LOOP UNTIL A VOLUNTEER IS SELECTED
  // searchAlgorithm(context) async { // move to call screen
  //   Stopwatch _stopwatch = Stopwatch();
  //   do {
  //     print("Entrou no DO WHILE");
  //     print('tentativa: $tries');
  //     print('atendeu = $atendeu');
  //     selectingVolunteers(oneVolunteer);
  //     print("oneVolunteer = ");
  //     print(oneVolunteer.nome);
  //     print("ajuda = ");
  //     print(oneVolunteer.ajuda);
  //     flagVolunteer();
  //     CallUtils.dial(from: sender, to: oneVolunteer, context: context);
  //     flagVolunteer();
  //     if (atendeu != 1 && tries < 6) {
  //       print("Entrou no IF");
  //       print('tentativa: $tries');
  //       print('atendeu = $atendeu');
  //       print("Entrou no IF");
  //       print('atendeu = $atendeu');
  //       print('tentativa: $tries');
  //       _stopwatch.start();
  //       print('início do timer 10sec');
  //       print('tentativa: $tries');
  //       sleep(Duration(seconds: 10));
  //       _stopwatch.stop();
  //       callMethods.endCall(call: call);
  //       searchAlgorithm(context);
  //     }
  //     tries++;
  //   } while (tries < 6);
  //   print("SAIU DO WHILE");
  //   tries = 0;
  //   print('tentativa: $tries');
  //   Fluttertoast.showToast(
  //       msg: "Não foi possível encontrar um voluntário, tente novamente",
  //       toastLength: Toast.LENGTH_LONG,
  //       textColor: Colors.red[300],
  //       gravity: ToastGravity.CENTER);
  //   print('tentativa: $tries');
  // }

  callVolunteer(context) {
    try {
      print("TRY CALL VOLUNTEER");
      selectingVolunteers(oneVolunteer);
      print("oneVolunteer = ");
      print(oneVolunteer.nome);
      print("ajuda = ");
      print(oneVolunteer.ajuda);
      CallUtils.dial(from: sender, to: oneVolunteer, context: context);
      // flagVolunteer();
      // print("flagged volunteer");
      // searchAlgorithm(context);
    } catch (error) {
      print("CALL VOLUNTEER CATCH");
      // flagVolunteer();
      // print("flagged volunteer");
      Fluttertoast.showToast(
          msg: "Nenhum voluntário estava disponível, tente novamente $error",
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.red[300],
          gravity: ToastGravity.CENTER);
    }
  }

  @override
  Widget build(BuildContext context) {
    // pr = new ProgressDialog(context);
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
                  // pr = ProgressDialog(
                  //   context,
                  //   type: ProgressDialogType.Download,
                  //   isDismissible: false,
                  // );
                  // pr.style(
                  //   message: 'Chamando voluntário...',
                  // );
                  // await pr.show();
                  Fluttertoast.showToast(
                      msg: "Chamando voluntário...",
                      toastLength: Toast.LENGTH_LONG,
                      textColor: Colors.white,
                      gravity: ToastGravity.CENTER);
                  await Permissions.cameraAndMicrophonePermissionsGranted()
                      ? callVolunteer(context)
                      //? callVolunteer(context)
//                  print(volunteers);
//                  selectingVolunteers(oneVolunteer);
//                  print(sender.nome);
                      : Navigator.pop(context);
                  // await pr.hide;
                },
              ),
            )),
          )
        ])));
  }
}
