part of 'create_account_bloc.dart';

enum RegistrationStatus {
  unknown,
  processing,
  sendingOTPFailed,
  verifyingOTP,
  sentOTP,
  verifiedOTP,
  gotCurrentLocation,
  verifiedIdentity,
  failure,
  done,
  uploadingImage,
  uploadedImage,
  SendingOtpOnNumber,
  SentOtpOnNumber,
  SendingOtpOnNumberFailed
}

class CreateAccountState extends Equatable {
  const CreateAccountState(
      {this.formzStatus = FormzStatus.pure,
      this.registrationStatus = RegistrationStatus.unknown,
      this.createAccount,
      this.data,
      this.oldNumber = const PhoneNumber.pure(),
      this.newNumber = const PhoneNumber.pure(),
      });

  final RegistrationStatus registrationStatus;
  final UpdateProfile createAccount;
  final Map data;
  final FormzStatus formzStatus;
  final PhoneNumber oldNumber;
  final PhoneNumber newNumber;

  CreateAccountState copyWith(
      {RegistrationStatus registrationStatus,
      Map data,
      FormzStatus formzStatus,
      PhoneNumber oldNumber,
      PhoneNumber newNumber,

      }) {
    return CreateAccountState(
        formzStatus: formzStatus ?? this.formzStatus,
        registrationStatus: registrationStatus ?? this.registrationStatus,
        createAccount: createAccount ?? this.createAccount,
        data: data ?? this.data,
        oldNumber: oldNumber ?? this.oldNumber,
         newNumber: newNumber ?? this.newNumber,
        );
  }

  @override
  List<Object> get props =>
      [registrationStatus, createAccount, data, formzStatus, oldNumber, newNumber];
}
