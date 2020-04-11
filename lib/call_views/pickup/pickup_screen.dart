import 'package:flutter/material.dart';
import 'package:luzia/model/call.dart';
import 'package:luzia/utils/call_methods.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../call_screen.dart';

class PickupScreen extends StatelessWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();
  static const String id = 'pickup_screen';

  PickupScreen({
    @required this.call,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.cyan.shade100,
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
                    icon: Icon(Icons.call_end),
                    color: Colors.redAccent,
                    iconSize: 50,
                    onPressed: () async {
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
                    icon: Icon(Icons.call),
                    iconSize: 50,
                    color: Colors.green,
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CallScreen(call: call),
                        )),
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
