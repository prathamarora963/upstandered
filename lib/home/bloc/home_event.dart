part of 'home_bloc.dart';

abstract class MapScreenEvent extends Equatable {
  const MapScreenEvent();

  @override
  List<Object> get props => [];
}

class FetchProfileData extends MapScreenEvent {
  @override
  List<Object> get props => [];
}

class UserLocationUpdated extends MapScreenEvent {
  final BuildContext context;

  UserLocationUpdated(this.context);
  @override
  List<Object> get props => [context];
}

class BuildMarkers extends MapScreenEvent {
  final List<NearbyUsers> nearbyUsers;
  final bool isAlertInCreatingMode;
  BuildMarkers(
    this.nearbyUsers,
    this.isAlertInCreatingMode,
  );
  @override
  List<Object> get props => [nearbyUsers];
}

class MarkersBuiltSuccess extends MapScreenEvent {
  final Set<Marker> markers;

  MarkersBuiltSuccess(this.markers);
  @override
  List<Object> get props => [];
}

class Logout extends MapScreenEvent {
  @override
  List<Object> get props => [];
}

class UpdateUserMarker extends MapScreenEvent {
  final bool isAlertInCreatingMode;
  UpdateUserMarker({@required this.isAlertInCreatingMode});
  @override
  List<Object> get props => [isAlertInCreatingMode];
}

class UpdateNearByUsers extends MapScreenEvent {
  final String alertId;
  UpdateNearByUsers(
    this.alertId,
  );
  @override
  List<Object> get props => [
        alertId,
      ];
}
