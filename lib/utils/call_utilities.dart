import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:luzia/call_views/call_screen.dart';
import 'package:luzia/constants/strings.dart';
import 'package:luzia/model/call.dart';
import 'package:luzia/model/users.dart';
import 'package:random_string/random_string.dart';

import 'call_methods.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();
  final CollectionReference callCollection =
      Firestore.instance.collection(CALL_COLLECTION);
  Stream<DocumentSnapshot> callStream({String uid}) =>
      callCollection.document(uid).snapshots();

  // String callerId;
  // String callerName;
  // String receiverId;
  // String receiverName;
  // String channelId;
  // bool hasDialled;
  // bool accepted;
  // bool rejected;

  static dial({Users from, Users to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.nome,
      receiverId: to.uid,
      receiverName: to.nome,
      channelId: randomAlphaNumeric(10),
    );

    call.rejected = false;
    call.accepted = false;

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      // call.accepted = true;
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(call: call),
          ));
     }
    // else {
    //   // call.rejected = true;
    // }
  }
}
