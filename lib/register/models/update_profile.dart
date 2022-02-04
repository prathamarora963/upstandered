class UpdateProfile {
  String firstName;
  String lastName;
  String dob;
  String gender;
  String countryCode;
  String phone;
  String image;
  String licenseImage = "";
  String latitude = "";
  String longitude = "";
  String fcmToken = "";
  String pin = "";
  String otp = "";
  String accountStatus = "";
  String onlineStatus = "";
  String uniqueId;

  UpdateProfile({
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
    this.otp,
    this.uniqueId
  });

  UpdateProfile.fromJson(Map<String, dynamic> json) {
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
    onlineStatus = json['unique_id'];
    // token = json['token'];
  }

  Map<String, dynamic> toJson(UpdateProfile updateProfile) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = updateProfile.firstName;
    data['last_name'] = updateProfile.lastName;
    data['dob'] = updateProfile.dob;
    data['gender'] = updateProfile.gender;
    data['country_code'] = updateProfile.countryCode;
    data['phone'] = updateProfile.phone;
    data['image'] = updateProfile.image;
    data['license_image'] = updateProfile.licenseImage;
    data['latitude'] = updateProfile.latitude;
    data['longitude'] = updateProfile.longitude;
    data['fcm_token'] = updateProfile.fcmToken;
    data['pin'] = updateProfile.pin;
    data['otp'] = updateProfile.otp;
    data['account_status'] = updateProfile.accountStatus;
    data['online_status'] = updateProfile.onlineStatus;
    data['unique_id'] = updateProfile.uniqueId;
    // data['token'] = this.token;
    return data;
  }
}
