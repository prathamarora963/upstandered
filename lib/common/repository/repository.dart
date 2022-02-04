import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:upstanders/api/apis.dart';
import 'package:upstanders/register/models/update_profile.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated, signedUp }

class Repository {
  final _controller = StreamController<AuthenticationStatus>();
  Apis _apis = Apis();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<dynamic> logIn({
    @required String email,
    @required String pin,
  }) async {
    var res = await _apis.login(email: email, pin: pin);
    return res;
  }

   Future<dynamic> forgotPassword({
    @required String email,
  
  }) async {
    var res = await _apis.forgotPassword(email: email, );
    return res;
  }


  

  Future<dynamic> signup({
    @required String email,
    @required String pin,
  }) async {
    var res = await _apis.signup(email: email, pin: pin);
    return res;
  }

  Future<dynamic> sendOTP() async {
    var res = await _apis.sendOTP(); 
    return res;
  }

   Future<dynamic> sendOtpOnNumber( String phoneNumber) async {
    var res = await _apis.sendOtpOnNumber(phoneNumber); 
    return res;
  }



  Future<dynamic> verifyOTP({
    @required UpdateProfile createAccount,
  }) async {
    var res = _apis.verifyOTP(
      createAccount: createAccount,
    );
    return res;
  }

  Future<dynamic> updateProfile({@required  Map<dynamic, dynamic> accountDataBody}) async { //@required UpdateProfile createAccount
    // var res = _apis.updateProfile(createAccount: createAccount);
    var res = _apis.updateProfile(accountDataBody: accountDataBody);
    return res;
  }

  Future<dynamic> uploadImage({@required String file}) async {
    var res = _apis.uploadImage(file: file);
    return res;
  }

  Future<dynamic> getMcq() async {
    var res = await _apis.getMcqVideo();
    return res;
  }
  

  Future<dynamic> getAllVideoAndQuestions() async {
    var res = await _apis.getAllVideoAndQuestions();
    return res;
  }
  

  Future<dynamic> updateUserLoc({
    @required Position position,
  }) async {
    var res = _apis.updateUserLoc(position: position);
    return res;
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();

  submitAnswer(int videoId, List<String> answerList) {
    var res = _apis.submitAnswer(videoId, answerList);
    return res;
  }

  getNearbyUsers(Position position , String alertId) {
    var res = _apis.getNearbyUsers(position , alertId);
    return res;
  }

  updateFcmToken(String fcmToken) {
    var res = _apis.updateFcmToken(fcmToken);
    return res;
  }

  getCurrentUserProfile(){
    var res = _apis.getCurrentUserProfile();
    return res;

  }

  createAlert(Position position , String type) {
    var res = _apis.createAlert( position ,  type);
    return res;
  }

  acceptAlert(String alertId  ) {
    var res = _apis.acceptAlert( alertId);
    return res;
  }
  endAlert( String alertId, String duration, String audioFile) {
    var res = _apis.endAlert( alertId, duration, audioFile);
    return res;
  }
  leaveAlert(String alertId) {
    var res = _apis.leaveAlert( alertId );
    return res;
  }

  deleteAlert(String alertId) {
    var res = _apis.deleteAlert( alertId );
    return res;
  }
  reportUser(String alertId, String toUser ,String reason, String comment) {
    var res = _apis.reportUser( alertId ,  toUser, reason, comment);
    return res;
  }


  matchOldPin(String pin, ) {
    var res = _apis.matchOldPin(pin);
    return res;
  }

  
  getOldAlerts() {
    var res = _apis.getOldAlerts();
    return res;
  }
  getCurrentAlert() {
    var res = _apis.getCurrentAlert();
    return res;
  }
  getAlertDetails(String alertId) {
    var res = _apis.getAlertDetails(alertId);
    return res;
  }

  closeAccount(){
    var res = _apis.closeAccount();
    return res;

  }

  

  
}
