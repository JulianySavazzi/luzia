import 'package:firebase_auth/firebase_auth.dart';
import 'package:luzia/model/users.dart';
import 'package:luzia/utils/firebase_methods.dart';

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

  //Add type for user
  Future<void> addType(FirebaseUser user, String tipo, int ajuda, int tentativa,
          String token) =>
      _firebaseMethods.addType(user, tipo, ajuda, tentativa, token);

  //Update variable tentativa
  Future<void> addTries(FirebaseUser currentUser, int tentativa) =>
      _firebaseMethods.addTries(currentUser, tentativa);

  Future<List<Users>> searchVolunteers() => _firebaseMethods.searchVolunteers();

  Future<Users> getUser() => _firebaseMethods.getUser();

  Future<Users> getHelpCurrentUser(Users voluntario) =>
      _firebaseMethods.getHelpCurrentUser(voluntario);

  Future<List<Users>> getVolunteers() => _firebaseMethods.getVolunteers();

  //don't use

  //  Future<List<Users>> getMaxHelp() => _firebaseMethods.getMaxHelp();

  // Future<List<Users>> flagVolunteerJoinACall() =>
  //     _firebaseMethods.flagVolunteerJoinACall();

  // Future<List<Users>> flagVolunteerLeaveACall() =>
  //     _firebaseMethods.flagVolunteerLeaveACall();
}
