import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/core/constants.dart';
import 'package:upstanders/common/local/local_data_helper.dart';
import 'package:upstanders/common/repository/repository.dart';

part 'app_state_event.dart';
part 'app_state_state.dart';

class AppStateBloc extends Bloc<AppStateEvent, AppStateState> {
  AppStateBloc() : super(AppStateInitial());

  LocalDataHelper localDataHelper = LocalDataHelper();
  Repository _repository = Repository();

  @override
  Stream<AppStateState> mapEventToState(
    AppStateEvent event,
  ) async* {
    if (event is CheckAppState) {
      yield CheckingState();
      localDataHelper.saveValue(key: IS_ACTIVE, value: false);
      String token = await localDataHelper.getStringValue(key: TOKEN);

      String savedFcmToken =
          await localDataHelper.getStringValue(key: Constants.FCM_TOKEN);
      print("savedFcmToken :$savedFcmToken \n\n token:$token");

      if (token != null && token != '') {
        String accountStatus =
            await localDataHelper.getStringValue(key: Constants.ACCOUNT_STATUS);
        print("accountStatus accountStatus accountStatus:$accountStatus");
        if (accountStatus == "1") {
          yield CreateProfile();
        } else if (accountStatus == "2") {
          var res = await _repository.getCurrentUserProfile();
          print("CURRENT USER PROFILE DATA RESPONSE: $res");
          if (res['status'] == 200) {
            yield VerifyAccount(res['data']);
          } else if (res['status'] == 4000) {
            localDataHelper.clearAll();
            yield UserDeleted(res['data']);
          } else {
            yield Failed(res['data']);
          }
        }else if (accountStatus == "3") {
          var res = await _repository.getCurrentUserProfile();
          print("CURRENT USER PROFILE DATA RESPONSE: $res");
          if (res['status'] == 200) {
            yield Home();
          } else if (res['status'] == 4000) {
            localDataHelper.clearAll();
            yield UserDeleted(res['data']);
          } else {
            yield Failed(res['data']);
          }
        } 
        // else {
        //   yield Home();
        // }
      } else {
        yield OnBoarding();
      }
    }
  }
}
