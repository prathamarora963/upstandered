class ProfileModel {
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

  ProfileModel(
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

  ProfileModel.fromJson(Map<String, dynamic> json) {
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
