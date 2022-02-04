part of 'alert_bloc.dart';


abstract class AlertEvent extends Equatable {
  const AlertEvent();

  @override
  List<Object> get props => [];
}

class CreateAlert extends AlertEvent {
  final type;
  const CreateAlert(this.type);

  @override
  List<Object> get props => [type];
}

class AcceptAlert extends AlertEvent {
  final String alertId;

  AcceptAlert(this.alertId);
  @override
  List<Object> get props => [alertId];
}

class EndAlert extends AlertEvent {
  final String alertId;
  final int duration;
  final Timer timer;
  final FlutterSoundRecorder recorder;

  EndAlert(this.alertId, this.duration,  this.timer, this.recorder);
  @override
  List<Object> get props => [alertId, duration, timer,recorder];
}

class LeaveAlert extends AlertEvent {
  final String alertId;
  LeaveAlert(this.alertId);
  @override
  List<Object> get props => [alertId];
}

class DeleteAlert extends AlertEvent {
  final String alertId;
  DeleteAlert(this.alertId);
  @override
  List<Object> get props => [alertId];
}



class ReportUser extends AlertEvent {
  final String alertId;
  final String toUser;
  final String reason;
  final String comment;
  ReportUser(this.alertId, this.toUser, this.reason, this.comment);
  @override
  List<Object> get props => [alertId, toUser, reason, comment];
}

class GetOldAlerts extends AlertEvent {
  @override
  List<Object> get props => [];
}

class GetCurrentAlert extends AlertEvent {
  @override
  List<Object> get props => [];
}

class GetAlertDetails extends AlertEvent {
  final String alertId;
  GetAlertDetails(this.alertId);
  @override
  List<Object> get props => [alertId];
}
