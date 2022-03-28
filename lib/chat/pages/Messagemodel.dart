class MessageModel {
  String message;
  int userid;
  String image;
  int alertid;
  String type;
  String name;
  int totalnumber;
  String alerttype;
  MessageModel({
    this.message,
    this.userid,
    this.image,
    this.name,
    this.type,
    this.alertid,
    this.totalnumber,
    this.alerttype,
  });
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
        alerttype: json['alert_type'] as String,
        message: json['message'] as String,
        alertid: json['alert_id'] as int,
        userid: json['user_id'] as int,
        image: json['user_image'] as String,
        name: json['user_name'] as String,
        totalnumber: json['total_members']);
  }
}
