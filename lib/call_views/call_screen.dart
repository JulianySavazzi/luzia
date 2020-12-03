import 'dart:async';
import 'package:luzia/utils/firebase_methods.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:luzia/model/call.dart';
import 'package:luzia/model/users.dart';
import 'package:luzia/provider/user_provider.dart';
import 'package:luzia/utils/call_methods.dart';
import 'package:luzia/utils/call_utilities.dart';
import 'package:luzia/utils/firebase_repository.dart';
import 'package:luzia/utils/settings.dart';
import 'package:luzia/views/dv_screen.dart';
import 'package:provider/provider.dart';
import 'package:luzia/constants/strings.dart';

final FirebaseRepository _repository = FirebaseRepository();
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
final usersRef = Firestore.instance.collection('users');

List<Users> volunteers;
List<Users> volunteersAcceptedCall;
List<Users> volunteersRejectedCall;
bool atendeu = false;
Users oneVolunteer = Users();
int tentativas = 0;

class CallScreen extends StatefulWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();

  CallScreen({@required this.call});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallMethods callMethods = CallMethods();
  final StopWatchTimer _stopWatchTimer =
      StopWatchTimer(); // Create instance for timer
  var time;

  //send notification to selected volunteer
  getToken() async {
    FirebaseUser user = await _repository.getCurrentUser();
    _firebaseMessaging.getToken().then((token) {
      print("FCM Messaging token: $token\n");
      usersRef.document(user.uid).updateData({'token': token});
    });
  } // getToken

  //AGORA VARIABLES
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool camera = false;
  //bool flash = false; //try enable flash

  @override
  void dispose() async {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
    await _stopWatchTimer.dispose(); // for stopwatch timer
  } // dispose

  UserProvider userProvider;
  StreamSubscription callStreamSubscription;

  @override
  void initState() {
    super.initState();
    print("/// INIT STATE CALL SCREEN ///");
    //Add UsersProviders refresh, using this to
    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshUser();
    });
    _repository.getCurrentUser().then((FirebaseUser currentUser) {
      _repository.searchVolunteers().then((List<Users> list) {
        setState(() {
          sender = Users(
            uid: currentUser.uid,
            nome: currentUser.displayName,
          );
          print(' /// call screen - sender: ${sender.nome} /// ');
          volunteers = list;
        });
      });
    });
    getToken(); //get dispositive token
    _stopWatchTimer.onExecute.add(StopWatchExecute.start); // Start timer
    _stopWatchTimer.rawTime.listen((value) {
      // print timer
      time = StopWatchTimer.getDisplayTime(value);
      print('Time: $time');
    });
    addPostFrameCallBack(); // to disable all end call screens
    initializeAgora();
  } //initState

  Future<void> initializeAgora() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.joinChannel(null, widget.call.channelId, null, 0);
  } // initializeAgora

  addPostFrameCallBack() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);

      callStreamSubscription = callMethods
          .callStream(uid: userProvider.getUsers.uid)
          .listen((DocumentSnapshot ds) {
        switch (ds.data) {
          case null:
            //documents are deleted and call hang, so pop out of this screen.
            Navigator.pop(context);
            break;

          default:
            break;
        }
      });
    });
  } // addPostFrameCallBack

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      // override static final method
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
      if (uid != null && elapsed != null) {
        setState(() {
          atendeu = true;
        });
        return atendeu;
      } else {
        return atendeu;
      }
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      callMethods.endCall(call: widget.call);
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
  } // _addAgoraEventHandlers

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
  } // _initAgoraRtcEngine

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  } // _onToggleMute

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  } // _onSwitchCamera

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(0, local: true, preview: true),
    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  } //_getRenderViews

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  } //_videoView

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  } //_expandedVideoRow

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            //_expandedVideoRow([views[0]]), //show myself
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  } // _viewRows

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => callMethods.endCall(call: widget.call),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              camera ? Icons.camera_rear : Icons.camera_front,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
        ],
      ),
    );
  } // _toolbar

  /////////////////// REMOVE AFTER GENERATING APK //////////////////////
  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  } // _panel

  @override
  Widget build(BuildContext context) {
    print("BUILD CALL");
    tryCheckJoin();
    incrementTries();
    print("////// ENTRANDO NO RETURN DO BUILD CALL //////");
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Center(
                child: Stack(
              children: <Widget>[
                _viewRows(),
                _panel(),
                _toolbar(),
              ],
            ))));
  } //build

  //// for search volunteer algorithm ////

  void tryCheckJoin() {
    print("////// ENTRANDO NO tryCheckJoin //////");
    if (atendeu == true) {
      _stopWatchTimer.onExecute.add(StopWatchExecute.stop); // Stop timer
      print("/// VOLUNTÁRIO ATENDEU ///");
      print("onUserJoined: $atendeu");
      print("/// VOLUNTÁRIO ATENDEU ///");
    } else {
      print("//// entrou no ELSE ////");
      print("onUserJoined: $atendeu");
      _stopWatchTimer.rawTime.listen((value) {
        // count 10 seconds
        time = StopWatchTimer.getDisplayTime(value);
        print('TIME TO STRING: ${time.toString()}');
        if (time.toString() == "00:00:10.00" ||
            time.toString() == "00:00:10.01" ||
            time.toString() == "00:00:10.02" ||
            time.toString() == "00:00:10.03" ||
            time.toString() == "00:00:10.04" ||
            time.toString() == "00:00:10.05" ||
            time.toString() == "00:00:10.06" ||
            time.toString() == "00:00:10.07" ||
            time.toString() == "00:00:10.08" ||
            time.toString() == "00:00:10.09" ||
            time.toString() == "00:00:10.10" ||
            time.toString() == "00:00:10.11" ||
            time.toString() == "00:00:10.12" ||
            time.toString() == "00:00:10.13" ||
            time.toString() == "00:00:10.14" ||
            time.toString() == "00:00:10.15" ||
            time.toString() == "00:00:10.16" ||
            time.toString() == "00:00:10.17" ||
            time.toString() == "00:00:10.18" ||
            time.toString() == "00:00:10.19" ||
            time.toString() == "00:00:10.20") {
          _stopWatchTimer.onExecute.add(StopWatchExecute.stop); // Stop timer
          print("onUserJoined: ${AgoraRtcEngine.onUserJoined}");
          print("STOP TIMER! $time");
          print("////// TIMER 10 SEGUNDOS! //////");
          print("Voluntário NÂO atendeu!");
          print("onUserJoined: ");
          print(AgoraRtcEngine.onUserJoined);
          CallUtils.callMethods.endCall(call: widget.call);
          Fluttertoast.showToast(
              msg: "O voluntário selecionado não estava disponível...",
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.yellowAccent[100],
              gravity: ToastGravity.CENTER);
          print("Encerra chamada");
        }
      });
      print("////// SAIU DO STOPWATCHTIMER //////");
      print("////////// fim / if //////////");
    } // stopwatchetimer
  } // tryCheckJoin()

  //Increment tries for user
  void incrementTries() {
    _repository.getCurrentUser().then((FirebaseUser user) async {
      //get current user
      if (user != null) {
        //current user is not null
        Users u = await _repository
            .getUserDetails(user.uid); // users map receive firebase user
        tentativas = u.tentativa;
        saveTries(user,
            tentativas); //incremented tries for current dv in database or set tries to 0
      } else {
        Fluttertoast.showToast(
            msg: "Houve um erro",
            toastLength: Toast.LENGTH_LONG,
            textColor: Colors.red[300],
            gravity: ToastGravity.BOTTOM);
      }
    });
  }

  saveTries(FirebaseUser currentUser, int tentativas) {
    if (atendeu == true) {
      //volunteer join a call
      if(currentUser.uid == widget.call.receiverId){
        //volunteer
      }else {
        //set dv tries to 0 -> tentativa = 0
        Users user = Users(
          uid: currentUser.uid,
          nome: currentUser.displayName,
          email: currentUser.email,
          photo: currentUser.photoUrl,
          tipo: 'D',
          ajuda: null,
          tentativa: 0,
        );
        FirebaseMethods.firestore
            .collection(USERS_COLLECTION)
            .document(currentUser.uid)
            .setData(user.toMap(user));
      }
    } else {
      //volunteer decline call
     if(currentUser.uid == widget.call.receiverId){
       //volunteer
     } else {
       //increment dv tries -> tentativa = tentativas++
       Users user = Users(
         uid: currentUser.uid,
         nome: currentUser.displayName,
         email: currentUser.email,
         photo: currentUser.photoUrl,
         tipo: 'D',
         ajuda: null,
         tentativa: tentativas + 1,
       );
       FirebaseMethods.firestore
           .collection(USERS_COLLECTION)
           .document(currentUser.uid)
           .setData(user.toMap(user));
     }
    }
  } //saveTries

  ////// end methods for search volunteer algorithm //////

} // _CallScreenState
