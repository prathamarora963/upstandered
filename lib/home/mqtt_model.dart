class MqttModel {
  int userId;
  String firstName;
  String lastName;
  String distance;
  int alertId;
  String notificationType;
  String type;
  int senderId;
  String senderImage;
  String senderEmail;
  String latitude;
  String longitude;
  String senderName;

  MqttModel(
      {this.userId,
        this.firstName,
        this.lastName,
        this.distance,
        this.alertId,
        this.notificationType,
        this.type,
        this.senderId,
        this.senderImage,
        this.senderEmail,
        this.latitude,
        this.longitude,
        this.senderName});

  MqttModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    distance = json['distance'];
    alertId = json['alertId'];
    notificationType = json['notificationType'];
    type = json['type'];
    senderId = json['senderId'];
    senderImage = json['senderImage'];
    senderEmail = json['senderEmail'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    senderName = json['senderName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['distance'] = this.distance;
    data['alertId'] = this.alertId;
    data['notificationType'] = this.notificationType;
    data['type'] = this.type;
    data['senderId'] = this.senderId;
    data['senderImage'] = this.senderImage;
    data['senderEmail'] = this.senderEmail;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['senderName'] = this.senderName;
    return data;
  }
}

