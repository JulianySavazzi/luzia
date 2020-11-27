import 'dart:async';
import 'dart:io';
import 'dart:math';
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
//import 'package:torch_compat/torch_compat.dart';

final FirebaseRepository _repository = FirebaseRepository();
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
final usersRef = Firestore.instance.collection('users');

List<Users> volunteers;
List<Users> volunteersAcceptedCall;
List<Users> volunteersRejectedCall;
int atendeu;
Users oneVolunteer = Users();

class CallScreen extends StatefulWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();
  //final bool isDv;

  CallScreen({@required this.call});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallMethods callMethods = CallMethods();
  final StopWatchTimer _stopWatchTimer =
      StopWatchTimer(); // Create instance for timer
  // var timeStrings = <String>[];
  var time;

  //send notification to selected volunteer
  getToken() async {
    FirebaseUser user = await _repository.getCurrentUser();
    _firebaseMessaging.getToken().then((token) {
      print("FCM Messaging token: $token\n");
      usersRef.document(user.uid).updateData({'token': token});
    });
  }

  //AGORA VARIABLES
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool camera = false;
  //bool flash = false; //try enable flash

  Stopwatch _stopwatch = Stopwatch();

  @override
  void dispose() async {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
    await _stopWatchTimer.dispose(); // for stopwatch timer
  }

  UserProvider userProvider;
  StreamSubscription callStreamSubscription;

  @override
  void initState() {
    super.initState();
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
          print('sender: ${sender.nome}');
          volunteers = list;
        });
      });
    });
    //get dispositive token
    getToken();
    // _stopwatch.start(); // init timer
    // print('timer: ${_stopwatch.toString()}');
    setState(() {
      atendeu = 0; //start variable
    });
    print('init state atendeu = $atendeu');
    _stopWatchTimer.onExecute.add(StopWatchExecute.start); // Start timer
    _stopWatchTimer.rawTime.listen((value) {
      time = StopWatchTimer.getDisplayTime(value);
      // print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}');
      print('Time: $time');
    });
    addPostFrameCallBack(); // to disable all end call screens
    initializeAgora();
    searchAlgorithm(context); //search volunteer algorithm
  }

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
  }

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
  }

  /////////////////// search volunteer algorithm methods ///////////////////////

  //Select random volunteer, and save chosen volunteer
  Users selectingVolunteers(Users volunteer) {
    final random = new Random();
    var i = random.nextInt(volunteers.length);
    volunteer = Users(
        uid: volunteers[i].uid,
        nome: volunteers[i].nome,
        ajuda: volunteers[i].ajuda,
        tipo: volunteers[i].tipo);
    oneVolunteer = volunteer;
    print("receiver_name = ");
    print(oneVolunteer.nome);
    return volunteer;
  }

  //flag volunteer join a call
  Future<Users> flagVolunteer() async {
    // get user receiver and add in oneVolunter in init state
    _repository.flagVolunteerJoinACall(oneVolunteer).then((List<Users> list) {
      volunteersAcceptedCall = list;
    });
    for (var i = 0; i < volunteersAcceptedCall.length; i++) {
      if (volunteersAcceptedCall[i].uid == oneVolunteer.uid) {
        //check if selected volunteer join a call
        setState(() {
          atendeu = 1; //volunteer join a call
          print('atendeu =  $atendeu');
        });
        print("Accepted Call ");
        print(volunteersAcceptedCall[i].nome);
        print("Selected volunteer ");
        print(oneVolunteer.nome);
        return oneVolunteer;
      } else {
        _repository
            .flagVolunteerLeaveACall(oneVolunteer)
            .then((List<Users> list) {
          volunteersRejectedCall = list;
        });
        setState(() {
          atendeu = 2; //volunteer end call
          print('atendeu =  $atendeu');
        });
        print("Rejected Call ");
        print(volunteersRejectedCall[i].nome);
        print("Selected volunteer ");
        print(oneVolunteer.nome);
        return oneVolunteer;
      }
    }
    print("Selected volunteer ");
    print(oneVolunteer.nome);
    return oneVolunteer;
  }

  callVolunteer(context) {
    try {
      print("TRY CALL VOLUNTEER");
      selectingVolunteers(oneVolunteer);
      print("oneVolunteer = ");
      print(oneVolunteer.nome);
      print("ajuda = ");
      print(oneVolunteer.ajuda);
      CallUtils.dial(from: sender, to: oneVolunteer, context: context);
      flagVolunteer();
      print("flagged volunteer");
      searchAlgorithm(context);
    } catch (error) {
      print("CALL VOLUNTEER CATCH");
      flagVolunteer();
      print("flagged volunteer");
      Fluttertoast.showToast(
          msg:
              "Nenhum voluntário estava disponível, tente novamente mais tarde... $error",
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.red[300],
          gravity: ToastGravity.CENTER);
    }
  }

  //METHOD FOR ENTERING A LOOP UNTIL A VOLUNTEER IS SELECTED
  searchAlgorithm(context) async {
    print("Entrou no searchAlgorithm");
    // do {
    //   print("Entrou no DO WHILE");
    tries = 0;
    print('tentativa: $tries');
    // print('timer start: $_stopwatch');
    print('atendeu = $atendeu');
    flagVolunteer();
    if (atendeu != 1 && tries < 6) {
      tries++;
      // print("Entrou no IF");
      // print('tentativa: $tries');
      // print('atendeu = $atendeu');
      // print('início do timer 10sec');
      // print('tentativa: $tries');
      callVolunteer(context);
      // sleep(Duration(seconds: 10));
      // selectingVolunteers(oneVolunteer);
      // print("oneVolunteer = ");
      // print(oneVolunteer.nome);
      // print("ajuda = ");
      // print(oneVolunteer.ajuda);
      // CallUtils.dial(from: sender, to: oneVolunteer, context: context);
      // flagVolunteer();
      // _stopwatch.stop();
      // searchAlgorithm(context);
    } else {
      if (atendeu == 2) {
        print("Entrou no IF 2");
        print('atendeu = $atendeu');
      } else {
        print("Entrou no ELSE");
        print('tentativa: $tries');
        Fluttertoast.showToast(
            msg: "Não foi possível encontrar um voluntário, tente novamente",
            toastLength: Toast.LENGTH_LONG,
            textColor: Colors.red[300],
            gravity: ToastGravity.CENTER);
        print('tentativa: $tries');
      }
    }
    print("SAIU DO IF");
    // } while (tries < 6);
    // print("SAIU DO WHILE");
    // tries = 0;
    // print('tentativa: $tries');
    // Fluttertoast.showToast(
    //     msg: "Não foi possível encontrar um voluntário, tente novamente",
    //     toastLength: Toast.LENGTH_LONG,
    //     textColor: Colors.red[300],
    //     gravity: ToastGravity.CENTER);
    // print('tentativa: $tries');
  }

  // void printDuration(){
  //   setState(() {
  //     final info = 'duração da chamada: $_stopwatch';
  //     _infoStrings.add(info);
  //   });
  // }

  /////////////////// close search volunteer algorithm methods ///////////////////////

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
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
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
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(0, local: true, preview: true),
    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

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
  }

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
  }

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
  }

  @override
  Widget build(BuildContext context) {
    tryCheckJoin();
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
  }

  void tryCheckJoin() {
    if (AgoraRtcEngine.onUserJoined == null) {
      print('Time: $time');
      print("onUserJoined: ");
      print(AgoraRtcEngine.onUserJoined);
      // Stop timer
      //_stopWatchTimer.onExecute.add(StopWatchExecute.stop);
      print('Time: $time');
    } else {
      print("Voluntário atendeu!");
    }
  }
}
