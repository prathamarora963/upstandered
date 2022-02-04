import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/local/local_data_helper.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/dialogs.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';
import 'package:upstanders/home/bloc/home_bloc.dart';
import 'package:upstanders/home/constants/constants.dart';

class BuildDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Drawer(
          elevation: 20.0,
          child: Container(
            color: MyTheme.primaryColor,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.1,
                ),
                _TileBar(
                    asset: PROFILE_ASSET,
                    title: ACCOUNT_AND_PROFILE_TITLE,
                    onTap: () => Navigator.of(context).pushNamed('/profile')),
                _TileBar(
                    asset: VIDEOS_ASSET,
                    title: TRAINING_VIDEOS_TITLE,
                    onTap: () =>
                        Navigator.of(context).pushNamed('/trainingVideos')),
                _TileBar(
                    asset: ACRONYMS_ASSET,
                    title: TRAINING_SUMMARY_TITLE,
                    onTap: () => Navigator.of(context).pushNamed('/acronyms')),
                _TileBar(
                    asset: REPORT_ALERT_ASSET,
                    title: REPORT_FROM_THE_PAST_ALERT_TITLE,
                    onTap: () =>
                        Navigator.of(context).pushNamed('/reportedList')),
                _TileBar(
                    asset: RECORDINGS_ASSET,
                    title: RECORDING_FROM_THE_PAST_ALERT_TITLE,
                    onTap: () =>
                        Navigator.of(context).pushNamed('/recordings')),
                _TileBar(
                    asset: LOGOUT_ASSET,
                    title: LOGOUT_TITLE,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      _onLogout(context, size);
                    }),
              ],
            ),
          )),
    );
  }

  _onLogout(BuildContext context, Size size) {
    showGeneralDialog(
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 700),
        context: context,
        pageBuilder: (_, __, ___) {
          return Align(
              alignment: Alignment.center,
              child: BlocProvider(
                create: (context) => MapScreenBloc(),
                child: BlocListener<MapScreenBloc, MapScreenState>(
                  listener: (context, state) {
                    if (state is LoggedOut) {
                      _clearData(context);
                    } else if (state is LoggingOutFailed) {
                      Fluttertoast.showToast(msg: "Logging Out Failed");
                    }
                  },
                  child: BlocBuilder<MapScreenBloc, MapScreenState>(
                    builder: (context, state) {
                      if (state is LoggingOut) {
                        return ProcessingIndicator(
                          size: size.height * 0.0015,
                        );
                      }
                      return AreYouSureDialogBox(
                        heading: "Logout",
                        fontSize: size.height * 0.026,//20,
                        description: "Are you sure want to logout?",
                        onCancel: () => Navigator.of(context).pop(),
                        onEvent: () =>
                            context.read<MapScreenBloc>().add(Logout()),
                      );
                    },
                  ),
                ),
              ));
        });
  }

  _clearData(BuildContext context) {
    LocalDataHelper localDataHelper = LocalDataHelper();
    localDataHelper.clearAll();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);

    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => AppStateScreen()),
    //     (route) => false);
  }
}

class _TileBar extends StatelessWidget {
  final String asset;
  final String title;
  final void Function() onTap;

  const _TileBar(
      {Key key,
      @required this.asset,
      @required this.title,
      @required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListTile(
      leading: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: Image.asset(
            asset,
            height: 30,
            width: 30,
          )),
      title: Text(
        title,
        style: TextStyle(
            fontSize: size.width * 0.045,
            fontWeight: FontWeight.bold,
            color: MyTheme.black),
      ),
      onTap: onTap,
    );
  }
}
