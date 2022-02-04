import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upstanders/appState/bloc/app_state_bloc.dart';
import 'package:upstanders/appState/view/view.dart';
import 'package:upstanders/common/resource/file_resource.dart';
import 'package:upstanders/home/view/view.dart';
import 'package:upstanders/register/view/view.dart';

class AppStateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppStateBloc()..add(CheckAppState()),
      child: BlocListener<AppStateBloc, AppStateState>(
          listener: (context, state) {
            checkpermission();
            if (state is CreateProfile) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => CreateProfileScreen(
                              isEnablePopButton: false,
                            )),
                    (route) => false);
              });
            } else if (state is VerifyAccount) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => VerifyAccountScreen(
                          isEnablePopButton: false,
                          number:
                              "${state.data['country_code']}${state.data['phone']}")),
                  (route) => false);
            } else if (state is Home) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/home', (route) => false);
              });
            } else if (state is OnBoarding) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/onboarding', (route) => false);
              });
            }else if(state is UserDeleted){
              
               Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/onboarding', (route) => false);
              });


            }
          },
          child: SplashScreen()),
    );
  }
}
