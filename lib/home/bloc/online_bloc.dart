import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:upstanders/common/repository/repository.dart';
import 'package:upstanders/home/data/model/profile_model.dart';

part 'online_event.dart';
part 'online_state.dart';

class OnlineBloc extends Bloc<OnlineEvent, OnlineState> {
  OnlineBloc() : super(OnlineInitial());
  Repository _repository = Repository();
  ProfileModel prof = ProfileModel();

  @override
  Stream<OnlineState> mapEventToState(OnlineEvent event) async* {
    if (event is CheckUserOfflineOrNot) {
      yield ChekingUserOnlineStatus();

      var res = await _repository.getCurrentUserProfile();
        print("RESPONSE OF GET CURRENT USER PROFILE:$res");
      if (res['status'] == 200) {
        prof = ProfileModel.fromJson(res['data']);
        if (prof.mcq == "5") {
          if (prof.onlineStatus == "online") {
            yield ActivatedUser();
          } else {
            yield InActivatedUser();
          }
        } else {
          yield InitialInActivatedUser();
        }
      } else {
        yield CheckUserOfflineOrNotFailure(res['message']);
      }
    } else if (event is ActiveUser) {
      yield ActivatingUser();
      var onlineMap = {'online_status': 'online'};
      var res = await _repository.updateProfile(accountDataBody: onlineMap);
        print("ACTIVATEED USER RESPONSE$res");

      if (res['status'] == 200) {
        add(CheckUserOfflineOrNot());
      } else {
        yield ActivatingUserFailed(res['message']);
      }
    } else if (event is InActiveUser) {
      yield InActivatingUser();
      var offlineMap = {'online_status': 'offline'};
      var res = await _repository.updateProfile(accountDataBody: offlineMap);
        print("IN ACTIVATED USER$res");
      if (res['status'] == 200) {
        add(CheckUserOfflineOrNot());
      
      } else {
        yield InActivatingUserFailed(res['message']);
      }
    }
  }
}
