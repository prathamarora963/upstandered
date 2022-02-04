import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upstanders/home/data/model/profile_model.dart';
import 'package:upstanders/common/repository/repository.dart';
import 'package:equatable/equatable.dart';
part 'account_profile_state.dart';
part 'account_profile_event.dart';

class AccountProfileBloc
    extends Bloc<AccountProfileEvent, AccountProfileState> {
  AccountProfileBloc() : super(ProfileInitial());

  Repository _repository = Repository();

  @override
  Stream<AccountProfileState> mapEventToState(
    AccountProfileEvent event,
  ) async* {
    if (event is GetCurrentUserProfile) {
      yield FetchingProfileData();
      final res = await _repository.getCurrentUserProfile();
      if (res['status'] == 200) {
        var prof = ProfileModel.fromJson(res['data']);

        yield CurrentUserProfileLoaded(prof);
      } else {
        yield FetchingProfileDataFailed(error: res);
      }
    } else if (event is CloseAccount) {
      yield ClosingAccount();
      // var closeAccountMap = {'account_status': 'close'};

      final res = await _repository.closeAccount();
      // await _repository.updateProfile(accountDataBody: closeAccountMap);
      print("RESPONSE FOR CLOSE ACCOUNT:$res");
      if (res['status'] == 200) {
        yield ClosedAccount();
      } else {
        yield ClosingAccountFailed(error: res['message']);
      }
    } else if (event is ChangePin) {
      yield ChangingPin();

      var pinMap = {'pin': event.pin};
      final res = await _repository.updateProfile(accountDataBody: pinMap);
      print("RESPONSE FOR CHANGING PIN:$res");
      if (res['status'] == 200) {
        yield ChangedPin();
      } else {
        yield ChangingPinFailed(error: res['message']);
      }
    } else if (event is UpdateProfileImage) {
      yield UpdatingImage();
      var res = await _repository.uploadImage(
        file: event.file,
      );
      if (res['status'] == 200) {
        var updateImageMap = {'image': "${res['data']['image'][0]}"};
        final response =
            await _repository.updateProfile(accountDataBody: updateImageMap);
        print("UPDATING IMAGE DATA :$response");
        if (response['status'] == 200) {
          yield UpdatedImage();
        } else {
          UpdatingImageFailed(error: response['message']);
        }
      } else {
        yield UpdatingImageFailed(error: res['message']);
      }
    } else if (event is MatchOldPin) {
      yield MatchingPin();
      var res = await _repository.matchOldPin(event.pin);
      if (res['status'] == 200) {
        yield MatchedPin();
      } else {
        yield MatchingPinFailed(error: res['message']);
      }
    }
  }
}
