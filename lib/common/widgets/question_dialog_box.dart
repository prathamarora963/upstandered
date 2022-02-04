import 'package:flutter/material.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/model/quiz_model.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/buttons.dart';
import 'package:upstanders/common/widgets/user_avatar.dart';
import 'package:upstanders/home/widgets/report_screen.dart';

class MCQDialogBox extends StatelessWidget {
  final void Function() onContinue;
  final Questions question;
  final Widget optionsList;
  final int index;
  final int totalMCQlength;

  const MCQDialogBox({
    Key key,
    this.onContinue,
    this.question,
    this.optionsList,
    this.index,
    this.totalMCQlength
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.45,
        margin: EdgeInsets.only(left: 12, right: 12),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: _mCQDialogBody( size)
        
        ));
  }

  _mCQDialogBody(Size size){
    return Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                alignment: Alignment.center,
                height: size.height * 0.15,
                width: size.width,
                decoration: BoxDecoration(
                    color: MyTheme.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: size.height * 0.01),
                          Text(
                            question.question,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MyTheme.secondryColor),
                          ),
                          SizedBox(height: size.height * 0.02),
                        ],
                      ),
                    ),
                    Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          alignment: Alignment.center,
                          height: size.height * 0.025,
                          width:  size.height * 0.025,
                          decoration: BoxDecoration(
                              color: MyTheme.primaryColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: MyTheme.black)),
                          child: FittedBox(
                            fit: BoxFit.fitWidth, 
                            child: Text(
                              "${index + 1}/$totalMCQlength",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: MyTheme.secondryColor),
                            ),
                          ),
                        ))
                  ],
                )),
            Expanded(
              child: optionsList,
            )
          ],
        ));
  }
}


///////QUESTION DIALOG BOX
class QuestionDialogBox extends StatelessWidget {
  final void Function() onSubmit;
  final void Function() onCancel;
  final ReportUserModel reportUser;
  final void Function(String) onChangedcomment;
  final List<Widget> options;

  const QuestionDialogBox(
      {Key key,
      @required this.onSubmit,
      @required this.onCancel,
      @required this.reportUser,
      @required this.onChangedcomment,
      @required this.options})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.72,
        margin: EdgeInsets.only(left: 12, right: 12),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: QuestionDialogBody(
              onCancel: onCancel,
              onSubmit: onSubmit,
              reportUser: reportUser,
              onChangedcomment: onChangedcomment,
              options: options),
        ));
  }
}

class QuestionDialogBody extends StatelessWidget {
  final void Function() onSubmit;
  final void Function() onCancel;
  final ReportUserModel reportUser;
  final void Function(String) onChangedcomment;
  final List<Widget> options;

  QuestionDialogBody(
      {Key key,
      @required this.onSubmit,
      @required this.onCancel,
      @required this.reportUser,
      @required this.onChangedcomment,
      @required this.options})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            alignment: Alignment.center,
            height: size.height * 0.1,
            width: size.width,
            decoration: BoxDecoration(
                color: MyTheme.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        alignment: Alignment.center,
                        height: size.height * 0.1,
                        width: size.width,
                        decoration: BoxDecoration(
                            color: MyTheme.primaryColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            )),
                        child: ListTile(
                          leading: UserAvatarNetwok(
                            avatarRadius: size.height * 0.07,
                            networkImage: reportUser.image,
                          ),
                          title: Text(
                            "${reportUser.firstName} ${reportUser.lastName}",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: MyTheme.secondryColor),
                          ),
                        ))),
                Positioned(
                    top: 8,
                    right: 10,
                    child: InkWell(
                        onTap: onCancel,
                        child: Image.asset(
                          CROSS_ASSET,
                          height: 20,
                          width: 20,
                        )))
              ],
            )),
        SizedBox(height: size.height * 0.01),
        Expanded(
            child: _body(
          size,
          onCancel,
          onSubmit,
          onChangedcomment,
          options,
        ))
      ],
    ));
  }

  _body(Size size, void Function() onCancel, void Function() onSubmit,
      void Function(String) onChangedcomment, List<Widget> options) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: size.height * 0.27,
            child: ListView(padding: const EdgeInsets.all(0), children: options
                //  list(),
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              textAlign: TextAlign.left,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Write text here",
                border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                )),
              ),
              onChanged: onChangedcomment,
            ),
          ),
          SizedBox(height: size.height * 0.015),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RoundedBorderTextButton(
                  textColor: MyTheme.secondryColor,
                  title: "CANCEL",
                  bgColor: MyTheme.white,
                  height: size.height * 0.06,
                  width: size.width * 0.38,
                  onTap: onCancel,
                  borderColor: MyTheme.white,
                  borderRadius: 0,
                  fontSize: 18,
                ),
                SizedBox(width: 20),
                RoundedBorderTextButton(
                  textColor: MyTheme.secondryColor,
                  title: "SUBMIT",
                  bgColor: MyTheme.primaryColor,
                  height: size.height * 0.06,
                  width: size.width * 0.38,
                  onTap: onSubmit,
                  borderColor: MyTheme.primaryColor,
                  borderRadius: 80,
                  fontSize: 18,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
