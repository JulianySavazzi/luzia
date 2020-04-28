import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:luzia/constants/strings.dart';
import 'package:luzia/model/users.dart';

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

  //Facebook Sig-in
  Future<FirebaseUser> loginWithFacebook() async {
    var facebookLogin = FacebookLogin();
    var result = await facebookLogin.logIn([EMAIL_FIELD]);

    debugPrint(result.status.toString()); //ver status do login

    if (result.status == FacebookLoginStatus.loggedIn) {
      final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token);
      FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      return user;
    }
    return null;
  }

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
    );

    firestore
        .collection(USERS_COLLECTION)
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  //Adicionando tipo ao usuário
  Future<void> addType(FirebaseUser currentUser, String tipo, int ajuda) async {
    user = Users(
      uid: currentUser.uid,
      nome: currentUser.displayName,
      email: currentUser.email,
      tipo: tipo,
      photo: currentUser.photoUrl,
      ajuda: ajuda,
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

  //Search max help number
  Future<List<Users>> getMaxHelp() async {
    final QuerySnapshot querySnapshot = await usersRef
        .where("tipo", isEqualTo: "V")
        .orderBy("ajuda", descending: true)
        .getDocuments(); //ordena a ajuda da maior para a menor
    //o primeiro voluntário que ele salva na lista é o que tem o número de ajuda maior
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      volunteerList.add(Users.fromMap(querySnapshot.documents[i].data));
      maxhelp = volunteerList[0].ajuda; //salva ajuda máxima na variável
      print('---------');
      print('ajuda máxima:'); //mostra ajuda máxima
      print(maxhelp); //mostra valor da ajuda máxima
      print('---------');
      print('voluntário:');
      print(volunteerList[i].nome);
      print(volunteerList[i].ajuda);
      print(volunteerList[i].tipo);
      print('---------');
    }
    return volunteerList;
  }

  //Search all Volunteers
  Future<List<Users>> searchAllVolunteers(FirebaseUser currentUser) async {
    final usersRef = Firestore.instance.collection(USERS_COLLECTION);
    List<Users> volunteerList = List<Users>();

    final QuerySnapshot querySnapshot = await usersRef
        .where("tipo", isEqualTo: "V")
        //.where("ajuda", isLessThan: maxhelp)
        .where("ajuda", isLessThan: 1)
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      volunteerList.add(Users.fromMap(querySnapshot.documents[i].data));
    }
    return volunteerList;
  }

  Future<List<Users>> getVolunteers() async {
    final usersRef = Firestore.instance.collection(USERS_COLLECTION);
    List<Users> volunteerList = List<Users>();

    final QuerySnapshot querySnapshot =
        await usersRef.where("tipo", isEqualTo: "V").getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      volunteerList.add(Users.fromMap(querySnapshot.documents[i].data));
    }
    return volunteerList;
  }
}
