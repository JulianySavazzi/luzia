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
  //animações
  final CallMethods callMethods = CallMethods();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.cyan.shade50,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Hero(
              tag: 'text',
              child: Text(
                "Ligação efetuada",
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            MaterialButton(
              color: Colors.red,
              child: Icon(
                Icons.call_end,
                color: Colors.white,
                semanticLabel: 'Finalizar Ligação',
                size: 50,
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
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
