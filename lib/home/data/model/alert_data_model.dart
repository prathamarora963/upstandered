class NotificationDataModel {
  String senderName;
  String senderId;
  String distance;
  String senderEmail;
  String alertId;
  String notificationType;
  String type;
  String senderImage;
  String latitude;
  String longitude;

  NotificationDataModel(
      {this.senderName,
      this.senderId,
      this.distance,
      this.senderEmail,
      this.alertId,
      this.notificationType,
      this.type,
      this.senderImage,
      this.latitude,
      this.longitude});

  NotificationDataModel.fromJson(Map<String, dynamic> json) {
    senderName = json['senderName'];
    senderId = json['senderId'];
    distance = json['distance'];
    senderEmail = json['senderEmail'];
    alertId = json['alertId'];
    notificationType = json['notificationType'];
    type = json['type'];
    senderImage = json['senderImage'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderName'] = this.senderName;
    data['senderId'] = this.senderId;
    data['distance'] = this.distance;
    data['senderEmail'] = this.senderEmail;
    data['alertId'] = this.alertId;
    data['notificationType'] = this.notificationType;
    data['type'] = this.type;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Messagenotification {
  String username;
  String userimage;
  String message;

  Messagenotification({
    this.username,
    this.userimage,
    this.message,
  });
  Messagenotification.fromjson(Map<String, dynamic> json) {
    username = json['user_name'];
    userimage = json['user_image'];
    message = json['message'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['user_name'] = this.username;
    data['user_image'] = this.userimage;
    data['message'] = this.message;
    return data;
  }
}
