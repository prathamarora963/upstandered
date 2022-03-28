import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gallery_saver/files.dart';
import 'package:upstanders/chat/pages/Messagemodel.dart';
import 'package:upstanders/common/constants/shared_keys_constants.dart';
import 'package:upstanders/home/view/home_screen.dart';
import 'package:http/http.dart' as http;



class Chatdata {
  final String message;
  final int alertid;
  final int userid;
  final int totalmember;

  Chatdata({this.alertid, this.message, this.userid, this.totalmember});
  factory Chatdata.fromJson(Map<String, dynamic> json) {
    return Chatdata(
      message: json['message'] as String,
      alertid: json['alert_id'] as int,
      userid: json['user_id'] as int,
      totalmember: json['total_members'],
    );
  }
}
