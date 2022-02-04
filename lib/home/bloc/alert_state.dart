part of 'alert_bloc.dart';

// // abstract class AlertState extends Equatable {
// //   const AlertState();
// //   @override
// //   List<Object> get props => [];
// // }
// abstract class AlertState extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// class AlertInitial extends AlertState {
//   @override
//   String toString() {
//     return "AlertInitial";
//   }
//   // @override
//   // List<Object> get props => [];
// }

// class CreatingAlert extends AlertState {
//   @override
//   String toString() {
//     return "CreatingAlert";
//   }
//   //  @override
//   // List<Object> get props => [];
// }

// class CreatedAlert extends AlertState {
//   final res;

//   CreatedAlert(this.res);
//   @override
//   String toString() {
//     return "CreatedAlert";
//   }
//   // @override
//   // List<Object> get props => [];
// }

// class AlertCreationFailed extends AlertState {
//   final String error;
//   AlertCreationFailed({this.error});
//   @override
//   String toString() {
//     return "AlertCreationFailed";
//   }
//   //   @override
//   // List<Object> get props => [error];
// }

// class AcceptingAlert extends AlertState {
//   @override
//   String toString() {
//     return "AcceptingAlert";
//   }
// }

// class AcceptedAlert extends AlertState {
//   final res;
//   AcceptedAlert(this.res);
//   @override
//   String toString() {
//     return "AcceptedAlert";
//   }
// }

// class AlertAcceptaionFailed extends AlertState {
//   final String error;
//   AlertAcceptaionFailed({this.error});
//   @override
//   String toString() {
//     return "AlertAcceptaionFailed";
//   }
// }

// class EndingAlert extends AlertState {
//   @override
//   String toString() {
//     return "EndingAlert";
//   }
// }

// class EndedAlert extends AlertState {
//   final res;
//   EndedAlert(this.res);
//   @override
//   String toString() {
//     return "EndedAlert";
//   }
// }

// class EndingAlertFailed extends AlertState {
//   final String error;
//   EndingAlertFailed({this.error});
//   @override
//   String toString() {
//     return "EndingAlertFailed";
//   }
// }

// class LeavingAlert extends AlertState {
//   @override
//   String toString() {
//     return "LeavingAlert";
//   }
// }

// class LeavedAlert extends AlertState {
//   final res;
//   LeavedAlert(this.res);
//   @override
//   String toString() {
//     return "LeavedAlert";
//   }
// }

// class LeavingAlertFailed extends AlertState {
//   final String error;
//   LeavingAlertFailed({this.error});
//   @override
//   String toString() {
//     return "LeavingAlertFailed";
//   }
// }

// class ReportingUser extends AlertState {
//   @override
//   String toString() {
//     return "ReportingUser";
//   }
// }

// class ReportedUser extends AlertState {
//   final res;
//   ReportedUser(this.res);
//   @override
//   String toString() {
//     return "ReportedUser";
//   }
// }

// class ReportingUserFailed extends AlertState {
//   final String error;
//   ReportingUserFailed({this.error});
//   @override
//   String toString() {
//     return "ReportingUserFailed";
//   }
// }

// class GettingOldAlerts extends AlertState {
//   @override
//   String toString() {
//     return "GettingOldAlerts";
//   }
// }

// class GotOldAlerts extends AlertState {
//   final res;
//   GotOldAlerts(this.res);
//   @override
//   String toString() {
//     return "GotOldAlerts";
//   }
// }

// class GettingOldAlertsFailed extends AlertState {
//   final String error;
//   GettingOldAlertsFailed({this.error});
//   @override
//   String toString() {
//     return "GettingOldAlertsFailed";
//   }
// }

// class GettingCurrentAlert extends AlertState {
//   @override
//   String toString() {
//     return "GettingCurrentAlert";
//   }
// }

// class GotCurrentAlert extends AlertState {
//   final res;
//   GotCurrentAlert(this.res);

//   @override
//   String toString() {
//     return "GotCurrentAlert";
//   }
// }

// class GettingCurrentAlertsFailed extends AlertState {
//   final String error;
//   GettingCurrentAlertsFailed({this.error});
//   @override
//   String toString() {
//     return "GettingCurrentAlertsFailed";
//   }
// }

/////***************//////////////

enum AlertStatus {
  unknown,
  creatingAlert,
  createdAlert,
  alertCreationFailed,
  acceptingAlert,
  acceptedAlert,
  alertAcceptaionFailed,
  endingAlert,
  endedAlert,
  endingAlertFailed,
  leavingAlert,
  leavedAlert,
  leavingAlertFailed,
  deletionAlert,
  deletedAlert,
  deletionAlertFailed,
  reportingUser,
  reportedUser,
  reportingUserFailed,
  gettingAlertDetails,
  gotAlertDetails,
  gettingAlertDetailsFailed,
  gettingOldAlerts,
  gotOldAlerts,
  gettingOldAlertsFailed,
  gettingCurrentAlert,
  gotCurrentAlert,
  gettingCurrentAlertFailed,
  helperReached,

}

class AlertState {
  AlertState({this.alertStatus = AlertStatus.unknown, this.res});

  final AlertStatus alertStatus;
  final Map res;

  AlertState copyWith({
    AlertStatus alertStatus,
    Map res,
  }) {
    return AlertState(
        alertStatus: alertStatus ?? this.alertStatus,
        res: res ?? this.res);
  }
}




