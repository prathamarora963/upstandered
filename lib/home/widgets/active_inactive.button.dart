import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upstanders/common/resource/file_resource.dart';
import 'package:upstanders/common/widgets/active_toggle_button.dart';
import 'package:upstanders/common/widgets/inactive_toggle_button.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';
import 'package:upstanders/home/bloc/home_bloc.dart';
import 'package:upstanders/home/bloc/online_bloc.dart';
import 'package:upstanders/home/view/view.dart';

class  ActiveInActiveView extends StatefulWidget {
  @override
  State<ActiveInActiveView> createState() => _ActiveInActiveViewState();
}

class _ActiveInActiveViewState extends State<ActiveInActiveView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<OnlineBloc, OnlineState>(
      listener: (context, state) {
        if (state is ActivatingUserFailed) {
          Fluttertoast.showToast(msg: "${state.error}");
        } else if (state is InActivatingUserFailed) {
          Fluttertoast.showToast(msg: "${state.error}");
        } else if (state is ActivatedUser) {
          profileData = BlocProvider.of<OnlineBloc>(context).prof;

          Fluttertoast.showToast(msg: "Activated");
        } else if (state is InActivatedUser) {
          Fluttertoast.showToast(msg: "In-Activated");
        }
      },
      child: BlocBuilder<OnlineBloc, OnlineState>(
        builder: (context, state) {
          if (state is InActivatedUser) {
            BlocProvider.of<MapScreenBloc>(context)
                .add(UserLocationUpdated(context));
            return InActiveToggleButton(onChange: () => BlocProvider.of<OnlineBloc>(context).add(ActiveUser()));
          }
          if (state is ActivatedUser) {
            BlocProvider.of<MapScreenBloc>(context)
                .add(UserLocationUpdated(context));

            return ActiveToggleButton(onChange: () => BlocProvider.of<OnlineBloc>(context).add(InActiveUser()));
          }

          if (state is InitialInActivatedUser) {
            BlocProvider.of<MapScreenBloc>(context)
                .add(UserLocationUpdated(context));
            return InActiveToggleButton(onChange: () => showDescriptionDialog(context));
          }

          return Align(
            alignment: Alignment.topCenter,
            child: ProcessingIndicator(
              size: size.height * 0.0015,
            ),
          );
        },
      ),
    );
  }
}
