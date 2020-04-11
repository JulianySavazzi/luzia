import 'package:flutter/material.dart';
import 'package:luzia/model/call.dart';
import 'package:luzia/utils/call_methods.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:splashscreen/splashscreen.dart';

import '../call_screen.dart';

class PickupScreen extends StatelessWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();
  static const String id = 'pickup_screen';
  //bool buttonIsPressed = false;

  PickupScreen({
    @required this.call,
  });

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
              Container(
                  height: 100,
                  width: 100,
                  child: FlareActor(
                    "animations/endcall.flr",
                    animation: "endcall",
                    fit: BoxFit.contain,
                  )
              ),
              SizedBox(height: 75),
              Container(
                  height: 100,
                  width: 100,
                  child: FlareActor(
                    "animations/call.flr",
                    animation: "call",
                    fit: BoxFit.contain,
                  ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    tooltip: 'Encerrar chamada',
                    icon: Icon(Icons.call_end),
                    color: Colors.redAccent,
                    iconSize: 50,
                    onPressed: () async {
                      Fluttertoast.showToast(
                          msg: "Chamada encerrada!",
                          toastLength: Toast.LENGTH_LONG,
                          textColor: Colors.white,
                          gravity: ToastGravity.CENTER);
                      //buttonIsPressed = true;
                      await callMethods.endCall(call: call);
                    },
                  ),
                  SizedBox(width: 25),
                  IconButton(
                    tooltip: 'Atender chamada',
                    icon: Icon(Icons.call),
                    iconSize: 50,
                    color: Colors.green,
                    onPressed: () {
                      //buttonIsPressed = true;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CallScreen(call: call),
                          ));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
