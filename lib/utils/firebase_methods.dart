import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:luzia/model/users.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore firestore = Firestore.instance;


  //Users class
  Users user = Users();
  
  //CurrentUser
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }
  
  // Adding this method to retrieve user details from firebase using just uid
  Future<Users> getUserDetails(String uid) async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection("users").document(uid).get();
    return Users.fromMap(documentSnapshot.data);
  }

  //Google Sign-in
  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: _signInAuthentication.accessToken,
        idToken: _signInAuthentication.idToken);

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    return user;
  }

  //Facebook Sig-in
  Future<FirebaseUser> loginWithFacebook() async {
    var facebookLogin = FacebookLogin();
    var result = await facebookLogin.logIn(['email']);

    debugPrint(result.status.toString());//ver status do login

    if(result.status == FacebookLoginStatus.loggedIn){
      final AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);
      FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      return user;
    }
    return null;
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    user = Users(
      uid: currentUser.uid,
      nome: currentUser.displayName,
      email: currentUser.email,
      tipo: user.tipo,
      photo: currentUser.photoUrl,
      ajuda: user.ajuda,
    );

    firestore
        .collection("users")
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  //Adicionando tipo ao usuário
  Future<void> addVolunteer(FirebaseUser currentUser) async {
    user = Users(
      uid: currentUser.uid,
      nome: currentUser.displayName,
      email: currentUser.email,
      tipo: "V",
      photo: currentUser.photoUrl,
      ajuda: 0,
    );
    firestore
        .collection("users")
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  Future<void> addDv(FirebaseUser currentUser) async {
    user = Users(
      uid: currentUser.uid,
      nome: currentUser.displayName,
      email: currentUser.email,
      tipo: "D",
      photo: currentUser.photoUrl,
      ajuda: user.ajuda,
    );
    firestore
        .collection("users")
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  //NAO SEI SE FUNCIONA
  Future<void> searchVolunteer(FirebaseUser currentUser) async {
    QuerySnapshot querySnapshot = await firestore
        .collection("users")
        .where("tipo", isEqualTo: "V")
        .getDocuments();
    return querySnapshot;
  }
}
