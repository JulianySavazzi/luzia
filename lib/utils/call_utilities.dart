import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luzia/constants/strings.dart';
import 'package:luzia/model/call.dart';
import 'package:luzia/model/users.dart';
import 'package:random_string/random_string.dart';

Call call;

class CallUtils {
  final CollectionReference callCollection =
      Firestore.instance.collection(CALL_COLLECTION);
  Stream<DocumentSnapshot> callStream({String uid}) =>
      callCollection.document(uid).snapshots();

  Future<Call> dial({Users from, Users to, context}) async {
    call = Call(
      callerId: from.uid,
      callerName: from.nome,
      receiverId: to.uid,
      receiverName: to.nome,
      channelId: randomAlphaNumeric(10),
    );
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);
      //CREATE CALL DOCUMENT
      await callCollection.document(call.callerId).setData(hasDialledMap);
      return call;
    } on Exception catch (e) {
      print(e);
      return call;
    }
  }

//  //DELETE CALL
  Future<bool> endCall({Call call}) async {
    try {
      await callCollection.document(call.callerId).delete();
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }
}

//  dial({Users from, Users to, context}) async {
//    Call call = Call(
//      callerId: from.uid,
//      callerName: from.nome,
//      receiverId: to.uid,
//      receiverName: to.nome,
//      channelId: randomAlphaNumeric(10),
//    );
//
//    try {
//      call.hasDialled = true;
//      Map<String, dynamic> hasDialledMap = call.toMap(call);
//
////      call.hasDialled = false;
////      Map<String, dynamic> hasNotDialledMap = call.toMap(call);
//
//      //Popula documento do DV = HASDIALLED
//      await callCollection.document(call.callerId).setData(hasDialledMap);
//
////      //Popula documento do V = HASNOTDIALLED
////      await callCollection.document(call.receiverId).setData(hasNotDialledMap);
//
//      return true;
//    } on Exception catch (e) {
//      print(e);
//      return false;
//    }
//    //bool callMade = await callMethods.makeCall(call: call);
//
////    call.hasDialled = true;
////
////    if (callMade) {
////      Navigator.push(
////          context,
////          MaterialPageRoute(
////            builder: (context) => CallScreen(call: call),
////          ));
//    }
