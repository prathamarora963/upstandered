
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;
  final AsyncCallback suspendingCallBack;
  final AsyncCallback inactiveCallBack;
  final AsyncCallback pausedCallBack;
  final AsyncCallback detachedCallBack;

  LifecycleEventHandler({
    this.inactiveCallBack, 
    this.pausedCallBack, 
    this.detachedCallBack,
    this.resumeCallBack,
    this.suspendingCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) {
          await resumeCallBack();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (suspendingCallBack != null) {
          await suspendingCallBack();
        }
        break;
    }
  }
}

callLifeCycleEvents(){
    WidgetsBinding.instance
        .addObserver(LifecycleEventHandler(resumeCallBack: () async {
      print("resumeCallBack");
      Fluttertoast.showToast(msg: "resumeCallBack");
      
    }, suspendingCallBack: () async {
      print("suspendingCallBack");
      Fluttertoast.showToast(msg: "suspendingCallBack");
     
    }, inactiveCallBack: () async {
      print("inactiveCallBack");
      Fluttertoast.showToast(msg: "inactiveCallBack");
      
    }, pausedCallBack: () async {
      print("pausedCallBack");
      Fluttertoast.showToast(msg: "pausedCallBack");
     
    }, detachedCallBack: () async {
      print("detachedCallBack");
      Fluttertoast.showToast(msg: "detachedCallBack");
      
    }));
  }
