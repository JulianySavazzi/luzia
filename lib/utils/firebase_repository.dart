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
  Future<void> addType(
          FirebaseUser user, String tipo, int ajuda, String token) =>
      _firebaseMethods.addType(user, tipo, ajuda, token);

  Future<List<Users>> searchVolunteers() => _firebaseMethods.searchVolunteers();

//  Future<List<Users>> getMaxHelp() => _firebaseMethods.getMaxHelp();

  Future<Users> getUser() => _firebaseMethods.getUser();

  Future<Users> getHelpCurrentUser(Users voluntario) =>
      _firebaseMethods.getHelpCurrentUser(voluntario);

  Future<List<Users>> getVolunteers() => _firebaseMethods.getVolunteers();

  Future<List<Users>> flagVolunteerJoinACall(Users v) =>
      _firebaseMethods.flagVolunteerJoinACall(v);

  Future<List<Users>> flagVolunteerLeaveACall(Users v) =>
      _firebaseMethods.flagVolunteerLeaveACall(v);

}
