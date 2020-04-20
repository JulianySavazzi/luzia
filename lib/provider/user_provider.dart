import 'package:flutter/material.dart';
import 'package:luzia/model/users.dart';
import 'package:flutter/widgets.dart';
import 'package:luzia/utils/firebase_repository.dart';

class UserProvider with ChangeNotifier {
  Users _user;
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  Users get getUsers => _user;

  void refreshUser() async {
    Users user = await _firebaseRepository.getUser();
    _user = user;
    notifyListeners();
  }
}
