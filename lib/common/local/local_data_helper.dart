import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upstanders/common/constants/constants.dart';

import 'package:upstanders/home/data/model/alert_data_model.dart';

class LocalDataHelper {
  SharedPreferences prefs;

  saveValue({@required String key, @required bool value}) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  saveStringValue({@required String key, @required String value}) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String> getStringValue({@required String key}) async {
    prefs = await SharedPreferences.getInstance();
    var getStringVal = prefs.getString(key);
    return getStringVal ?? "";
  }

  Future<bool> getValue({@required String key}) async {
    prefs = await SharedPreferences.getInstance();
    bool getVal = prefs.getBool(key);
    return getVal;
  }

  remove({@required String key}) async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  clearAll() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}


initializingData() {
   LocalDataHelper localDataHelper = LocalDataHelper();
    localDataHelper.saveValue(key: ALERT_ENDED_NOTIFIED, value: false);
    localDataHelper.saveValue(key: IS_ACCEPTED_NOTIFIED, value: false);
    localDataHelper.saveValue(key: SHOW_LEAVE, value: false);
    localDataHelper.saveValue(key: IS_CREATE_ALERT, value: false);
    localDataHelper.saveStringValue(key: ALERT_ID, value: '');
    localDataHelper.saveValue(key: IS_FILE_SAVED, value: false);
    localDataHelper.saveValue(key: IS_ALREADY_STOPPED_REC, value: false);

    String notificationData = jsonEncode(NotificationDataModel.fromJson({}));
    localDataHelper.saveStringValue(key: NOTIFICATION_DATA, value: notificationData);
}

