part of 'home_bloc.dart';

enum MapStatus {
  unknown,
  updatingLoc,
  updatedLocation,
  locationUpdationfailure,
  creatingAlert,
  createdAlert,
}

class MapScreenState extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchingProfileData extends MapScreenState {
  String toString() {
    return "FetchingProfileData";
  }
}

class FetchedProfileData extends MapScreenState {
  String toString() {
    return "FetchedProfileData";
  }
}

class FetchingProfileDataFailure extends MapScreenState {
  String toString() {
    return "FetchingProfileData";
  }
}

class MarkerLoadingSuccess extends MapScreenState {
  final List<NearbyUsers> nearbyUserList;
  MarkerLoadingSuccess(this.nearbyUserList);
  @override
  String toString() {
    return "MarkerLoadingSuccess";
  }
}

class MapScreenInitial extends MapScreenState {
  @override
  String toString() {
    return "MapScreenInitial";
  }
}

class BuildingMarkers extends MapScreenState {
  @override
  String toString() {
    return "BuildingMarkers";
  }
}

class BuildingMarkersFailed extends MapScreenState {
  final error;

  BuildingMarkersFailed({this.error});
  @override
  String toString() {
    return "BuildingMarkersFailed";
  }
}

class BuiltMarkers extends MapScreenState {
  final Set<Marker> markers;
  final Map<PolylineId, Polyline> polylines;

  BuiltMarkers(this.markers, this.polylines);
  @override
  String toString() {
    return "BuiltMarkers";
  }
}

class LoggingOut extends MapScreenState {
  @override
  String toString() {
    return "LoggingOut";
  }
}

class LoggedOut extends MapScreenState {
  @override
  String toString() {
    return "LoggedOut";
  }
}

class LoggingOutFailed extends MapScreenState {
  final error;

  LoggingOutFailed(this.error);
  @override
  String toString() {
    return "LoggingOutFailed";
  }
}
