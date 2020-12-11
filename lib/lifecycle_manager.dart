// import 'package:flutter/material.dart';
// import 'package:luzia/services/background_fetch_service.dart';
// import 'package:luzia/services/location_service.dart';
// import 'package:luzia/services/stoppable_service.dart';
//
// import 'locator.dart';
//
// class LifeCycleManager extends StatefulWidget {
//   final Widget child;
//   LifeCycleManager({Key key, this.child}) : super(key: key);
//
//   _LifeCycleManagerState createState() => _LifeCycleManagerState();
// }
//
// class _LifeCycleManagerState extends State<LifeCycleManager>
//     with WidgetsBindingObserver {
//   List<StoppableService> servicesToManage = [
//     locator<LocationService>(),
//     locator<BackGroundFetchService>(),
//   ];
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     servicesToManage.forEach((service) {
//       if (state == AppLifecycleState.resumed) {
//         service.start();
//       } else {
//         service.stop();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: widget.child,
//     );
//   }
// }
