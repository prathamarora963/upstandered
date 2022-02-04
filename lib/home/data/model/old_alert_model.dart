import 'package:upstanders/home/data/model/get_current_alert_model.dart';

class OldAlertModel {
  GetCurrentAlertModel data;

  OldAlertModel({this.data});

  OldAlertModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new GetCurrentAlertModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}