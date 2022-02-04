import 'package:flutter/material.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/buttons.dart';
import 'package:upstanders/common/widgets/user_avatar.dart';
import 'package:upstanders/home/constants/constants.dart';

startMapNavigation(BuildContext context,
    {@required void Function() onStartNavigation}) {
  final size = MediaQuery.of(context).size;
  return Container(
    height: size.height * 0.2,
    color: MyTheme.primaryColor,
    padding: const EdgeInsets.all(5),
    child: Column(
      children: [
        ListTile(
          leading: UserAvatarAsset(
              asset: "assets/users/CrystalGaskell.png", avatarRadius: 45),
          title: Text(
            "CRYSTAL GASKELL",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          trailing: InkWell(
              onTap: () {},
              child:
                  Image.asset(CHAT_ASSET, height: 40, width: 40)),
        ),
        // SizedBox(height:10),

        ListTile(
          title: Text(
            "3 min (200m away)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          subtitle: Text(
            FASTEST_ROUTE_NOW_TITLE,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: MyTheme.secondryColor),
          ),
          trailing: InkWell(
            onTap: onStartNavigation,
            child: Container(
              alignment: Alignment.center,
              height: 40,
              width: 90,
              decoration: BoxDecoration(
                  color: MyTheme.white, borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                   NAVIGATE_ASSET,
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    START_TITLE,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: MyTheme.secondryColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

leaveOrEnd(BuildContext context, Size size,{String title, void Function() onEvent}) {
  final size = MediaQuery.of(context).size;
  return RoundedBorderTextButton(
      title: title,
      onTap: onEvent,
      height: size.height * 0.08,
      width: size.width,
      textColor: MyTheme.black,
      bgColor: MyTheme.primaryColor,
      borderRadius: 0,
      fontSize: size.height * 0.026,//20,
      borderColor: MyTheme.primaryColor);
}
