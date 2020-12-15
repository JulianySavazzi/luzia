import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luzia/constants/strings.dart';
import 'package:luzia/model/call.dart';

class CallMethods {
  final CollectionReference callCollection =
  Firestore.instance.collection(CALL_COLLECTION);

  Stream<DocumentSnapshot> callStream({String uid}) =>
      callCollection.document(uid).snapshots();

  //Função para realizar a ligação, aqui deve ser inserido o algoritmo
  Future<bool> makeCall({Call call}) async {
    try {
      //DV
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      //V
      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      //Popula documento do DV = HASDIALLED
      await callCollection.document(call.callerId).setData(hasDialledMap);

      //Popula documento do V = HASNOTDIALLED
      await callCollection.document(call.receiverId).setData(hasNotDialledMap);

      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  //Função para deletar os documentos daquela ligação;
  Future<bool> endCall({Call call}) async {
    try {
      Fluttertoast.showToast(
          msg: "Chamada encerrada!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
      await callCollection.document(call.callerId).delete();
      await callCollection.document(call.receiverId).delete();
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }
}