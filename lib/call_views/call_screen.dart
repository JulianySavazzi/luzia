import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:luzia/model/call.dart';
import 'package:luzia/provider/user_provider.dart';
import 'package:luzia/utils/call_methods.dart';
import 'package:luzia/views/dv_screen.dart';
import 'package:provider/provider.dart';

class CallScreen extends StatefulWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();

  CallScreen({
    @required this.call,
  });

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  //animações
  final CallMethods callMethods = CallMethods();

  UserProvider userProvider;
  StreamSubscription callStreamSubscription;

  @override
  void initState() {
    super.initState();
    addPostFrameCallBack(); // to disable all end call screens
  }

  addPostFrameCallBack() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);

      callStreamSubscription = callMethods
          .callStream(uid: userProvider.getUsers.uid)
          .listen((DocumentSnapshot ds) {
        switch (ds.data) {
          case null:
            //documents are deleted and call hang, so pop out of this screen.
            Navigator.pop(context);
            break;

          default:
            Navigator.pushNamed(context, DefVisualScreen.id);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.cyan.shade50,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Hero(
              tag: 'text',
              child: Text(
                "Ligação efetuada",
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            MaterialButton(
              color: Colors.red,
              child: Icon(
                Icons.call_end,
                color: Colors.white,
                semanticLabel: 'Finalizar Ligação',
                size: 50,
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              onPressed: () {
                callMethods.endCall(call: widget.call);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    ));
  }
}
