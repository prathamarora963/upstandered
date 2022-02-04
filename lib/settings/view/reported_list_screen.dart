import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/local/local_data_helper.dart';
import 'package:upstanders/common/resource/time_ago.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';
import 'package:upstanders/home/bloc/alert_bloc.dart';
import 'package:upstanders/home/data/model/get_current_alert_model.dart';
import 'package:upstanders/home/widgets/enter_pin_screen.dart';
import 'package:upstanders/settings/constants/title_constants.dart';

List<AlertData> oldAlertData = [];

class ReportedListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyTheme.primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          REPORTS_FROM_PAST_ALERT,
          style: TextStyle(
            color: MyTheme.secondryColor,
          ),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: MyTheme.secondryColor,
            ),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: BlocProvider(
        create: (context) => AlertBloc()..add(GetOldAlerts()),
        child: BlocBuilder<AlertBloc, AlertState>(
          builder: (BuildContext context, AlertState state) {
            if (state.alertStatus == AlertStatus.gettingOldAlertsFailed) {
              return _OldAlertFailed(
                error: state.res['message'],
              );
            }
            if (state.alertStatus == AlertStatus.gotOldAlerts) {
              oldAlertData = BlocProvider.of<AlertBloc>(context).oldAlertModel;
              return _ReportedListForm();
            }
            return Center(
              child: ShimmerLoadingAlertList(),
            );
          },
        ),
      ),
    );
  }
}

class _ReportedListForm extends StatefulWidget {
  @override
  __ReportedListFormState createState() => __ReportedListFormState();
}

class __ReportedListFormState extends State<_ReportedListForm> {
  @override
  Widget build(BuildContext context) {
    return _listItem();
  }

  _listItem() {
    return Container(
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: oldAlertData.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              onTap: () => navigateToEnterPinCodeScreen(oldAlertData[index]),
              leading: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: MyTheme.primaryColor, shape: BoxShape.circle),
                  child: Text("${index + 1}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
              title: Text(oldAlertData[index].type.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Text(TimeAgo.formateDate(oldAlertData[index].date),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          );
        },
      ),
    );
  }

  navigateToEnterPinCodeScreen(AlertData data) {
    LocalDataHelper localDataHelper = LocalDataHelper();
    localDataHelper.saveStringValue(key: ALERT_ID, value: data.id.toString());
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EnterPinCodeScreen(
          alertId: data.id.toString(),
        )));
  }
}

class _OldAlertFailed extends StatelessWidget {
  final error;

  const _OldAlertFailed({Key key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("${error.toString()}"),
    );
  }
}
