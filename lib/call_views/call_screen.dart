import 'package:flutter/material.dart';
import 'package:luzia/model/call.dart';
import 'package:luzia/utils/call_methods.dart';

class CallScreen extends StatefulWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();

  CallScreen({
    @required this.call,
  });

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallMethods callMethods = CallMethods();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Ligação efetuada"),
            MaterialButton(
              color: Colors.red,
              child: Icon(Icons.call_end, color: Colors.white),
              onPressed: () {
                callMethods.endCall(call: widget.call);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    ));
  }
}
