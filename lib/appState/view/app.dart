import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upstanders/appState/view/view.dart';
import 'package:upstanders/network/bloc/bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => NetworkBloc()..add(ListenConnection()),
        child: BlocListener<NetworkBloc, NetworkState>(
          listener: (context, state) {
            if (state is ConnectionFailure) {
              Fluttertoast.showToast(msg: "No Internet Connection");
            }
          },
          child: AppStateScreen(),
        ),
      );
  }
}