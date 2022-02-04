import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';
import 'package:video_player/video_player.dart';

import 'video_controls.dart';
import 'video_cubit.dart';
import 'video_state.dart';

VideoPlayerController globalVideoController;

class Video extends StatelessWidget {
  const Video._(
    this.url, {
    Key key,
    this.aspectRatio, //@required
  }) : super(key: key);

  static Widget blocProvider(
    String url, {
    double aspectRatio,

    ///  @required
    bool autoPlay = true,
    bool controlsVisible,
  }) {
    return BlocProvider(
      create: (_) {
        return VideoCubit(
          url,
          autoPlay: autoPlay,
          controlsVisible: controlsVisible ?? !autoPlay,
        );
      },
      child: Video._(
        url,
        aspectRatio: aspectRatio,
      ),
    );
  }

  final String url;
  final double aspectRatio;

  @override
  Widget build(
    BuildContext context,
  ) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<VideoCubit, VideoState>(
      builder: (_, state) {
        globalVideoController = state.controller;
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 100),
          child: AspectRatio(
            key: ValueKey(state.loaded),
            aspectRatio: state.controller.value.aspectRatio,
            child: state.notLoaded
                ? Center(
                    child: ProcessingIndicator(
                    size: size.height * 0.0015,
                  ))
                : _buildVideo(state, context),
          ),
        );
      },
    );
  }

  _buildVideo(VideoState state, BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      height: size.height * 0.38,
      width: size.width,
      color: Colors.black,
      child: Stack(
        children: [
          Center(child: VideoPlayer(state.controller)),
          Center(
            child: VideoControls(
              state.controller,
            ),
          ),
        ],
      ),
    );
  }
}

class Video2 extends StatelessWidget {
  final String url;
  final double aspectRatio;
  final bool autoPlay;
  final bool controlsVisible;

  const Video2(this.url,
      {Key key, this.aspectRatio, this.controlsVisible, this.autoPlay})
      : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (_) {
        return VideoCubit(
          url,
          autoPlay: autoPlay,
          controlsVisible: controlsVisible ?? !autoPlay,
        );
      },
      child: BlocBuilder<VideoCubit, VideoState>(
        builder: (_, state) {
          globalVideoController = state.controller;
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 100),
            child: AspectRatio(
              key: ValueKey(state.loaded),
              aspectRatio: state.controller.value.aspectRatio,
              child: state.notLoaded
                  ? Center(
                      child: ProcessingIndicator(
                      size: size.height * 0.0015,
                    ))
                  : _buildVideo(state, context),
            ),
          );
        },
      ),
    );
  }

  _buildVideo(VideoState state, BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      height: size.height * 0.38,
      width: size.width,
      color: Colors.black,
      child: Stack(
        children: [
          Center(child: VideoPlayer(state.controller)),
          Center(
            child: VideoControls(
              state.controller,
            ),
          ),
        ],
      ),
    );
  }
}
