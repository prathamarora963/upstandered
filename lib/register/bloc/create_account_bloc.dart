import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:upstanders/common/validator/number_validator.dart';
import 'package:upstanders/common/validator/pin_validator.dart';
import 'package:upstanders/core/constants.dart';
import 'package:upstanders/common/local/local_data_helper.dart';
import 'package:upstanders/common/repository/repository.dart';
import 'package:upstanders/notification/notification_helper.dart';
import 'package:upstanders/register/models/update_profile.dart';
import 'package:upstanders/settings/view/change_phone_number_screen.dart';
part 'create_account_event.dart';
part 'create_account_state.dart';

class CreateAccountBloc extends Bloc<CreateAccountEvent, CreateAccountState> {
  CreateAccountBloc() : super(const CreateAccountState());
  Repository _repository = Repository();
  LocalDataHelper localDataHelper = LocalDataHelper();
  NotificationHelper notificationHelper = NotificationHelper();

  @override
  Stream<CreateAccountState> mapEventToState(
    CreateAccountEvent event,
  ) async* {
    if(event is OnOldNumberChanged){
      yield _mapOnOldNumberToState(event, state);
    }else if(event is OnNewNumberChanged){
      yield _mapOnNewNumberToState(event, state); 

    }else if (event is SendOTP) {
      yield* _mapSendOTPToState(event, state);
    } else if (event is VerifyOTP) {
      yield* _mapVerifyOTPToState(event, state);
    } else if (event is SendOtpOnNumber) {
      yield* _mapSendOTPOnNumberToState(event, state);
    } else if (event is UpdateUser) {
      yield* _mapCreateAccountToState(event, state);
    } else if (event is UploadImage) {
      yield* _mapUploadImageToState(event, state);
    }
  }



  CreateAccountState _mapOnOldNumberToState(
    OnOldNumberChanged event,
    CreateAccountState state,
  ) {
    final oldNumber = PhoneNumber.dirty(event.oldNumber);
    return state.copyWith(
      oldNumber: oldNumber,
      formzStatus: Formz.validate([oldNumber, state.oldNumber]),
      // Formz.validate([email, state.email]),
    );
  }

  CreateAccountState _mapOnNewNumberToState(
    OnNewNumberChanged event,
    CreateAccountState state,
  ) {
    final newNumber = PhoneNumber.dirty(event.newNumber);
    return state.copyWith(
      newNumber: newNumber,
      formzStatus: Formz.validate([newNumber, state.newNumber]),
      // Formz.validate([email, state.email]),
    );
  }


  

  Stream<CreateAccountState> _mapSendOTPToState(
    SendOTP event,
    CreateAccountState state,
  ) async* {
    yield state.copyWith(registrationStatus: RegistrationStatus.processing);
    var res = await _repository.sendOTP();
    if (res['status'] == 200) {
      yield state.copyWith(
          registrationStatus: RegistrationStatus.sentOTP, data: res);
    } else {
      yield state.copyWith(
          registrationStatus: RegistrationStatus.sendingOTPFailed, data: res);
    }
  }

  Stream<CreateAccountState> _mapSendOTPOnNumberToState(
    SendOtpOnNumber event,
    CreateAccountState state,
  ) async* {
    yield state.copyWith(registrationStatus: RegistrationStatus.processing);
    var res = await _repository.sendOtpOnNumber("${event.countryCode}${event.phoneNumber}");
    if (res['status'] == 200) {
      var phoneMap = {'phone': event.phoneNumber};

      var response = await _repository.updateProfile(accountDataBody: phoneMap);
      if(response['status'] ==200){
        yield state.copyWith(
          registrationStatus: RegistrationStatus.sentOTP, data: response);

      }else{
        yield state.copyWith(
          registrationStatus: RegistrationStatus.sendingOTPFailed, data: response);

      }
      
    } else {
      yield state.copyWith(
          registrationStatus: RegistrationStatus.sendingOTPFailed, data: res);
    }
  }

  Stream<CreateAccountState> _mapVerifyOTPToState(
    VerifyOTP event,
    CreateAccountState state,
  ) async* {
    yield state.copyWith(registrationStatus: RegistrationStatus.verifyingOTP);
    var res = await _repository.verifyOTP(createAccount: event.createAccount);
    if (res['status'] == 200) {
       localDataHelper.saveStringValue(
          key: Constants.ACCOUNT_STATUS, value: "3");
      yield state.copyWith(
          registrationStatus: RegistrationStatus.verifiedOTP, data: res);
    } else {
      yield state.copyWith(
          registrationStatus: RegistrationStatus.failure, data: res);
    }
  }

  Stream<CreateAccountState> _mapCreateAccountToState(
    UpdateUser event,
    CreateAccountState state,
  ) async* {
    yield state.copyWith(registrationStatus: RegistrationStatus.processing);
    var fcmToken = await notificationHelper.getToken();
    // UpdateProfile updateProfile = UpdateProfile(
    //     firstName: event.firstName,
    //     lastName: event.lastName,
    //     gender: event.gender,
    //     countryCode: event.code,
    //     phone: event.phone,
    //     latitude: event.lat,
    //     longitude: event.lng,
    //     uniqueId :event.uniqueId,
    //     image: event.imagePath,
    //     // fcmToken: ,
    //     dob: event.date);
    // var res = await _repository.updateProfile(createAccount: updateProfile);
    Map<dynamic, dynamic> accountDataBody = {
      'first_name': '${event.firstName}',
      'last_name': '${event.lastName}',
      'dob': '${event.date}',
      'gender': '${event.gender}',
      'country_code': '${event.code}',
      'phone': '${event.phone}',
      'image': '${event.imagePath}',
      'latitude': '${event.lat}',
      'longitude': '${event.lng}',
      'unique_id': '${event.uniqueId}',
      'fcm_token': '$fcmToken'
    };
    var res = await _repository.updateProfile(accountDataBody: accountDataBody);
    if (res['status'] == 200) {
      localDataHelper.saveStringValue(
          key: Constants.ACCOUNT_STATUS, value: "2");
      yield state.copyWith(
          registrationStatus: RegistrationStatus.done, data: res);
    } else {
      yield state.copyWith(
          registrationStatus: RegistrationStatus.failure, data: res);
    }
  }

  Stream<CreateAccountState> _mapUploadImageToState(
    UploadImage event,
    CreateAccountState state,
  ) async* {
    yield state.copyWith(registrationStatus: RegistrationStatus.uploadingImage);
    var res = await _repository.uploadImage(
      file: event.file,
    );
    if (res['status'] == 200) {
      yield state.copyWith(
          registrationStatus: RegistrationStatus.uploadedImage,
          data: res['data']);
    } else {
      yield state.copyWith(
          registrationStatus: RegistrationStatus.failure, data: res);
    }
  }
}
