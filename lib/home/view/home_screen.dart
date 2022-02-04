import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/local/local_data_helper.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/bottom_button.dart';
import 'package:upstanders/common/widgets/dialogs.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';
import 'package:upstanders/home/bloc/alert_bloc.dart';
import 'package:upstanders/home/bloc/home_bloc.dart';
import 'package:upstanders/home/bloc/online_bloc.dart';
import 'package:upstanders/home/data/model/alert_data_model.dart';
import 'package:upstanders/home/data/model/profile_model.dart';
import 'package:upstanders/home/widgets/active_inactive.button.dart';
import 'package:upstanders/home/widgets/bottom_buttons.dart';
import 'package:upstanders/home/widgets/build_drawer.dart';
import 'package:upstanders/home/widgets/discreet_alert_description_screen.dart';
import 'package:upstanders/home/widgets/enter_pin_screen.dart';
import 'package:upstanders/home/view/map_screen.dart';
import 'package:upstanders/home/widgets/urgent_alert_description_screen.dart';
import 'package:upstanders/videos/view/videos_streaming_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

NotificationDataModel notificationDataModel = NotificationDataModel();
const theSource = AudioSource.microphone;

bool showLeave = false;
ProfileModel profileData = ProfileModel();
bool alertEndedNotified = false;
bool isAcceptedNotified = false;
LocalDataHelper localDataHelper = LocalDataHelper();
bool isCreatedAlert = false;
String alertId = '';
AlertBloc alertBloc;
BuildContext mapBlocContext;

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext contextt) {
    final size = MediaQuery.of(contextt).size;
    return MultiBlocProvider(
        providers: [
          BlocProvider<AlertBloc>(
            lazy: false,
            create: (context) => AlertBloc()..add(GetCurrentAlert()),
          ),
          BlocProvider<MapScreenBloc>(
            lazy: false,
            create: (context) => MapScreenBloc()..add(FetchProfileData()),
          ),
          BlocProvider<OnlineBloc>(
            lazy: false,
            create: (context) => OnlineBloc()..add(CheckUserOfflineOrNot()),
          ),
        ],
        child: BlocBuilder<MapScreenBloc, MapScreenState>(
          builder: (context, state) {
            mapBlocContext = context;
            if (state is FetchingProfileData) {
              Material(
                  child: Center(
                child: ProcessingIndicator(
                  size: size.height * 0.0015,
                ),
              ));
            }
            if (state is FetchingProfileDataFailure) {
              return Material(
                  child: Center(
                child: Text("$FetchingProfileDataFailure"),
              ));
            }
            profileData = BlocProvider.of<MapScreenBloc>(context).prof;
            context.read<MapScreenBloc>().add(UserLocationUpdated(contextt));

            // if (profileData.onlineStatus == 'online') {

            // }
            return _HomeView();
          },
        ));
  }
}

class _HomeView extends StatefulWidget {
  @override
  __HomeViewState createState() => __HomeViewState();
}

class __HomeViewState extends State<_HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ValueNotifier<bool> zoomNotifierActivation = ValueNotifier(false);
  ValueNotifier<bool> advPickerNotifierActivation = ValueNotifier(false);
  ValueNotifier<bool> trackingNotifier = ValueNotifier(false);
  bool isActive = false;
  LocalDataHelper localDataHelper = LocalDataHelper();
  Timer timer;
  Codec _codec = Codec.aacMP4;
  String _mPath = 'file.mp4';
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();

  bool _mRecorderIsInited = false;

  Timer _timer;
  int sec = 0;
  Duration duration = Duration();

  @override
  void initState() {
    super.initState();
    showAlertNotification();
    getAlertLastStatusData();
    BlocProvider.of<AlertBloc>(context).initializeValues();

    // if (!Platform.isAndroid) {
    //   _mRecorder.openAudioSession();
    // } else {
    //   openTheRecorder().then((value) {
    //     setState(() {
    //       _mRecorderIsInited = true;
    //     });
    //   });
    // }
  }

  _showMsg() async {
    Fluttertoast.showToast(
        msg:
            "audioFile:${await localDataHelper.getStringValue(key: AUDIO_FILE)}");
  }

  @mustCallSuper
  @protected
  void dispose() {
    // stopRecordings();
    BlocProvider.of<AlertBloc>(context).close();
    // timer?.cancel();

    // _mPlayer.closeAudioSession();
    // _mPlayer = null;
    // _mRecorder.closeAudioSession();
    // _mRecorder = null;
    super.dispose();
  }

  stopRecordings() async {
    if (!(await localDataHelper.getValue(key: IS_ALREADY_STOPPED_REC))) {
      _mRecorder.stopRecorder().then((value) {
        _timer.cancel();
        localDataHelper.saveStringValue(
            key: AUDIO_DURATION, value: _timer.tick.toString());
        localDataHelper.saveStringValue(key: AUDIO_FILE, value: value);
        localDataHelper.saveValue(key: IS_FILE_SAVED, value: true);
      });
    } else {
      localDataHelper.saveValue(key: IS_ALREADY_STOPPED_REC, value: false);
      _timer?.cancel();
    }
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder.openAudioSession();
    if (!await _mRecorder.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = 'file.webm';
      if (!await _mRecorder.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }
    _mRecorderIsInited = true;
  }

  getAlertLastStatusData() async {
    alertEndedNotified =
        await localDataHelper.getValue(key: ALERT_ENDED_NOTIFIED);
    isAcceptedNotified =
        await localDataHelper.getValue(key: IS_ACCEPTED_NOTIFIED);
    showLeave = await localDataHelper.getValue(key: SHOW_LEAVE);
    isCreatedAlert = await localDataHelper.getValue(key: IS_CREATE_ALERT);
    alertId = await localDataHelper.getStringValue(key: ALERT_ID);
    // Fluttertoast.showToast(msg: "$alertId");

    Map noti = jsonDecode(
        await localDataHelper.getStringValue(key: NOTIFICATION_DATA));
    notificationDataModel = NotificationDataModel.fromJson(noti);
  }

  showAlertNotification() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print("NOTIFICATIONNNNNNNNNN RESPONSE11${message.data}");
        callNotifications(message.data);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        if (message != null) {
          print("NOTIFICATIONNNNNNNNNN RESPONSE22${message.data}");
          callNotifications(message.data);
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message != null) {
        print("NOTIFICATIONNNNNNNNNN RESPONSE33${message.data}");
        callNotifications(message.data);
      }
    });
  }

  callNotifications(Map<String, dynamic> data) {
    notificationDataModel = NotificationDataModel.fromJson(data);
    print("NOTIFICATION  DATA ${notificationDataModel.toJson()}");

    String notificationData = jsonEncode(NotificationDataModel.fromJson(data));
    localDataHelper.saveStringValue(
        key: NOTIFICATION_DATA, value: notificationData);
    setState(() {
      alertId = notificationDataModel.alertId;
    });

    if (notificationDataModel.notificationType == "create-alert") {
      ///helper side
      localDataHelper.saveStringValue(key: ALERT_ID, value: alertId);

      if (notificationDataModel.type == 'discreet') {
        showDiscreetAlertReceived(
          context,
        );
      } else {
        showUrgentAlertReceived(
          context,
        );
      }
    } else if (notificationDataModel.notificationType == "accept") {
      // helpee side

      BlocProvider.of<MapScreenBloc>(context)
          .add(UpdateUserMarker(isAlertInCreatingMode: true));

      showNoti(context, "ACCEPTED YOUR ALERT");
    } else if (notificationDataModel.notificationType == "end") {
      //helper side
      localDataHelper.saveStringValue(key: ALERT_ID, value: '');

      BlocProvider.of<MapScreenBloc>(context)
          .add(UpdateUserMarker(isAlertInCreatingMode: false));

      if (mounted)
        setState(() {
          showLeave = false;
        });

      clearDataOnGettingEnded();

      showNotiForAlertEnded(context);
    } else if (notificationDataModel.notificationType == "leave") {
      // helpee side
      BlocProvider.of<MapScreenBloc>(context)
          .add(UpdateUserMarker(isAlertInCreatingMode: true));
      showNoti(context, "LEFT ALERT");
    }
  }

  clearDataOnGettingEnded() {
    localDataHelper.saveValue(key: SHOW_LEAVE, value: false);
    String notificationData = jsonEncode(NotificationDataModel.fromJson({}));
    localDataHelper.saveStringValue(
        key: NOTIFICATION_DATA, value: notificationData);
  }

  Future<bool> onPop() {
    print("POP");
    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => onPop(),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: BuildDrawer(),
        body: SafeArea(
            bottom: false,
            child: Container(
              child: Stack(
                children: [
                  MapScreen(),
                  _discreenAndUrgnetButton(context),
                  _buildDrawerBar(),
                  ActiveInActiveView()
                ],
              ),
            )),
        floatingActionButton: Align(
          alignment: Alignment(1, 0.8),
          child: InkWell(
              onTap: () => _animateCameraToCurrentLocation(),
              child: Image.asset(MY_LOCATION_ASSET,
                  height: size.height * 0.05, width: size.height * 0.05)),
        ),
      ),
    );
  }

  _animateCameraToCurrentLocation() {
    var controller = BlocProvider.of<MapScreenBloc>(context).mapController;
    Position currentLocation =
        BlocProvider.of<MapScreenBloc>(context).currentLocation;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 18.0,
        ),
      ),
    );
  }

  _discreenAndUrgnetButton(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter, child: _bottomView(context));
  }

  _buildDrawerBar() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, top: 8.0),
        child: IconButton(
            icon: Image.asset(SIDE_BAR_ASSET),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            }),
      ),
    );
  }

  void showUrgentAlertReceived(
    BuildContext context,
  ) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
            alignment: Alignment.center, child: _urgentAlertBlocView());
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  _urgentAlertBlocView() {
    final size = MediaQuery.of(context).size;

    return
        //  MultiBlocProvider(
        //   providers: [
        //     BlocProvider<AlertBloc>(
        //       lazy: false,
        //       create: (context) => AlertBloc(),
        //     ),
        //     BlocProvider<MapScreenBloc>(
        //       lazy: false,
        //       create: (context) => MapScreenBloc()..add(FetchProfileData()),
        //     ),

        //   ],
        BlocProvider.value(
      value: AlertBloc(),
      child: BlocListener<AlertBloc, AlertState>(listener: (context, state) {
        if (state.alertStatus == AlertStatus.acceptedAlert) {
          if (mounted) setState(() => showLeave = true);
          localDataHelper.saveValue(key: SHOW_LEAVE, value: true);
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UrgentAlertDescriptionScreen(
                    backButton: Container(),
                    bottomButton:
                        BottomButton(onTap: () => Navigator.of(context).pop()),
                  )));
          BlocProvider.of<MapScreenBloc>(mapBlocContext)
              .add(UpdateUserMarker(isAlertInCreatingMode: true));
        } else if (state.alertStatus == AlertStatus.alertAcceptaionFailed) {
          Fluttertoast.showToast(
            msg: "${state.res}",
          );
        }
      }, child: BlocBuilder<AlertBloc, AlertState>(builder: (context, state) {
        if (state.alertStatus == AlertStatus.acceptingAlert) {
          return Material(
            color: MyTheme.transparent,
            child: ProcessingIndicator(
              size: size.height * 0.0015,
            ),
          );
        }
        return IllAndIcantDialogBox(
          title: "URGENT",
          notificationDataModel: notificationDataModel,
          icant: () {
            Navigator.of(context).pop();
          },
          illgo: () {
            context
                .read<AlertBloc>()
                .add(AcceptAlert(notificationDataModel.alertId));
          },
          gradient: LinearGradient(colors: [
            MyTheme.urgentAlertGradientUp,
            MyTheme.urgentAlertGradientDown,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        );
      })),
    );
  }

  showDiscreetAlertReceived(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
            alignment: Alignment.center, child: _discreetAlertBlocView());
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  _discreetAlertBlocView() {
    final size = MediaQuery.of(context).size;
    return BlocProvider.value(
      value: AlertBloc(),
      // create: (context) => AlertBloc(),
      child: BlocListener<AlertBloc, AlertState>(listener: (context, state) {
        if (state.alertStatus == AlertStatus.acceptedAlert) {
          if (this.mounted) setState(() => showLeave = true);

          localDataHelper.saveValue(key: SHOW_LEAVE, value: true);
          BlocProvider.of<MapScreenBloc>(mapBlocContext)
              .add(UpdateUserMarker(isAlertInCreatingMode: true));
          if (showLeave && !alertEndedNotified) {
            print("TRUEEEEEEEEEEE SHOW LEAVE BUTTON");
          }

          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DiscreetAlertDescriptionScreen(
                    backButton: Container(),
                    bottomButton: BottomButton(onTap: () {
                      Navigator.of(context).pop();
                    }),
                  )));
        } else if (state.alertStatus == AlertStatus.alertAcceptaionFailed) {
          Fluttertoast.showToast(
            msg: "${state.res}",
          );
        }
      }, child: BlocBuilder<AlertBloc, AlertState>(builder: (context, state) {
        if (state.alertStatus == AlertStatus.acceptingAlert) {
          return Material(
            color: MyTheme.transparent,
            child: ProcessingIndicator(
              size: size.height * 0.0015,
            ),
          );
        }
        return IllAndIcantDialogBox(
          title: "DISCREET",
          notificationDataModel: notificationDataModel,
          gradient: LinearGradient(colors: [
            MyTheme.discreetAlertGradientUp,
            MyTheme.discreetAlertGradientDown
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          icant: () {
            Navigator.of(context).pop();
          },
          illgo: () {
            context
                .read<AlertBloc>()
                .add(AcceptAlert(notificationDataModel.alertId));
          },
        );
      })),
    );
  }

  _bottomView(BuildContext contextt) {
    final size = MediaQuery.of(context).size;
    return BlocListener<AlertBloc, AlertState>(
      listener: (alertcontext, state) {
        // Fluttertoast.showToast(msg: "${state.alertStatus}");
        if (state.alertStatus == AlertStatus.alertAcceptaionFailed ||
            state.alertStatus == AlertStatus.leavingAlertFailed) {
          _errorMsg(state);
        } else if (state.alertStatus == AlertStatus.alertCreationFailed) {
          showMsgDialog(context, state);
        } else if (state.alertStatus == AlertStatus.createdAlert) {
          BlocProvider.of<MapScreenBloc>(context)
              .add(UpdateUserMarker(isAlertInCreatingMode: true));
          if (this.mounted)
            setState(() {
              isAcceptedNotified = true;
              alertId = state.res['alert_id'].toString();
              isCreatedAlert = true;
            });
          // localDataHelper.saveValue(key: IS_ACCEPTED_NOTIFIED, value: true);
          // localDataHelper.saveStringValue(
          //     key: ALERT_ID, value: state.res['alert_id'].toString());

          // localDataHelper.saveValue(key: IS_CREATE_ALERT, value: true);
        } else if (state.alertStatus == AlertStatus.leavedAlert) {
          BlocProvider.of<MapScreenBloc>(context)
              .add(UserLocationUpdated(contextt));

          showLeave = false;
          localDataHelper.saveValue(key: SHOW_LEAVE, value: false);
          localDataHelper.saveStringValue(key: ALERT_ID, value: '');
          BlocProvider.of<MapScreenBloc>(mapBlocContext)
              .add(UpdateUserMarker(isAlertInCreatingMode: false));
        } else if (state.alertStatus == AlertStatus.endedAlert) {
          localDataHelper.saveStringValue(key: ALERT_ID, value: '');
          BlocProvider.of<MapScreenBloc>(contextt)
              .add(UserLocationUpdated(contextt));
          BlocProvider.of<MapScreenBloc>(context)
              .add(UpdateUserMarker(isAlertInCreatingMode: false));

          setState(() {
            isCreatedAlert = false;
            isAcceptedNotified = false;
            // alertId = '';
          });

          if (state.res['userCount']) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EnterPinCodeScreen(
                    alertId: alertId)));
          } else {
            localDataHelper.saveValue(key: IS_ACCEPTED_NOTIFIED, value: false);
            localDataHelper.saveValue(key: IS_CREATE_ALERT, value: false);
          }
        }
      },
      child: BlocBuilder<AlertBloc, AlertState>(
        builder: (context, state) {
          if (state.alertStatus == AlertStatus.createdAlert ||
              state.alertStatus == AlertStatus.endingAlertFailed) {
            // isAcceptedNotified

            return leaveOrEnd(context, size, title: "END ALERT",
                onEvent: () async {
              localDataHelper.saveValue(key: IS_CREATE_ALERT, value: false);
              context
                  .read<AlertBloc>()
                  .add(EndAlert(alertId, sec, this._timer, this._mRecorder));
            });
          }

          if (showLeave) {
            return leaveOrEnd(context, size, title: "LEAVE ALERT", onEvent: () {
              context
                  .read<AlertBloc>()
                  .add(LeaveAlert(notificationDataModel.alertId));
            });
          }

          return _bottomRowButton(context, state);
        },
      ),
    );
  }
}

showNoti(BuildContext context, String msg) {
  final size = MediaQuery.of(context).size;

  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 700),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(
              top: size.height * 0.05,
            ),
            child: NotificationDialogBox(
              notificationDataModel: notificationDataModel,
              notiMsg: msg,
              onHangUp: () => Navigator.pop(context),
              onRecieve: () {},
            ),
          ));
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim),
        child: child,
      );
    },
  );
}

showNotiForAlertEnded(BuildContext context) {
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 700),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
          alignment: Alignment.center,
          child: EndedAlertDialogBox(
            onContinue: () {
              Navigator.of(context).pop();
            },
            notificationDataModel: notificationDataModel,
          ));
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
        child: child,
      );
    },
  );
}

_errorMsg(AlertState state) {
  Fluttertoast.showToast(msg: "${state.res['message']}");
}

Widget _bottomRowButton(BuildContext context, AlertState state) {
  final size = MediaQuery.of(context).size;
  return Container(
      height: size.height * 0.07, // 55,
      child: state.alertStatus == AlertStatus.gotCurrentAlert ||
              state.alertStatus == AlertStatus.gettingCurrentAlertFailed ||
              state.alertStatus == AlertStatus.alertCreationFailed
          ? Row(
              children: [
                Expanded(child: _discreetButton(context)),
                Expanded(child: _urgentButton(context)),
              ],
            )
          : Center(
              child: ProcessingIndicator(
                size: size.height * 0.0015,
              ),
            ));
}

_discreetButton(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return InkWell(
    onTap: () async {
      print("_discreetButton CreateAlert");
      context.read<AlertBloc>().add(CreateAlert("discreet"));
    },
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        MyTheme.discreetAlertGradientUp,
        MyTheme.discreetAlertGradientDown
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Text(
        "DISCREET",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: size.height * 0.025, //18
            fontWeight: FontWeight.bold,
            color: MyTheme.secondryColor),
      ),
    ),
  );
}

_urgentButton(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return InkWell(
    onTap: () async {
      print("_urgentButton CreateAlert");
      context.read<AlertBloc>().add(CreateAlert("urgent"));
    },
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        MyTheme.urgentAlertGradientUp,
        MyTheme.urgentAlertGradientDown,
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Text(
        "URGENT",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: size.height * 0.025, //18
            fontWeight: FontWeight.bold,
            color: MyTheme.secondryColor),
      ),
    ),
  );
}

showDescriptionDialog(BuildContext context) {
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 700),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
          alignment: Alignment.center,
          child: ActiveInactiveDialogBox(
            onCancel: () {
              Navigator.of(context).pop();
            },
            onContinue: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VideosStreamingScreen()));
            },
          ));
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
        child: child,
      );
    },
  );
}

showMsgDialog(BuildContext context, AlertState state) {
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 700),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(
              top: 30,
            ),
            child: MessageDialogBox(
              message: "${state.res['message']}",
              onOkay: () {
                Navigator.of(context).pop();
              },
            ),
          ));
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim),
        child: child,
      );
    },
  );
}
