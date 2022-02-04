import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/local/local_data_helper.dart';
import 'package:upstanders/common/resource/file_resource.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/buttons.dart';
import 'package:upstanders/common/widgets/dialogs.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';
import 'package:upstanders/notification/notification_helper.dart';
import 'package:upstanders/register/bloc/create_account_bloc.dart';
import 'package:upstanders/register/models/update_profile.dart';
import 'package:upstanders/register/view/view.dart';
import 'package:upstanders/register/widgets/build_drop_down_button.dart';
import 'package:upstanders/register/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persona_flutter/persona_flutter.dart';
import 'package:intl/intl.dart';

TextEditingController _firstNameController = TextEditingController();
TextEditingController _lastNameController = TextEditingController();

TextEditingController _phoneNumberController = TextEditingController();
String selectedGender;
String selecteDob;
String phoneNumber;
final UpdateProfile _createAccount = UpdateProfile();
DateTime selectedDate = DateTime(1988, 8);

class CreateProfileScreen extends StatelessWidget {
  final bool isEnablePopButton;

  const CreateProfileScreen({Key key, @required this.isEnablePopButton})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyTheme.secondryColor,
        appBar: AppBar(
          backgroundColor: MyTheme.primaryColor,
          automaticallyImplyLeading: false,
          title: Text(
            "CREATE PROFILE",
            style: TextStyle(
              color: MyTheme.secondryColor,
            ),
          ),
          leading: isEnablePopButton
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: MyTheme.secondryColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              : Container(),
        ),
        body: _CreateAccountInputFormScreen());
  }
}

class _CreateAccountInputFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return CreateAccountBloc();
        },
        child: BlocListener<CreateAccountBloc, CreateAccountState>(
          listener: (context, state) {
            if (state.registrationStatus == RegistrationStatus.done) {
              context.read<CreateAccountBloc>().add(SendOTP());
              Fluttertoast.showToast(
                msg: "Please wait...",
              );
            } else if (state.registrationStatus == RegistrationStatus.sentOTP) {
              Fluttertoast.showToast(
                msg: "${state.data['message']}",
              );
              _navigateToOTPScreen(context);
            } else if (state.registrationStatus == RegistrationStatus.failure) {
              print("${state.registrationStatus}");
              Fluttertoast.showToast(
                msg: "${state.data['message']}",
              );
            } else if (state.registrationStatus ==
                RegistrationStatus.uploadedImage) {
              _createAccount.image = state.data['image'][0];
              Fluttertoast.showToast(
                msg: "Image Uploaded",
              );
            }
          },
          child: _CreateProfileForm(),
        ));
  }

  _navigateToOTPScreen(BuildContext context) {
    initializingData();
    Fluttertoast.showToast(
        msg: "We validate your phone number for everyone's safety",
        textColor: MyTheme.black,
        backgroundColor: MyTheme.white,
        gravity: ToastGravity.CENTER);

    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => VerifyAccountScreen(
              isEnablePopButton: true,
              number: "${_createAccount.countryCode}${_createAccount.phone}")),
    );
  }
}

class _CreateProfileForm extends StatefulWidget {
  @override
  __CreateProfileFormState createState() => __CreateProfileFormState();
}

class __CreateProfileFormState extends State<_CreateProfileForm> {
  LocalDataHelper localDataHelper = LocalDataHelper();
  Inquiry _inquiry;
  String selectedCountryCode;

  @override
  void initState() {
    super.initState();
    _addToken();
    initializeIdentity();
  }

  _addToken() async {
    NotificationHelper helper = NotificationHelper();
    var fcmToken = await helper.getToken();
    _createAccount.fcmToken = fcmToken;
  }

  initializeIdentity() {
    _inquiry = Inquiry(
      configuration: TemplateIdConfiguration(
        templateId: "tmpl_ozisNsJmFW9rcyEoR7jDgo6v",
        environment: InquiryEnvironment.sandbox,
        fields: InquiryFields(
          name: InquiryName(
              first: _firstNameController.text,
              middle: "",
              last: _lastNameController.text),
          additionalFields: {"test-1": "test-2", "test-3": 2, "test-4": true},
        ),
        iOSTheme: InquiryTheme(
          accentColor: Color(0xff22CB8E),
          primaryColor: Color(0xff22CB8E),
          buttonBackgroundColor: Color(0xff22CB8E),
          darkPrimaryColor: Color(0xff167755),
          buttonCornerRadius: 8,
          textFieldCornerRadius: 0,
        ),
      ),
      onSuccess: (
        String inquiryId,
        InquiryAttributes attributes,
        InquiryRelationships relationships,
      ) {
        verificationDatalog(inquiryId, attributes, relationships, "OnSucceess");
        _createAccount.uniqueId = inquiryId;

        Fluttertoast.showToast(msg: "Done");
      },
      onFailed: (
        String inquiryId,
        InquiryAttributes attributes,
        InquiryRelationships relationships,
      ) {
        verificationDatalog(inquiryId, attributes, relationships, "OnFailed");

        _createAccount.uniqueId = inquiryId;
        print(_createAccount.uniqueId);
        print("onFailed");

        Fluttertoast.showToast(msg: "Failed");
        print("- inquiryId: $inquiryId");
      },
      onCancelled: () {
        print("onCancelled");
        Fluttertoast.showToast(msg: "Cancelled");
      },
      onError: (String error) {
        print("onError");
        print("- $error");
      },
    );
  }

  verificationDatalog(String inquiryId, InquiryAttributes attributes,
      InquiryRelationships relationships, String event) {
    print("EVENTTTT :$event");
    print("- inquiryId: $inquiryId");
    print("- attributes:");
    print("-- name.first: ${attributes.name.first}");
    print("-- name.middle: ${attributes.name.middle}");
    print("-- name.last: ${attributes.name.last}");
    print("-- addr.street1: ${attributes.address.street1}");
    print("-- addr.street2: ${attributes.address.street2}");
    print("-- addr.city: ${attributes.address.city}");
    print("-- addr.postalCode: ${attributes.address.postalCode}");
    print("-- addr.countryCode: ${attributes.address.countryCode}");
    print("-- addr.subdivision: ${attributes.address.subdivision}");
    print("-- addr.subdivisionAbbr: ${attributes.address.subdivisionAbbr}");
    print("-- birthdate: ${attributes.birthdate.toString()}");
    print("- relationships:");
    for (var item in relationships.verifications) {
      print("-- id: ${item.id}");
      print("-- status: ${item.status}");
      print("-- type: ${item.type}");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1800, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        _createAccount.dob = DateFormat('yyyy-MM-dd').format(picked);
        selecteDob = DateFormat('yyyy-MM-dd').format(picked);
        selectedDate = picked;
        print("$selecteDob  IS SELECTED");
      });
  }

  pickedCountryCode() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          selectedCountryCode = "+${country.phoneCode}";
          _createAccount.countryCode = "+${country.phoneCode}";
          print("$selectedCountryCode ${country.name} IS SELECTED");
        });
      },
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var paddingLeftRight = size.height * 0.03;
    return Container(
      child: Column(
        children: [
          Expanded(
            flex: 9,
            child: Container(
              padding: EdgeInsets.only(
                  left: paddingLeftRight, right: paddingLeftRight, top: 10),
              width: size.width,
              height: size.height,
              color: MyTheme.secondryColor,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(
                          "Personal Details", 
                          style: TextStyle(
                              color: MyTheme.white,
                              fontSize: size.height * 0.028,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Are you there right now?",
                          style: TextStyle(
                              // height: 2,
                              color: MyTheme.white,
                              fontSize: size.height * 0.018,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: _ImageForm()),
                    SizedBox(height: size.height * 0.010),
                    TextIconButton(
                      onPressed: () async {
                        Position position = await getloc();
                        _createAccount.latitude = position.latitude.toString();
                        _createAccount.longitude =
                            position.longitude.toString();
                        Fluttertoast.showToast(
                          msg: "Current location added",
                        );
                      },
                      height: size.height * 0.06,
                      width: size.width,
                      text: "Use my location",
                      buttonColor: MyTheme.primaryColor,
                      childcolor: MyTheme.secondryColor,
                      iconAsset: LOCATION_ASSET,
                    ),
                    SizedBox(height: size.height * 0.025),
                    BuildEditTextField(
                      inputType: TextInputType.text,
                      controller: _firstNameController,
                      hint: "First Name",
                      prefixIconAsset: PERSON_ASSET,
                      onChanged: (val) {},
                    ),
                    SizedBox(height: size.height * 0.01),
                    BuildEditTextField(
                      inputType: TextInputType.text,
                      controller: _lastNameController,
                      hint: "Last Name",
                      prefixIconAsset: PERSON_ASSET,
                      onChanged: (val) {},
                    ),
                    SizedBox(height: size.height * 0.005),
                    bobAndGender(size),
                    SizedBox(height: size.height * 0.005),
                    countryCodeWidget(),
                    SizedBox(height: size.height * 0.01),
                    BuildEditTextField(
                      inputType: TextInputType.number,
                      controller: _phoneNumberController,
                      hint: "Phone Number",
                      prefixIconAsset: PHONE_ASSET,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        new LengthLimitingTextInputFormatter(12),
                      ],
                      onChanged: (val) {},
                    ),
                    SizedBox(height: size.height * 0.015),
                    Text(
                      "Verify your identity",
                      style: TextStyle(
                          height: 2,
                          color: MyTheme.white,
                          fontSize: size.height * 0.015,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: size.height * 0.005),
                    TextIconButton(
                      onPressed: () => onVerifyID(context),
                      height: size.height * 0.06,
                      width: size.width,
                      text: "Click to Verify",
                      buttonColor: MyTheme.primaryColor,
                      childcolor: MyTheme.secondryColor,
                      iconAsset: CAMERA_ASSET,
                    ),
                    SizedBox(height: size.height * 0.01),
                  ],
                ),
              ),
            ),
          ),
          new Expanded(
              child: new Align(
                  alignment: Alignment.bottomCenter,
                  child: _CreateProfileButton()))
        ],
      ),
    );
  }

  onVerifyID(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
            alignment: Alignment.center,
            child: RegisterSuccessDialogBox(
              onContinue: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _inquiry.start();
                Navigator.of(context).pop();
              },
              onCancel: () => Navigator.of(context).pop(),
            ));
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  countryCodeWidget() {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => pickedCountryCode(),
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        height: size.height * 0.055,
        width: size.width,
        decoration: BoxDecoration(
            color: MyTheme.white,
            border: Border.all(color: MyTheme.grey),
            borderRadius: BorderRadius.circular(3)),
        child: Row(
          children: [
            Image.asset(
              COUNTRY_CODE_ASSET,
              width: 30.0,
              height: 30,
            ),
            SizedBox(
              width: 10,
            ),
            selectedCountryCode == null
                ? Text(
                    "Country Code",
                    style: TextStyle(
                        color: MyTheme.grey,
                        fontSize: size.height * 0.013,
                        fontWeight: FontWeight.bold),
                  )
                : Text(selectedCountryCode)
          ],
        ),
      ),
    );
  }

  bobAndGender(Size size) {
    return Container(
      height: size.height * 0.07, //55
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            // width: size.width * 0.4,
            child: BuildDropDown(
                selectedItem: selecteDob,
                category: "DOB",
                assetPrefixIcon: DOB_ASSET,
                dropDownWidget: InkWell(
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: MyTheme.black,
                  ),
                  onTap: () {
                    _selectDate(context);
                  },
                )),
          ),
          Expanded(
            child: BuildDropDown(
                selectedItem: selectedGender,
                category: "Gender",
                assetPrefixIcon: GENDER_ASSET,
                dropDownWidget: new PopupMenuButton(
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: MyTheme.black,
                    ),
                    itemBuilder: (_) => <PopupMenuItem<String>>[
                          new PopupMenuItem<String>(
                              child: new Text('Male'), value: 'Male'),
                          new PopupMenuItem<String>(
                              child: new Text('Female'), value: 'Female'),
                        ],
                    onSelected: (val) {
                      setState(() {
                        _createAccount.gender = val;
                        selectedGender = val;
                      });
                    })),
          ),
        ],
      ),
    );
  }
}

class _ImageForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<CreateAccountBloc, CreateAccountState>(
      builder: (context, state) {
        return state.registrationStatus == RegistrationStatus.uploadingImage
            ? ProcessingIndicator(
                size: size.height * 0.0015,
              )
            : state.registrationStatus == RegistrationStatus.uploadedImage
                ? _viewImage(state.data['image'][0], context)
                : _addImage(context);
      },
    );
  }

  _addImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => selectImageSource(context, size),
      child: Container(
        alignment: Alignment.center,
        height: size.height * 0.07,
        width: size.height * 0.07,
        decoration:
            BoxDecoration(color: MyTheme.primaryColor, shape: BoxShape.circle),
        child: Icon(
          Icons.camera_alt,
          color: MyTheme.secondryColor,
        ),
      ),
    );
  }

  _viewImage(String image, BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        selectImageSource(context, size);
      },
      child: Container(
        alignment: Alignment.center,
        height: size.height * 0.07,
        width: size.height * 0.07,
        decoration: BoxDecoration(
            color: MyTheme.primaryColor,
            shape: BoxShape.circle,
            image:
                DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)),
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
                  context
                      .read<CreateAccountBloc>()
                      .add(UploadImage(compressedImg.path));
                }),
                _tileBar(childcontext, size, "CAMERA", Icons.camera_alt,
                    onTap: () async {
                  File compressedImg = await pickImage(ImageSource.camera);

                  Navigator.of(childcontext).pop();
                  context
                      .read<CreateAccountBloc>()
                      .add(UploadImage(compressedImg.path));
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

class _CreateProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<CreateAccountBloc, CreateAccountState>(
      builder: (context, state) {
        return _bottomButton(size, context, state);
      },
    );
  }

  bool _isValidated() {
    if (_firstNameController.text.isEmpty) {
      _showErrorToast("Please add your first Name");

      return false;
    } else if (_lastNameController.text.isEmpty) {
      _showErrorToast("Please add your last Name");

      return false;
    } else if (_createAccount.image == null || _createAccount.image == '') {
      _showErrorToast("Please add Image");
      return false;
    } else if (_phoneNumberController.text.isEmpty) {
      _showErrorToast("Please add your phone Number");

      return false;
    } else if (_createAccount.countryCode == '' ||
        _createAccount.countryCode == null) {
      _showErrorToast("Please select your country Code");
      return false;
    } else if (_createAccount.uniqueId == '' ||
        _createAccount.uniqueId == null) {
      _showErrorToast("Please Verify ID");

      return false;
    } else if (!isEighteenPlus()) {
      _showErrorToast("You are under age");

      return false;
    } else {
      return true;
    }
  }

  _showErrorToast(String msg) {
    Fluttertoast.showToast(msg: "$msg");
  }

  bool isEighteenPlus() {
    print("set birth date: $selectedDate");
    var today = DateTime.now();

    final difference = today.difference(selectedDate).inDays;
    print(difference);
    final year = difference / 365;
    print("year difference :$year");
    var age = int.parse(year.toString().split('.')[0]);
    print("age:$age");
    return age >= 18 ? true : false;
  }

  _bottomButton(Size size, BuildContext context, CreateAccountState state) {
    bool isLoading = state.registrationStatus == RegistrationStatus.processing
        ? true
        : false;

    return AnimatedRoundedBorderTextButton(
        alignment: Alignment.center,
        isLoading: isLoading,
        processColor: MyTheme.white,
        height: size.height * 0.08,
        width: isLoading ? size.height * 0.08 : size.width,
        textColor: MyTheme.secondryColor,
        fontSize: size.height * 0.020,
        title: "CREATE PROFILE",
        bgColor: MyTheme.primaryColor,
        borderRadius: isLoading ? 80 : 0,
        onTap: () {
          if (_isValidated()) {
            _createAccount.phone = _phoneNumberController.text;

            context.read<CreateAccountBloc>().add(UpdateUser(
                firstName: _firstNameController.text,
                lastName: _lastNameController.text,
                code: _createAccount.countryCode,
                imagePath: _createAccount.image,
                phone: _phoneNumberController.text,
                gender: selectedGender,
                lat: _createAccount.latitude,
                lng: _createAccount.longitude,
                uniqueId: _createAccount.uniqueId,
                date: selecteDob));
          }
        });
  }
}
