import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/local/local_data_helper.dart';
import 'package:upstanders/common/resource/file_resource.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/buttons.dart';
import 'package:upstanders/common/widgets/dialogs.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';
import 'package:upstanders/common/widgets/profile_avatar.dart';
import 'package:upstanders/home/data/model/profile_model.dart';
import 'package:upstanders/settings/bloc/profile/account_profile_bloc.dart';
import 'package:upstanders/settings/constants/title_constants.dart';
import 'package:upstanders/settings/view/change_phone_number_screen.dart';
import 'package:upstanders/settings/view/change_pin_code_screen.dart';

ProfileModel _profile = ProfileModel();
var error;

class ProfileAccountScreen extends StatefulWidget {
  @override
  _ProfileAccountScreenState createState() => _ProfileAccountScreenState();
}

class _ProfileAccountScreenState extends State<ProfileAccountScreen> {
  AccountProfileBloc _accountProfileBloc;

  @override
  void initState() {
    _accountProfileBloc = AccountProfileBloc();
    _accountProfileBloc.add(GetCurrentUserProfile());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyTheme.secondryColor,
      appBar: AppBar(
          backgroundColor: MyTheme.primaryColor,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: MyTheme.secondryColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Text(
                ACCOUNT_AND_PROFILE,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.secondryColor),
              ),
            ],
          )),
      body: BlocBuilder(
        bloc: _accountProfileBloc,
        builder: (BuildContext context, AccountProfileState state) {
          if (state is FetchingProfileDataFailed) {
            error = state.error;
            return _AccountProfileDataFailed();
          }
          if (state is CurrentUserProfileLoaded) {
            print("PROFILE DATA: ${state.profile.toJson()}");
            _profile = state.profile;
            return _AccountProfileForm();
          }
          return Center(
            child: ProcessingIndicator(
              size: size.height * 0.0015,
            ),
          );
        },
      ),
    );
  }
}

class _AccountProfileDataFailed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("${error['message']}"),
    );
  }
}

class _AccountProfileForm extends StatefulWidget {
  @override
  __AccountProfileFormState createState() => __AccountProfileFormState();
}

class __AccountProfileFormState extends State<_AccountProfileForm> {
  File imageFile;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _imageView(size),
          SizedBox(height: size.height * 0.01),
          _title("CHANGE NUMBER"),
          SizedBox(height: size.height * 0.01),
          _phoneNumberView(context, size),
          _title("PIN"),
          SizedBox(height: size.height * 0.01),
          _changePinButtonView(context, size),
          SizedBox(height: size.height * 0.1),
          _closeAccountButton(),
          SizedBox(height: size.height * 0.03),
        ],
      ),
    );
  }

  _title(title) {
    return Text(
      title,
      style: TextStyle(
          color: MyTheme.white,
          fontSize: 16,
          height: 2.000,
          fontWeight: FontWeight.bold),
    );
  }

  _closeAccountButton() {
    return Expanded(
      child: Align(
          alignment: Alignment.bottomCenter, child: _CloseAccountButton()),
    );
  }

  _imageView(Size size) {
    double avatarRadius = size.height * 0.16;
    return Container(
      width: size.width,
      alignment: Alignment.center,
      child: BlocProvider(
        create: (context) => AccountProfileBloc(),
        child: BlocListener<AccountProfileBloc, AccountProfileState>(
          listener: (context, state) {},
          child: BlocBuilder<AccountProfileBloc, AccountProfileState>(
            builder: (context, state) {
              return Container(
                height: size.height * 0.16,
                width: size.width * 0.4,
                child: Stack(
                  children: [
                    ProfileAvatar(
                        fileImage: imageFile,
                        avatarRadius: avatarRadius,
                        width: avatarRadius + 30,
                        imageUrl: _profile.image),
                    state is UpdatingImage
                        ? Align(
                            alignment: Alignment.center,
                            child: ProcessingIndicator(
                              size: size.height * 0.0015,
                            ),
                          )
                        : Container(),
                    Positioned(
                        bottom: 0,
                        right: 10,
                        child: InkWell(
                          onTap: () => selectImageSource(context, size),
                          child: Image.asset(
                            CAMERA_ASSET,
                            height: 30,
                            width: 30,
                          ),
                        ))
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _phoneNumberView(BuildContext context, Size size) {
    return Container(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8,
      ),
      height: size.height * 0.068,
      width: size.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: MyTheme.primaryColor, borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChangePhoneNumberScreen()));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            new Image.asset(
              CHANGE_NUMBER_ASSET,
              width: 30.0,
              height: 30,
            ),
            SizedBox(width: size.width * 0.04),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "${_profile.countryCode} ${_profile.phone}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize:  size.height * 0.025, height: 2.000, fontWeight: FontWeight.bold), //16
              ),
            ),
          ],
        ),
      ),
    );
  }

  _changePinButtonView(BuildContext context, Size size) {
    return new Container(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8,
      ),
      height: size.height * 0.068,
      width: size.width,
      decoration: BoxDecoration(
          color: MyTheme.primaryColor, borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ChangePinCodeScreen()));
        },
        child: Row(
          children: [
            new Image.asset(
              PIN_CHANGE_ASSET,
              width: 30.0,
              height: 30,
            ),
            SizedBox(width: size.width * 0.04),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "CHANGE PIN",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize:  size.height * 0.025 , height: 2.000, fontWeight: FontWeight.bold), //16
              ),
            ),
          ],
        ),
      ),
    );
  }

  selectImageSource(BuildContext context, Size size) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext childcontext) {
        return Container(
          height: 120,
          color: MyTheme.primaryColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _tileBar(childcontext, size, "GALLERY", Icons.image,
                    onTap: () async {
                  File compressedImg = await pickImage(ImageSource.gallery);
                  Navigator.of(childcontext).pop();
                  setState(() {
                    imageFile = compressedImg;
                  });
                  context
                      .read<AccountProfileBloc>()
                      .add(UpdateProfileImage(compressedImg.path));
                }),
                _tileBar(childcontext, size, "CAMERA", Icons.camera_alt,
                    onTap: () async {
                  File compressedImg = await pickImage(ImageSource.camera);
                  setState(() {
                    imageFile = compressedImg;
                  });
                  Navigator.of(childcontext).pop();
                  context
                      .read<AccountProfileBloc>()
                      .add(UpdateProfileImage(compressedImg.path));
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  _tileBar(BuildContext context, Size size, String source, IconData icon,
      {void Function() onTap}) {
    return ListTile(
        leading: Card(
            color: MyTheme.secondryColor,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                icon,
                color: MyTheme.primaryColor,
              ),
            )),
        title: Text(
          source,
          style: TextStyle(
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.bold,
              color: MyTheme.black),
        ),
        onTap: onTap);
  }
}

class _CloseAccountButton extends StatefulWidget {
  @override
  State<_CloseAccountButton> createState() => _CloseAccountButtonState();
}

class _CloseAccountButtonState extends State<_CloseAccountButton> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccountProfileBloc(),
      child: BlocListener<AccountProfileBloc, AccountProfileState>(
        listener: (context, state) {
          if (state is ClosedAccount) {
            LocalDataHelper localDataHelper = LocalDataHelper();

            localDataHelper.clearAll();
            Fluttertoast.showToast(msg: "Account Closed");
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (route) => false);
            // Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(builder: (context) => AppStateScreen()),
            //     (route) => false);
          } else if (state is ClosingAccountFailed) {
            Fluttertoast.showToast(msg: "${state.error}");
          }
        },
        child: BlocBuilder<AccountProfileBloc, AccountProfileState>(
          builder: (BuildContext context, AccountProfileState state) {
            return _buildCloseAccountButton(context, size, state);
          },
        ),
      ),
    );
  }

  _buildCloseAccountButton(
      BuildContext context, Size size, AccountProfileState state) {
    bool isLoading = AccountProfileState is ClosingAccount ? true : false;
    return AnimatedRoundedBorderTextIconButton(
      isLoading: isLoading,
      processColor: MyTheme.white,
      alignment: Alignment.bottomCenter,
      title: "CLOSE ACCOUNT",
      fontSize: size.height * 0.025,//18,
      height: size.height * 0.06,
      width: isLoading ? size.height * 0.06 : size.width * 0.7,
      textColor: MyTheme.secondryColor,
      bgColor: MyTheme.primaryColor,
      borderRadius: 80,
      iconColor: MyTheme.red,
      iconAsset: DELETE_ASSET,
      onTap: () {
        onClosingAccount(context, size);
      },
    );
  }

  onClosingAccount(BuildContext context, Size size) {
    showGeneralDialog(
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 700),
        context: context,
        pageBuilder: (_, __, ___) {
          return Align(
              alignment: Alignment.center,
              child: AreYouSureDialogBox(
                heading: "Close Account",
                fontSize:  size.height * 0.020,//16
                description: "Are you sure want to close the account?",
                onCancel: () {
                  Navigator.of(context).pop();
                },
                onEvent: () =>
                    context.read<AccountProfileBloc>().add(CloseAccount()),
              ));
        });
  }
}
