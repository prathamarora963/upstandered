// import 'package:background_location/background_location.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:upstanders/api/constants/basic.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/local/local_data_helper.dart';
import 'package:upstanders/register/models/update_profile.dart';

class Apis {
  LocalDataHelper localDataHelper = LocalDataHelper();

  onSocketException(dynamic e) {
    print('EXCEPTION ❗:$e');
    if (e is SocketException) {
      Fluttertoast.showToast(msg: "No Internet Connection❗");
    }
  }

  //AUTHENTICATE WITH EMAIL AND API
  Future<dynamic> login({
    @required String email,
    @required String pin,
  }) async {
    print("LOGIN INPUT DATA:{EMAIL:$email,PIN:$pin}");
    try {
      var url = Uri.parse("$BASE_URL/login");
      var response = await http.post(url, body: {'email': email, 'pin': pin});
      Map res = json.decode(response.body);
      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  //FOGOT PASSWORD API
  Future<dynamic> forgotPassword({
    @required String email,
  }) async {
    try {
      var url = Uri.parse("$BASE_URL/forget-password");
      var response = await http.post(url, body: {'email': email});
      Map res = json.decode(response.body);
      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  //SINUP USER BY EMAIL AND PIN
  Future<dynamic> signup({
    @required String email,
    @required String pin,
  }) async {
    print("SIGNUP INPUT DATA:{EMAIL:$email,PIN:$pin}");
    try {
      var url = Uri.parse("$BASE_URL/signup");
      var response = await http.post(url, body: {'email': email, 'pin': pin});
      Map res = json.decode(response.body);
      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  //SEND OTP API
  Future<dynamic> sendOTP() async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    print("SEND OTP INPUT DATA:{TOKEN:$token}");
    try {
      var url = Uri.parse("$BASE_URL/send-otp");
      var response = await http.post(
        url,
        headers: {"Authorization": "$token"},
      );
      Map res = json.decode(response.body);
      print("SEND OTP RESPONSE DATA:$res");
      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  //VERIFY OTP API
  Future<dynamic> verifyOTP({@required UpdateProfile createAccount}) async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    var otp = await localDataHelper.getStringValue(key: OTP);
    print("VERIFY OTP INPUT DATA:{TOKEN:$token,OTP:$otp}");
    try {
      var url = Uri.parse("$BASE_URL/verify-otp");
      var response = await http.post(url,
          headers: {"Authorization": "$token"}, body: {"otp": "$otp"});
      Map res = json.decode(response.body);
      print("VERIFY OTP RESPONSE DATA:$res");
      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  //UPDATE USER PROFILE API
  Future<dynamic> updateProfile(
      {@required Map<dynamic, dynamic> accountDataBody}) async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    print("UPDATE PROFILE INPUT DATA:TOKEN:$token,$accountDataBody");

    var data = jsonEncode(accountDataBody);

    try {
      var path = "${BASE_URL}update-profile";
      var url = Uri.parse(path);
      var response = await http.post(url,
          headers: <String, String>{
            "Authorization": "$token",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: data);
      Map res = json.decode(response.body);
      print("UPDATE PROFILE RESPONS DATA:$res");
      return res;
    } catch (e) {
      onSocketException(e);

      throw e;
    }
  }

  //UPLOAD IMAGE API IT WILL CONVERT FILE IMAGE TO THE LINK
  Future<dynamic> uploadImage({@required String file}) async {
    try {
      final File imageFile = File(file);
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      var uri = Uri.parse("$BASE_URL/upload");

      var request = new http.MultipartRequest(
        "POST",
        uri,
      );
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: basename(imageFile.path));
      request.files.add(multipartFile);

      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      Map res = json.decode(respStr);
      print("RESPONSE OF UPLOADED FILE:$res");
      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  Future<dynamic> getchat({@required String alertid}) async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    print("GET CHAT API TOKEN: $token");

    try {
      var url = Uri.parse("$BASE_URL/get-chat-list/$alertid");
      var response = await http.get(
        url,
        headers: {"Authorization": "$token"},
      );
      Map res = json.decode(response.body);

      return res;
    } catch (r) {
      onSocketException(r);
      throw r;
    }
  }

  //UPDATING USER LOCATION API
  Future<dynamic> updateUserLoc({@required Position position}) async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    print(
        "UPDATE USER LOCATION INPUT DATA:{TOKEN:$token,LOCATION:{$position}}");
    try {
      var url = Uri.parse("$BASE_URL/update-user-location");
      var response = await http.post(url, headers: {
        "Authorization": "$token"
      }, body: {
        "latitude": "${position.latitude}",
        "longitude": "${position.longitude}"
      });
      Map res = json.decode(response.body);

      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  //GET MCQs VIDEOS API
  Future<dynamic> getMcqVideo() async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    print("GET MCQ VIDEOS INPUT DATA:{TOKEN:$token}");
    try {
      var path = "${BASE_URL}get-mcq-video";

      ///
      print("getMcqVideo $path");
      var url = Uri.parse(path);
      var response = await http.get(url, headers: <String, String>{
        "Authorization": "$token",
        'Content-Type': 'application/json; charset=UTF-8',
      });
      Map res = json.decode(response.body);
      print("getMcqVideo $res");
      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  ////////Get All Video And Questions ///////////
  Future<dynamic> getAllVideoAndQuestions() async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    print("GET ALL VIDEOS AND QUESTIONS INPUT DATA:{TOKEN:$token}");
    try {
      var path = "${BASE_URL}get-all-video-and-questions";
      var url = Uri.parse(path);
      var response = await http.get(url, headers: <String, String>{
        "Authorization": "$token",
        'Content-Type': 'application/json; charset=UTF-8',
      });
      Map res = json.decode(response.body);

      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  } //

  //SUBMIT ANSWER API
  submitAnswer(int videoId, List<String> answerList) async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    print(
        "SUBMIT ANSWER INPUT DATA:{TOKEN:$token,VIDEO_ID:$videoId, ANSWER_LIST:$answerList}");
    try {
      var path = "${BASE_URL}check-answer";
      var url = Uri.parse(path);
      var response = await http.post(url,
          headers: <String, String>{
            "Authorization": "$token",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
              <String, dynamic>{"answer": answerList, "videoId": videoId}));
      Map res = json.decode(response.body);
      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  //GET ALL NEAR BY USERS
  getNearbyUsers(Position position, String alertId) async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    print(
        "GET NEARBY USERS INPUT DATA:{TOKEN:$token,ALERT_ID:$alertId, LOCATION:{$position}}");
    print("$alertId");
    print("$position");

    try {
      var path = "${BASE_URL}get-all-nearby-user";
      var url = Uri.parse(path);
      var response = await http.post(url,
          headers: <String, String>{
            "Authorization": "$token",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "latitude": position.latitude,
            "longitude": position.longitude,
            "alert_id": alertId
          }));
      Map res = json.decode(response.body);
      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  //UPADTE FCM TOKEN API FOR UPDATING TOKEN TO THE DATABASE
  updateFcmToken(String fcmToken) async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    print("UPDATE FCM TOKEN INPUT DATA:{TOKEN:$token,FCM:$fcmToken}");
    try {
      var path = "${BASE_URL}update-profile";
      var url = Uri.parse(path);
      var response = await http.post(url,
          headers: <String, String>{
            "Authorization": "$token",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "fcm_token": fcmToken,
          }));
      Map res = json.decode(response.body);
      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  //GET USER PROFILE INFORMATION
  getCurrentUserProfile() async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    print("GET CURRENT USER PROFILE INPUT DATA:{TOKEN:$token}");
    try {
      var path = "${BASE_URL}get-user-profile";
      var url = Uri.parse(path);
      var response = await http.get(
        url,
        headers: <String, String>{
          "Authorization": "$token",
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      Map res = json.decode(response.body);
      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  //CREATE ALERT API FOR SENDING ALERT TO NEAR BY USER
  createAlert(
    Position position,
    String type,
  ) async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    String createAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    print(
        "CREATE ALERT INPUT DATA:{TOKEN:$token,LOCATION:{$position},ALERT_TYPE:$type, CREATE_AT:$createAt}");

    try {
      var path = "${BASE_URL}create-alert";
      var url = Uri.parse(path);
      var response = await http.post(url,
          headers: <String, String>{
            "Authorization": "$token",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "lat": position.latitude,
            "lng": position.longitude,
            "type": type,
            "create_at": createAt
          }));
      Map res = json.decode(response.body);
      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  //ACCEPT ALERT API
  acceptAlert(String alertId) async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    print("ACCEPT ALERT INPUT DATA:{TOKEN:$token,ALERT_ID:$alertId}");
    try {
      var path = "${BASE_URL}accept-alert";
      var url = Uri.parse(path);
      var response = await http.post(url,
          headers: <String, String>{
            "Authorization": "$token",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{"alert_id": "$alertId"}));
      Map res = json.decode(response.body);
      print("acceptAlert res$res ");
      return res;
    } catch (e) {
      onSocketException(e);

      throw e;
    }
  }

  //END ALERT API
  endAlert(String alertId, String duration, String audioFile) async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    var alertID = await localDataHelper.getStringValue(key: ALERT_ID);

    var data = {
      'alert_id': alertID,
      'duration': duration,
      'audioFile': audioFile
    };
    print("END ALERT INPUT  DATA :TOKEN :$token,$data");
    try {
      var path = "${BASE_URL}end-alert";
      var url = Uri.parse(path);
      var response = await http.post(url,
          headers: <String, String>{
            "Authorization": "$token",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));
      Map res = json.decode(response.body);
      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  //LEAVE ALERT API
  leaveAlert(String alertId) async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    print("LEAVE ALERT INPUT DATA:{TOKEN:$token,ALERT_ID:$alertId}");
    try {
      var path = "${BASE_URL}leave-alert";
      var url = Uri.parse(path);
      var response = await http.post(url,
          headers: <String, String>{
            "Authorization": "$token",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "alert_id": "$alertId",
          }));
      Map res = json.decode(response.body);
      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  //DELETE ALERT API

  deleteAlert(String alertId) async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    print("DELETE ALERT INPUT DATA:{TOKEN:$token,ALERT_ID:$alertId}");
    try {
      var path = "${BASE_URL}delete-alert";
      var url = Uri.parse(path);
      var response = await http.post(url,
          headers: <String, String>{
            "Authorization": "$token",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "alertId": "$alertId",
          }));
      Map res = json.decode(response.body);
      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  //REPORT USER API
  reportUser(
      String alertId, String toUser, String reason, String comment) async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    print(
        "REPORT USER INPUT DATA:{TOKEN:$token,ALERT_ID:$alertId,To_USER:$toUser,REASON:$reason,COMMENT:$comment}");
    try {
      var path = "${BASE_URL}report-user";
      var url = Uri.parse(path);
      var response = await http.post(url,
          headers: <String, String>{
            "Authorization": "$token",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "alert_id": alertId,
            "to_user": toUser,
            "reason": reason,
            "comment": comment
          }));
      Map res = json.decode(response.body);
      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  //MATCH OLD API
  matchOldPin(String oldPin) async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    print("MATCH OLD PIN INPUT DATA:{TOKEN:$token,OLD_PIN:$oldPin}");
    try {
      var path = "${BASE_URL}match-old-pin";
      var url = Uri.parse(path);
      var response = await http.post(url,
          headers: <String, String>{
            "Authorization": "$token",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{"pin": oldPin}));
      Map res = json.decode(response.body);
      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  //SEND OTP ON NUMBER API

  Future<dynamic> sendOtpOnNumber(String phoneNumber) async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    print(
        "SEND OTP ON NUMBER INPUT DATA:{TOKEN:$token,PHONE_NUMBER:$phoneNumber}");
    try {
      var path = "${BASE_URL}send-otp-on-number";
      var url = Uri.parse(path);
      var response = await http.post(url,
          headers: <String, String>{
            "Authorization": "$token",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{"phone": "$phoneNumber"}));
      Map res = json.decode(response.body);
      print("Response_______________:$res");
      return res;
    } catch (e) {
      onSocketException(e);

      throw e;
    }
  }

  //GET ALL OLD ALERTS
  getOldAlerts() async {
    var token = await localDataHelper.getStringValue(key: TOKEN);

    print("GET OLD ALERTS INPUT DATA:{TOKEN:$token}");
    try {
      var path = "${BASE_URL}get-old-alert-list";
      var url = Uri.parse(path);
      var response = await http.get(
        url,
        headers: <String, String>{
          "Authorization": "$token",
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      Map res = json.decode(response.body);

      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  // GET CURRENT ALERT
  getCurrentAlert() async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    print("GET CURRENT ALERT INPUT DATA:{TOKEN:$token}");
    try {
      var path = "${BASE_URL}get-current-alert";
      var url = Uri.parse(path);
      var response = await http.get(
        url,
        headers: <String, String>{
          "Authorization": "$token",
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      Map res = json.decode(response.body);
      print("GET CURRENT ALERT RESPONSE DATA:$res");
      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  getAlertDetails(String alertId) async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    print("GET ALERT DETAILS INPUT DATA:{TOKEN:$token, ALERT_ID:$alertId}");

    try {
      var path = "${BASE_URL}get-alert-details/$alertId";
      var url = Uri.parse(path);
      var response = await http.get(
        url,
        headers: <String, String>{
          "Authorization": "$token",
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      Map res = json.decode(response.body);
      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }

  closeAccount() async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    print("CLOSE ACCOUNT INPUT DATA:{TOKEN:$token}");

    try {
      var path = "${BASE_URL}close-account";
      var url = Uri.parse(path);
      var response = await http.post(
        url,
        headers: <String, String>{
          "Authorization": "$token",
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      Map res = json.decode(response.body);
      return res;
    } catch (e) {
      onSocketException(e);
      throw e;
    }
  }
}
