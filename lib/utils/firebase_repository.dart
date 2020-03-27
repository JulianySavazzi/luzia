import 'package:luzia/utils/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<FirebaseUser> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<FirebaseUser> signIn() => _firebaseMethods.signIn();

  Future<bool> authenticateUser(FirebaseUser user) =>
      _firebaseMethods.authenticateUser(user);

  Future<void> addDataToDb(FirebaseUser user) =>
      _firebaseMethods.addDataToDb(user);

  //Adicionando tipo
  Future<void> addVolunteer(FirebaseUser user) =>
      _firebaseMethods.addVolunteer(user);

  Future<void> addDv(FirebaseUser user) => _firebaseMethods.addDv(user);

  Future<void> searchVolunteer(FirebaseUser user) =>
      _firebaseMethods.searchVolunteer(user);
}
