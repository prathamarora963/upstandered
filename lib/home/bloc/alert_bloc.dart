import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/local/local_data_helper.dart';
import 'package:upstanders/common/resource/file_resource.dart';
import 'package:upstanders/home/data/model/get_current_alert_model.dart';
import 'package:upstanders/common/repository/repository.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

part 'alert_event.dart';
part 'alert_state.dart';

const theSource = AudioSource.microphone;

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  AlertBloc() : super(AlertState());
  Repository _repository = Repository();
  bool isAcceptedNotified = false;
  GetAlertDetailsModel alertDetailsModel = GetAlertDetailsModel();
  GetCurrentAlertModel currentAlertModel;
  List<AlertData> oldAlertModel;
  Duration duration = Duration();
  LocalDataHelper localDataHelper = LocalDataHelper();
  Timer _timer;
  int sec = 0;
  Codec _codec = Codec.aacMP4;
  String _mPath = 'file.mp4';
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();

  bool _mRecorderIsInited = false;

  @override
  Stream<AlertState> mapEventToState(
    AlertEvent event,
  ) async* {
    if (event is CreateAlert) {
      yield state.copyWith(alertStatus: AlertStatus.creatingAlert);

      Position position = await getloc();
      var res = await _repository.createAlert(position, event.type);
      print("RESPONSE FOR CREATE ALERT API:$res");
      if (res['status'] == 200) {
        localDataHelper.saveStringValue(
            key: ALERT_ID, value: res['data']['alert_id'].toString());

        localDataHelper.saveValue(key: IS_ACCEPTED_NOTIFIED, value: true);
        localDataHelper.saveValue(key: IS_CREATE_ALERT, value: true);
        _startAudioRecord();
        yield state.copyWith(
            alertStatus: AlertStatus.createdAlert, res: res['data']);
      } else {
        yield state.copyWith(
            alertStatus: AlertStatus.alertCreationFailed, res: res);
      }
    } else if (event is AcceptAlert) {
      yield state.copyWith(alertStatus: AlertStatus.acceptingAlert);
      final res = await _repository.acceptAlert(event.alertId);
      print("ACCEPT ALERT API RESPONSE :$res\n");

      if (res['status'] == 200) {
        
        yield state.copyWith(
          alertStatus: AlertStatus.acceptedAlert,
          res: res,
        );
      } else {
        yield state.copyWith(
            alertStatus: AlertStatus.alertAcceptaionFailed, res: res);
      }
    } else if (event is EndAlert) {
      yield state.copyWith(alertStatus: AlertStatus.endingAlert);
      var res =
          await stopAudioRecorder(event.duration, event.timer, event.recorder);
      if (res['status'] == 200) {
        print("UPLOADING AUDIO API RESPONSE :$res\n");

        final resonse = await _repository.endAlert(
            event.alertId, duration.toString(), res['data']['image'][0]);
        print("ENDING ALERT API RESPONSE :$resonse\n");

        if (resonse['status'] == 200) {
          add(GetCurrentAlert()); //
          localDataHelper.saveValue(key: IS_ACCEPTED_NOTIFIED, value: false);
          // localDataHelper.saveStringValue(key: ALERT_ID, value: '');
          localDataHelper.saveValue(key: IS_CREATE_ALERT, value: false);
          yield state.copyWith(
              alertStatus: AlertStatus.endedAlert, res: resonse['data']);
        } else {
          yield state.copyWith(
              alertStatus: AlertStatus.endingAlertFailed, res: resonse);
        }
      } else {
        yield state.copyWith(
            alertStatus: AlertStatus.endingAlertFailed, res: res);
      }
    } else if (event is LeaveAlert) {
      yield state.copyWith(alertStatus: AlertStatus.leavingAlert);

      final res = await _repository.leaveAlert(event.alertId);
      print("RESPONSE FOR LEAVING ALERT API:$res");

      if (res['status'] == 200) {
        add(GetCurrentAlert()); //
        yield state.copyWith(alertStatus: AlertStatus.leavedAlert, res: res);
      } else {
        yield state.copyWith(
            alertStatus: AlertStatus.leavingAlertFailed, res: res);
      }
    } else if (event is DeleteAlert) {
      yield state.copyWith(alertStatus: AlertStatus.deletionAlert);

      final res = await _repository.deleteAlert(event.alertId);
      print("RESPONSE FOR DELETE ALERT API:$res");

      if (res['status'] == 200) {
        yield state.copyWith(alertStatus: AlertStatus.deletedAlert, res: res);
      } else {
        yield state.copyWith(
            alertStatus: AlertStatus.deletionAlertFailed, res: res);
      }
    } else if (event is ReportUser) {
      yield state.copyWith(alertStatus: AlertStatus.reportingUser);
      final res = await _repository.reportUser(
          event.alertId, event.toUser, event.reason, event.comment);

      if (res['status'] == 200) {
        yield state.copyWith(alertStatus: AlertStatus.reportedUser, res: res);
      } else {
        yield state.copyWith(
          alertStatus: AlertStatus.reportingUserFailed,
          res: res,
        );
      }
    } else if (event is GetAlertDetails) {
      // String alertId = await localDataHelper.getStringValue(key: ALERT_ID);
      yield state.copyWith(alertStatus: AlertStatus.gettingAlertDetails);

      final res = await _repository.getAlertDetails(event.alertId);
      print("RESPONSE OF GETTING CURRENT ALERT DETAILS API:$res");

      if (res['status'] == 200) {
        alertDetailsModel = GetAlertDetailsModel.fromJson(res['data']);
        yield state.copyWith(
            alertStatus: AlertStatus.gotAlertDetails, res: res);
      } else {
        yield state.copyWith(
            alertStatus: AlertStatus.gettingAlertDetailsFailed, res: res);
      }
    } else if (event is GetOldAlerts) {
      yield state.copyWith(alertStatus: AlertStatus.gettingOldAlerts);
      final res = await _repository.getOldAlerts();

      print("OLD ALERTS RESPONSE : $res");

      if (res['status'] == 200) {
        oldAlertModel = [];

        var t = res['data']['alertData'];
        t.forEach((element) {
          oldAlertModel.add(AlertData.fromJson(element));
        });

        yield state.copyWith(alertStatus: AlertStatus.gotOldAlerts, res: res);
      } else {
        yield state.copyWith(
            alertStatus: AlertStatus.gettingOldAlertsFailed, res: res);
      }
    } else if (event is GetCurrentAlert) {
      yield state.copyWith(alertStatus: AlertStatus.gettingCurrentAlert);

      final res = await _repository.getCurrentAlert();
      print("RESPONSE OF GET CURRENT ALERT API:$res");

      if (res['status'] == 200) {
        print("MESSAGEEEEEE  ${res['data']}");

        currentAlertModel = GetCurrentAlertModel();
        currentAlertModel = GetCurrentAlertModel.fromJson(res['data']);
        if (currentAlertModel.alertData == null) {
          yield state.copyWith(alertStatus: AlertStatus.gotCurrentAlert);
        } else {
          if (currentAlertModel.alertData.alertStatus == "in-progress") {
            _startAudioRecord();
            localDataHelper.saveStringValue(
                key: ALERT_ID,
                value: currentAlertModel.alertData.id.toString());

            yield state.copyWith(
                alertStatus: AlertStatus.createdAlert, res: res);
          }
        }
      } else {
        yield state.copyWith(
            alertStatus: AlertStatus.gettingCurrentAlertFailed, res: res);
      }
    }
  }

  Future<dynamic> stopAudioRecorder(
      int secc, Timer timer, FlutterSoundRecorder mRecorder) async {
    Repository repository = Repository();

    if (!(await localDataHelper.getValue(key: IS_FILE_SAVED))) {
      String audioFilePath =
          await _mRecorder.stopRecorder().catchError((onError) {
        print("onError :$onError");
        Fluttertoast.showToast(msg: "$onError");
      });
      localDataHelper.saveStringValue(
          key: AUDIO_DURATION, value: _timer.tick.toString());
      localDataHelper.saveValue(key: IS_ALREADY_STOPPED_REC, value: true);
      localDataHelper.saveStringValue(key: AUDIO_FILE, value: audioFilePath);
      _timer?.cancel();
    }

    duration = Duration(
        seconds: int.parse(
            await localDataHelper.getStringValue(key: AUDIO_DURATION)));

    return await repository.uploadImage(
        file: await localDataHelper.getStringValue(
            key: AUDIO_FILE)); //audioFilePath
  }

  initializeValues() {
   
    _repository.getCurrentAlert();

    if (!Platform.isAndroid) {
      _mRecorder.openAudioSession();
    } else {
      openTheRecorder().then((value) {
        _mRecorderIsInited = true;
      });
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

  @override
  Future<void> close() {
    _timer?.cancel();
    _mPlayer.closeAudioSession();
    _mPlayer = null;
    _mRecorder.closeAudioSession();
    _mRecorder = null;
    return super.close();
  }

  void _startTimer() {
    final duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (Timer timer) {
      print("TIMER :${timer.tick}");
      sec = timer.tick;
    });
  }

  _startAudioRecord() {
    _mRecorder.startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: theSource,
    );

    _startTimer();
  }
}
