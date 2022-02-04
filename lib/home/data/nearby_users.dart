import 'package:flutter/material.dart';

// class NearbyUsers {
//    String userId;
//    String fname;
//    String lname;
//    String gender;
//    String dob;
//    String image;
//    String email;
//    bool showImage;
//    String userRole;
//   double latitude;
//   double longitude;

//   NearbyUsers(
//       {@required this.fname,
//       @required this.lname,
//       @required this.userId,
//       @required this.gender,
//       @required this.dob,
//       @required this.image,
//       @required this.email,
//       @required this.showImage,
//       this.userRole,
//       @required this.latitude,
//       @required this.longitude});



// }


class NearbyUsers {
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
  String userRole;
  bool showImage;

  NearbyUsers(
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
      this.userRole,
      this.showImage});

  NearbyUsers.fromJson(Map<String, dynamic> json) {
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
    userRole = json['User_role'];
    showImage = json['showImage'];
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
    data['User_role'] = this.userRole;
    data['showImage'] = this.showImage;
    return data;
  }
}