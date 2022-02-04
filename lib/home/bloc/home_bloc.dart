import 'dart:async';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/resource/file_resource.dart';
import 'package:upstanders/core/constants.dart';
import 'package:upstanders/common/local/local_data_helper.dart';
import 'package:upstanders/home/data/model/profile_model.dart';
import 'package:upstanders/home/data/nearby_users.dart';
import 'package:upstanders/home/resources/maker_res.dart';
import 'package:upstanders/common/repository/repository.dart';
part 'home_event.dart';
part 'home_state.dart';

class MapScreenBloc extends Bloc<MapScreenEvent, MapScreenState> {
  MapScreenBloc() : super(MapScreenInitial());

  Repository _repository = Repository();
  LocalDataHelper _localDataHelper = LocalDataHelper();
  bool loadMarkers = false;
  ProfileModel prof = ProfileModel();
  List<NearbyUsers> savedUsers = [];
  Set<Marker> updatedMarkes = {};

  List<NearbyUsers> nearbyList = [];
  int tappedCount = 0;
  GoogleMapController mapController;
  Set<Marker> builtmarkers = {};

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  BuildContext context;
  int updatedNearByUsersCount = 0;
  Position currentLocation;
  int updatedNearByUserscountt = 0;
  LocalDataHelper localDataHelper = LocalDataHelper();
  @override
  Stream<MapScreenState> mapEventToState(
    MapScreenEvent event,
  ) async* {
    if (event is FetchProfileData) {
      yield FetchingProfileData();

      var res = await _repository.getCurrentUserProfile();
      print("RESPONSE PROFILE DATA:$res");
      if (res['status'] == 200) {
        prof = ProfileModel.fromJson(res['data']);
        // add(CheckUserOfflineOrNot());

        yield FetchedProfileData();
      } else {
        yield FetchingProfileDataFailure();
      }
    } else if (event is UserLocationUpdated) {
      context = event.context;
      Position position = await getloc();
      var res = await _repository.updateUserLoc(position: position);
      print("UPDATE USER LOCATION API RESPONSE:$res");

      String savedFcmToken =
          await _localDataHelper.getStringValue(key: Constants.FCM_TOKEN);
      String fcmToken = await FirebaseMessaging.instance.getToken();
      await FirebaseMessaging.instance.getAPNSToken();

      if (savedFcmToken != fcmToken) {
        final res = await _repository.updateFcmToken(fcmToken);
        if (res['status'] == 200) {
          _localDataHelper.saveStringValue(
              key: Constants.FCM_TOKEN, value: fcmToken);
        }
      }
      print("responseeeeee $fcmToken");
    } else if (event is UpdateUserMarker) {
      currentLocation = await getloc();
      loadMarkers = true;
      String alertId = await localDataHelper.getStringValue(key: ALERT_ID);

      final res = await _repository.getNearbyUsers(currentLocation, alertId);

      print("NEAR BY USER RESPONSE DATA :$res");
      if (res['status'] == 200) {
        var data = List<dynamic>.from(res['data']);
        List<NearbyUsers> users = [];
        data.forEach((user) {
          users.add(NearbyUsers.fromJson(user));
        });

        print("NEAR BY USER LENGTH:${data.length}");
        add(BuildMarkers(
          users,
          event.isAlertInCreatingMode,
        ));
      } else {
        loadMarkers = false;

        yield BuildingMarkersFailed(error: res['message']);
      }
    } else if (event is BuildMarkers) {
      print("BuildingMarkers...................");
      yield BuildingMarkers();
      builtmarkers.clear();

      builtmarkers = await _buildUserMarker(
          event.nearbyUsers, event.isAlertInCreatingMode);
      loadMarkers = false;

      print("BUILT INITIAL MARKER LENGTH:$builtmarkers");

      // add(MarkersBuiltSuccess(builtmarkers));
      yield BuiltMarkers(builtmarkers, polylines);
    }
    // else if (event is MarkersBuiltSuccess) {
    //   loadMarkers = false;

    //   print("BUIL INITIAL MARKER LENGTH:${event.markers.length}");
    //   yield BuiltMarkers(event.markers, polylines);
    // }
    else if (event is Logout) {
      yield LoggingOut();
      var logoutMap = {'fcm_token': 'fcm_token'};
      var res = await _repository.updateProfile(accountDataBody: logoutMap);
      if (res['status'] == 200) {
        print("LOGGED OUT RESPONSE$res");
        yield LoggedOut();
      } else {
        yield LoggingOutFailed(res['message']);
      }
    }
  }

  //ISSUE LINE 1

  //Build markers

  Future<Set<Marker>> _buildUserMarker(
      List<NearbyUsers> updatedNearByusers, bool isAlertInCreatingMode) async {
    Set<Marker> markers = {};

    markers = await getMarkers(updatedNearByusers, isAlertInCreatingMode);

    updatedNearByUsersCount = updatedNearByUserscountt;
    updatedMarkes = markers;
    print("NUMBERSOFMARKERSSSSS :${markers.length}");
    return markers;
  }

  // initial Camera Position
  CameraPosition initialCameraPosition() {
    return CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 18.0,
    );
  }

  // When map is created
  void onMapCreated(GoogleMapController controller) {
    print("Current location map home screen bloc :$currentLocation");
    mapController = controller;
    controller.setMapStyle(changeMapMode());
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 18.0,
        ),
      ),
    );

    add(UpdateUserMarker(isAlertInCreatingMode: false));
  }

  //Map Style
  changeMapMode() {
    getJsonFile(MAP_STYLE_JSON_ASSET).then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    mapController.setMapStyle(mapStyle);
  }

  Future<Set<Marker>> getMarkers(
    List<NearbyUsers> updatedNearByusers,
    bool isAlertInCreatingMode,
  ) async {
    Set<Marker> markers = {};
    print("NEAR BY USERS LENGTH :${updatedNearByusers.length}");
    updatedNearByusers.forEach((nearbyUser) async {
      if (nearbyUser.userId.toString() == prof.userId.toString() ||
          nearbyUser.showImage) {
        updatedNearByUserscountt = updatedNearByUserscountt + 1;
        var icon =
            await getMarkersImage(nearbyUser, prof, isAlertInCreatingMode);
        print(
            "UPDATED ICON WITH IMAGE ===-===============$icon ${nearbyUser.image}");

        markers.add(Marker(
            markerId: MarkerId(nearbyUser.userId.toString()),
            position: LatLng(double.parse(nearbyUser.latitude),
                double.parse(nearbyUser.longitude)),
            icon: icon));
      } else {
        var icon = await getMarkerIconWithOutImage(
          Size(110, 110),
          nearbyUser.firstName,
        );
        print(
            "UPDATED ICON WITHOUT IMAGE===-===============$icon ${nearbyUser.image}");
        markers.add(Marker(
            markerId: MarkerId(nearbyUser.userId.toString()),
            position: LatLng(double.parse(nearbyUser.latitude),
                double.parse(nearbyUser.longitude)),
            icon: icon));
      }
    });
    return markers;
  }
}
