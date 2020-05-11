import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luzia/locator.dart';
import 'package:luzia/model/users.dart';
import 'package:luzia/provider/user_provider.dart';
import 'package:luzia/utils/firebase_repository.dart';
import 'package:luzia/views/dv_screen.dart';
import 'package:luzia/views/login_screen.dart';
import 'package:luzia/views/users_screen.dart';
import 'package:luzia/views/v_screen.dart';
import 'package:provider/provider.dart';

import 'lifecycle_manager.dart';

void main() {
  setupLocator();
  runApp(LuziaApp());
}

class LuziaApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<LuziaApp> {
  FirebaseRepository _repository = FirebaseRepository();
  FirebaseMessaging _fcm = FirebaseMessaging();
  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Users user;
  Firestore firestore;
  //resultado do voluntario
  bool result = false;

  //Verify user type
  Future<Users> userDetails(firebaseUser) async {
    // retrieving User details
    user = await _repository.getUserDetails(firebaseUser.uid);
    if (user.tipo == "V") {
      setState(() {
        result = true; //voluntário
      });
    } else {
      setState(() {
        result = false; //deficiente visual
      });
    }
    return user;
  }

  @override
  //FUNCTIONS TO HANDLE NOTIFICATIONS
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings(alert: true, badge: true, sound: true));
    }
    _fcm.configure(
      onLaunch: (Map<String, dynamic> message) async {},
      onResume: (Map<String, dynamic> message) async {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
        child: ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(),
            child: MaterialApp(
              title: 'Luzia',
              home: FutureBuilder(
                  future: _repository.getCurrentUser(),
                  builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                    if (snapshot.hasData) {
                      // initializing firebase user
                      FirebaseUser firebaseUser = snapshot.data;
                      //retrieving User details
                      userDetails(firebaseUser);
                      // This line is responsible for checking the user type and returning the nced
                      return result == true
                          ? VoluntarioScreen()
                          : DefVisualScreen();
                    } else {
                      return LoginScreen();
                    }
                  }),
              theme: ThemeData(
                primaryColor: Colors.cyan,
              ),
              routes: {
                LoginScreen.id: (context) => LoginScreen(),
                UsersScreen.id: (context) => UsersScreen(),
                DefVisualScreen.id: (context) => DefVisualScreen(),
                VoluntarioScreen.id: (context) => VoluntarioScreen(),
              },
            )));
  }
}
