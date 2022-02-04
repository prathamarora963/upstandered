part of 'create_account_bloc.dart';

abstract class CreateAccountEvent extends Equatable {
  const CreateAccountEvent();

  @override
  List<Object> get props => [];
}

class OnOldNumberChanged extends CreateAccountEvent {
  const OnOldNumberChanged(this.oldNumber);
  final String oldNumber;

  @override
  List<Object> get props => [oldNumber];
}

class OnNewNumberChanged extends CreateAccountEvent {
  const OnNewNumberChanged(this.newNumber);
  final String newNumber;

  @override
  List<Object> get props => [newNumber];
}




class VerifyMe extends CreateAccountEvent {
  const VerifyMe(this.createAccount);
  final UpdateProfile createAccount;

  @override
  List<Object> get props => [createAccount];
}




class VerifyOTP extends CreateAccountEvent {
  const VerifyOTP(this.createAccount);
  final UpdateProfile createAccount;

  @override
  List<Object> get props => [createAccount];
}

class SendOTP extends CreateAccountEvent {
  @override
  List<Object> get props => [];
}

class UpdateUser extends CreateAccountEvent {
  final String firstName;
  final String lastName;
  final String date;
  final String gender;
  final String code;
  final String phone;
  final String imagePath;
   final String lat;
  final String lng;
  final String uniqueId;
  
  UpdateUser( 
      {@required this.firstName,
      this.lastName,
      this.date,
      this.gender,
      this.code,
      this.phone,
      this.lat, 
      this.lng,
      this.imagePath,
      this.uniqueId
      });
  @override
  List<Object> get props => [];
}

class UploadImage extends CreateAccountEvent {
  const UploadImage(this.file);

  final String file;

  @override
  List<Object> get props => [file];
}

class SendOtpOnNumber extends CreateAccountEvent {
  const SendOtpOnNumber(this.phoneNumber, this.countryCode);


  final String phoneNumber;
   final String countryCode;

  @override
  List<Object> get props => [phoneNumber];
}


