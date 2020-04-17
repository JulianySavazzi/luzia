import 'package:luzia/utils/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:luzia/model/users.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<FirebaseUser> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<FirebaseUser> signIn() => _firebaseMethods.signIn();

  Future<FirebaseUser> loginWithFacebook() =>
      _firebaseMethods.loginWithFacebook();

  // adding the same method in firebase repository as well
  Future<Users> getUserDetails(String uid) =>
      _firebaseMethods.getUserDetails(uid);

  Future<bool> authenticateUser(FirebaseUser user) =>
      _firebaseMethods.authenticateUser(user);

  Future<void> addDataToDb(FirebaseUser user) =>
      _firebaseMethods.addDataToDb(user);

  //Adicionando tipo
  Future<void> addType(FirebaseUser user, String tipo, int ajuda) =>
      _firebaseMethods.addType(user, tipo, ajuda);

  Future<List<Users>> searchAllVolunteers(FirebaseUser currentUser) =>
      _firebaseMethods.searchAllVolunteers(currentUser);

  Future<List<Users>> getMaxHelp() => _firebaseMethods.getMaxHelp();
}
