import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:luzia/constants/strings.dart';
import 'package:luzia/model/users.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore firestore = Firestore.instance;
  Users oneVolunteer;
  List<Users> volunteerList = List<Users>();
  Users volunteer = Users();
  final usersRef = Firestore.instance.collection(USERS_COLLECTION);
  int maxhelp;
  int currentUserHelp;
  Users voluntario;

  //Users class
  Users user = Users();

  //CurrentUser
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<Users> getUser() async {
    FirebaseUser currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
        await usersRef.document(currentUser.uid).get();

    return Users.fromMap(documentSnapshot.data);
  }

  // Adding this method to retrieve user details from firebase using just uid
  Future<Users> getUserDetails(String uid) async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection(USERS_COLLECTION).document(uid).get();
    return Users.fromMap(documentSnapshot.data);
  }

  //Google Sign-in
  Future<FirebaseUser> signIn() async {
    try {
      GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication _signInAuthentication =
          await _signInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: _signInAuthentication.accessToken,
          idToken: _signInAuthentication.idToken);

      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;

      return user;
    } catch (error) {
      print(error);
    }
    return null;
  }

  // //Facebook Sig-in
  // Future<FirebaseUser> loginWithFacebook() async {
  //   var facebookLogin = FacebookLogin();
  //   var result = await facebookLogin.logIn([EMAIL_FIELD]);

  //   debugPrint(result.status.toString()); //ver status do login

  //   if (result.status == FacebookLoginStatus.loggedIn) {
  //     final AuthCredential credential = FacebookAuthProvider.getCredential(
  //         accessToken: result.accessToken.token);
  //     FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
  //     return user;
  //   }
  //   return null;
  // }

  //Autenticação de usuário
  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    return docs.length == 0 ? true : false;
  }

  //Salvando usuário no banco de dados
  Future<void> addDataToDb(FirebaseUser currentUser) async {
    user = Users(
      uid: currentUser.uid,
      nome: currentUser.displayName,
      email: currentUser.email,
      tipo: user.tipo,
      photo: currentUser.photoUrl,
      ajuda: user.ajuda,
      tentativa: user.tentativa,
    );

    firestore
        .collection(USERS_COLLECTION)
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  //Adicionando tipo ao usuário
  Future<void> addType(FirebaseUser currentUser, String tipo, int ajuda,
      int tentativa, String token) async {
    user = Users(
      uid: currentUser.uid,
      nome: currentUser.displayName,
      email: currentUser.email,
      tipo: tipo,
      photo: currentUser.photoUrl,
      ajuda: ajuda,
      tentativa: tentativa,
      token: token,
    );
    firestore
        .collection(USERS_COLLECTION)
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  //Pegar ajuda do voluntário logado (currentUser)
  Future<Users> getHelpCurrentUser(Users voluntario) async {
    //Users currentUser = await getUser();
    voluntario = await getUser();
    currentUserHelp = voluntario.ajuda;
    print(currentUserHelp);
    print(voluntario.email);
    return voluntario;
  }

  //Search Volunteers
  Future<List<Users>> searchVolunteers() async {
    // final usersRef = Firestore.instance.collection(USERS_COLLECTION);
    List<Users> volunteerList = List<Users>();
    // populate volunteer list for priorize volunteers who don't helped
    QuerySnapshot querySnapshot = await usersRef
        .where("tipo", isEqualTo: "V")
        .where("ajuda", isEqualTo: 0)
        .where("tentativa", isLessThan: 2)
        .getDocuments(); // get volunteers with variable ajuda = 0 and variable tentativa < 2
    //priorize volunteer who never help
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      // add volunteer in list
      volunteerList.add(Users.fromMap(querySnapshot.documents[i].data));
    }
    //if volunteer's list is null
    if (volunteerList.length == 0) {
      // if don't volunteers with variable ajuda = 0 and variable tentativa < 3
      QuerySnapshot querySnapshot = await usersRef
          .where("tipo", isEqualTo: "V")
          .where("tentativa", isLessThan: 2)
          .getDocuments(); // get all volunteers with variable tentativa < 2 and add in volunteer list
      for (var i = 0; i < querySnapshot.documents.length; i++) {
        volunteerList.add(Users.fromMap(querySnapshot.documents[i].data));
      }
      //if volunteer's list is null
      if (volunteerList.length == 0) {
        QuerySnapshot querySnapshot = await usersRef
            .where("tipo", isEqualTo: "V")
            .where("ajuda", isLessThan: 1)
            .getDocuments(); // get all volunteers with variable ajuda = 0, add in volunteer list
        //priorize volunteer who never help
        for (var i = 0; i < querySnapshot.documents.length; i++) {
          volunteerList.add(Users.fromMap(querySnapshot.documents[i].data));
        }
        //if volunteer's list is null
        if (volunteerList.length == 0) {
          QuerySnapshot querySnapshot = await usersRef
              .where("tipo", isEqualTo: "V")
              .getDocuments(); // get all volunteers, add in volunteer list
          //priorize volunteer who never help
          for (var i = 0; i < querySnapshot.documents.length; i++) {
            volunteerList.add(Users.fromMap(querySnapshot.documents[i].data));
          }
          return volunteerList;
        }
        return volunteerList;
      }
      return volunteerList;
    }
    return volunteerList; // return volunteer list
  } // searchVolunteers

  Future<List<Users>> getVolunteers() async {
    // get all volunteers
    // final usersRef = Firestore.instance.collection(USERS_COLLECTION);
    List<Users> volunteerList = List<Users>();

    final QuerySnapshot querySnapshot =
        await usersRef.where("tipo", isEqualTo: "V").getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      volunteerList.add(Users.fromMap(querySnapshot.documents[i].data));
    }
    return volunteerList;
  }
}
