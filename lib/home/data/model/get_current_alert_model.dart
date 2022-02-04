////GetCurrentAlertDetailsModel///////

class GetAlertDetailsModel {
  AlertData alertData;

  GetAlertDetailsModel({this.alertData});

  GetAlertDetailsModel.fromJson(Map<String, dynamic> json) {
    alertData = json['alertData'] != null
        ? new AlertData.fromJson(json['alertData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.alertData != null) {
      data['alertData'] = this.alertData.toJson();
    }
    return data;
  }
}

/////GetCurrentAlertModel///

class GetCurrentAlertModel {
  UserData userData;
  AlertData alertData;

  GetCurrentAlertModel({this.userData, this.alertData});

  GetCurrentAlertModel.fromJson(Map<String, dynamic> json) {
    userData = json['userData'] != null
        ? new UserData.fromJson(json['userData'])
        : null;
    alertData = json['alertData'] != null
        ? new AlertData.fromJson(json['alertData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userData != null) {
      data['userData'] = this.userData.toJson();
    }
    if (this.alertData != null) {
      data['alertData'] = this.alertData.toJson();
    }
    return data;
  }
}

class UserData {
  int userId;
  String email;
  String firstName;
  String lastName;
  String dob;
  String gender;
  String countryCode;
  String phone;
  String image;
  String licenseImage;
  String latitude;
  String longitude;
  String fcmToken;
  String pin;
  String otp;
  String accountStatus;
  String onlineStatus;
  String mcq;
  int accountStatusNo;
  String phoneVerify;
  String uniqueId;

  UserData(
      {this.userId,
      this.email,
      this.firstName,
      this.lastName,
      this.dob,
      this.gender,
      this.countryCode,
      this.phone,
      this.image,
      this.licenseImage,
      this.latitude,
      this.longitude,
      this.fcmToken,
      this.pin,
      this.otp,
      this.accountStatus,
      this.onlineStatus,
      this.mcq,
      this.accountStatusNo,
      this.phoneVerify,
      this.uniqueId});

  UserData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dob = json['dob'];
    gender = json['gender'];
    countryCode = json['country_code'];
    phone = json['phone'];
    image = json['image'];
    licenseImage = json['license_image'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    fcmToken = json['fcm_token'];
    pin = json['pin'];
    otp = json['otp'];
    accountStatus = json['account_status'];
    onlineStatus = json['online_status'];
    mcq = json['mcq'];
    accountStatusNo = json['account_status_no'];
    phoneVerify = json['phone_verify'];
    uniqueId = json['unique_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['license_image'] = this.licenseImage;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['fcm_token'] = this.fcmToken;
    data['pin'] = this.pin;
    data['otp'] = this.otp;
    data['account_status'] = this.accountStatus;
    data['online_status'] = this.onlineStatus;
    data['mcq'] = this.mcq;
    data['account_status_no'] = this.accountStatusNo;
    data['phone_verify'] = this.phoneVerify;
    data['unique_id'] = this.uniqueId;
    return data;
  }
}

////////COMMON MODELS/////////
class AlertData {
  int id;
  int userId;
  String type;
  String date;
  String latitude;
  String longitude;
  String duration;
  String alertStatus;
  String audioFile;
  String createAt;
  List<UserModel> user;

  AlertData(
      {this.id,
      this.userId,
      this.type,
      this.date,
      this.latitude,
      this.longitude,
      this.duration,
      this.alertStatus,
      this.audioFile,
      this.createAt,
      this.user});

  AlertData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    date = json['date'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    duration = json['duration'];
    alertStatus = json['alert_status'];
    audioFile = json['audioFile'];
    createAt = json['create_at'];
    if (json['user'] != null) {
      user = [];
      json['user'].forEach((v) {
        user.add(new UserModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['type'] = this.type;
    data['date'] = this.date;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['duration'] = this.duration;
    data['alert_status'] = this.alertStatus;
    data['audioFile'] = this.audioFile;
     data['create_at'] = this.createAt;
    if (this.user != null) {
      data['user'] = this.user.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserModel {
  int id;
  int userId;
  int alertId;
  String userStatus;
  String email;
  String firstName;
  String lastName;
  String dob;
  String gender;
  String countryCode;
  String phone;
  String image;
  String licenseImage;
  String latitude;
  String longitude;
  String fcmToken;
  String pin;
  String otp;
  String accountStatus;
  String onlineStatus;
  String mcq;
  int accountStatusNo;
  String phoneVerify;
  String uniqueId;

  UserModel(
      {this.id,
      this.userId,
      this.alertId,
      this.userStatus,
      this.email,
      this.firstName,
      this.lastName,
      this.dob,
      this.gender,
      this.countryCode,
      this.phone,
      this.image,
      this.licenseImage,
      this.latitude,
      this.longitude,
      this.fcmToken,
      this.pin,
      this.otp,
      this.accountStatus,
      this.onlineStatus,
      this.mcq,
      this.accountStatusNo,
      this.phoneVerify,
      this.uniqueId});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    alertId = json['alert_id'];
    userStatus = json['user_status'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dob = json['dob'];
    gender = json['gender'];
    countryCode = json['country_code'];
    phone = json['phone'];
    image = json['image'];
    licenseImage = json['license_image'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    fcmToken = json['fcm_token'];
    pin = json['pin'];
    otp = json['otp'];
    accountStatus = json['account_status'];
    onlineStatus = json['online_status'];
    mcq = json['mcq'];
    accountStatusNo = json['account_status_no'];
    phoneVerify = json['phone_verify'];
    uniqueId = json['unique_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['alert_id'] = this.alertId;
    data['user_status'] = this.userStatus;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['license_image'] = this.licenseImage;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['fcm_token'] = this.fcmToken;
    data['pin'] = this.pin;
    data['otp'] = this.otp;
    data['account_status'] = this.accountStatus;
    data['online_status'] = this.onlineStatus;
    data['mcq'] = this.mcq;
    data['account_status_no'] = this.accountStatusNo;
    data['phone_verify'] = this.phoneVerify;
    data['unique_id'] = this.uniqueId;
    return data;
  }
}
