import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/pop_button.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';
import 'package:upstanders/home/data/model/video_model.dart';
import 'package:upstanders/videos/bloc/video_bloc.dart';
import 'package:upstanders/videos/bloc/video_event.dart';
import 'package:upstanders/videos/bloc/video_state.dart';
import 'package:upstanders/videos/components/video/video.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

List<VideoModel> videos = [];
VideoModel video = VideoModel();

class TrainingVideos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyTheme.secondryColor, body: _VideosForm());
  }
}

class _VideosForm extends StatefulWidget {
  @override
  __VideosFormState createState() => __VideosFormState();
}

class __VideosFormState extends State<_VideosForm> {
  @override
  void dispose() {
    // BlocProvider.of<VideoCubit>(context).dispose();
    // if (commonVideoController.value.isPlaying) commonVideoController.pause();
    globalVideoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => VideoQuizBloc()..add(GetAllVideoAndQuestions()),
      child: BlocListener<VideoQuizBloc, VideoState>(
        listener: (context, state) {
          if (state is GotAllVideos) {
            videos = context.read<VideoQuizBloc>().allVideos;
            video = videos[0];
          }
          if (state is GotNextVideo) {
            video = context.read<VideoQuizBloc>().nextVideo;
          }
        },
        child: BlocBuilder<VideoQuizBloc, VideoState>(
          builder: (context, state) {
            if (state is GotAllVideos || state is GotNextVideo) {
              return PlayPage(videosModels: videos);

              // _body(size, context);
            }
            return Center(
              child: ProcessingIndicator(
                size: size.height * 0.0015,
              ),
            );
          },
        ),
      ),
    );
  }

  // _body(Size size, BuildContext blocContext) {
  //   return Container(
  //     height: size.height,
  //     child: Stack(
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             VideoWidget(video),
  //             SizedBox(height: size.height * 0.01),
  //             Text(" More Videos",
  //                 style: TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 14,
  //                     color: MyTheme.white)),
  //             SizedBox(height: size.height * 0.01),
  //             allVideos(size, blocContext)
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // allVideos(Size size, BuildContext blocContext) {
  //   return Container(
  //     height: size.height * 0.22,
  //     child: ListView.builder(
  //         scrollDirection: Axis.horizontal,
  //         itemCount: videos.length,
  //         itemBuilder: (context, index) {
  //           return Container(
  //               margin: const EdgeInsets.only(right: 10),
  //               alignment: Alignment.center,
  //               height: size.height * 0.30,
  //               width: size.width * 0.6,
  //               decoration: BoxDecoration(
  //                   color: MyTheme.white,
  //                   image: DecorationImage(
  //                       image: NetworkImage(videos[index].videoImage),
  //                       fit: BoxFit.cover)),
  //               child: Stack(
  //                 children: [
  //                   Align(
  //                     alignment: Alignment.center,
  //                   ),
  //                   Container(
  //                     alignment: Alignment.center,
  //                     // color: MyTheme.black38,
  //                     height: size.height * 0.30,
  //                     width: size.width,
  //                     child: InkWell(
  //                       onTap: () => BlocProvider.of<VideoQuizBloc>(blocContext)
  //                             .add(NextVideo(index)),
  //                       child: Container(
  //                         height: 45,
  //                         width: 45,
  //                         alignment: Alignment.center,
  //                         decoration: BoxDecoration(
  //                             shape: BoxShape.circle,
  //                             color: MyTheme.primaryColor),
  //                         child: Icon(
  //                           Icons.play_arrow,
  //                           size: 40,
  //                           color: MyTheme.white,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ));
  //         }),
  //   );
  // }
}

// class VideoWidget extends StatelessWidget {
//   final VideoModel videoModel;

//   const VideoWidget(this.videoModel);
//   @override
//   Widget build(BuildContext context) {
//     print(
//         "VIDEOOOOOOOOOOOOOO_______${BlocProvider.of<VideoQuizBloc>(context).nextVideo.videoId}  ${BlocProvider.of<VideoQuizBloc>(context).nextVideo.url}");
//     final size = MediaQuery.of(context).size;
//     return Container(
//         alignment: Alignment.center,
//         height: size.height * 0.38,
//         decoration: BoxDecoration(
//           color: MyTheme.white,
//         ),
//         child: BlocBuilder<VideoQuizBloc, VideoState>(
//           builder: (context, state) {
//             if (state is GotNextVideo || state is GotAllVideos) {
//               bool autoPlay = true;
//               return Stack(
//                 children: [
//                   // MyVideoPlayer(
//                   //   videoAsset:  BlocProvider.of<VideoQuizBloc>(context).nextVideo.url,
//                   // ),

//                   Align(
//                     alignment: Alignment.center,
//                     child: Video.blocProvider(
//                       //
//                       // Normally you'll get both the url and the aspect ratio from your video meta data
//                       // videoModel.url,
//                       // aspectRatio: 1.77,

//                       BlocProvider.of<VideoQuizBloc>(context).nextVideo.url,
//                       autoPlay: autoPlay,
//                       // controlsVisible: !autoPlay,
//                     ),
//                   ),

//                   Align(
//                     alignment: Alignment.bottomRight,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: InkWell(
//                           onTap: () {},
//                           child: Image.asset(
//                             STRETCH_SCREEN_ASSET,
//                             height: 25,
//                             width: 25,
//                           )),
//                     ),
//                   ),
//                   PopButton(
//                     onCancel: () {
//                       if (globalVideoController.value.isPlaying)
//                         globalVideoController.pause();

//                       Navigator.pop(context);
//                     },
//                   )
//                 ],
//               );
//             }
//             return ProcessingIndicator();
//           },
//         ));
//   }
// }

class PlayPage extends StatefulWidget {
  PlayPage({Key key, this.videosModels}) : super(key: key);

  final List<VideoModel> videosModels;

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  VideoPlayerController _controller;

  List<VideoModel> get videos {
    return widget.videosModels;
  }

  var _playingIndex = -1;
  var _disposed = false;
  var _isFullScreen = false;
  var _isEndOfClip = false;
  var _progress = 0.0;
  var _showingDialog = false;
  Timer _timerVisibleControl;
  double _controlAlpha = 1.0;

  var _playing = false;
  bool get _isPlaying {
    return _playing;
  }

  set _isPlaying(bool value) {
    _playing = value;
    _timerVisibleControl?.cancel();
    if (value) {
      _timerVisibleControl = Timer(Duration(seconds: 2), () {
        if (_disposed) return;
        setState(() {
          _controlAlpha = 0.0;
        });
      });
    } else {
      _timerVisibleControl = Timer(Duration(milliseconds: 200), () {
        if (_disposed) return;
        setState(() {
          _controlAlpha = 1.0;
        });
      });
    }
  }

  void _onTapVideo() {
    debugPrint("_onTapVideo $_controlAlpha");
    setState(() {
      _controlAlpha = _controlAlpha > 0 ? 0 : 1;
    });
    _timerVisibleControl?.cancel();
    _timerVisibleControl = Timer(Duration(seconds: 2), () {
      if (_isPlaying) {
        setState(() {
          _controlAlpha = 0.0;
        });
      }
    });
  }

  @override
  void initState() {
    Wakelock.enable();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _initializeAndPlay(0);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    disposing();
  }

  disposing() {
    print("DISPOSE:$_controller");
    _disposed = true;
    _timerVisibleControl?.cancel();
    Wakelock.disable();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    _exitFullScreen();
    _controller?.pause(); // mute instantly
    _controller?.dispose();
    _controller = null;
  }

  void _toggleFullscreen() async {
    if (_isFullScreen) {
      _exitFullScreen();
    } else {
      _enterFullScreen();
    }
  }

  void _enterFullScreen() async {
    debugPrint("enterFullScreen");
    await SystemChrome.setEnabledSystemUIOverlays([]);
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    if (_disposed) return;
    setState(() {
      _isFullScreen = true;
    });
  }

  void _exitFullScreen() async {
    debugPrint("exitFullScreen");
    await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (_disposed) return;
    setState(() {
      _isFullScreen = false;
    });
  }

  void _initializeAndPlay(int index) async {
    print("_initializeAndPlay ---------> $index");
    final clip = videos[index];
    final controller = VideoPlayerController.network(clip.url);

    final old = _controller;
    _controller = controller;
    if (old != null) {
      old.removeListener(_onControllerUpdated);
      old.pause();
      debugPrint("---- old contoller paused.");
    }

    debugPrint("---- controller changed.");
    setState(() {});

    controller
      ..initialize().then((_) {
        debugPrint("---- controller initialized");
        old?.dispose();
        _playingIndex = index;
        _duration = null;
        _position = null;
        controller.addListener(_onControllerUpdated);
        controller.play();
        setState(() {});
      });
  }

  var _updateProgressInterval = 0.0;
  Duration _duration;
  Duration _position;

  void _onControllerUpdated() async {
    if (_disposed) return;
    // blocking too many updation
    // important !!
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_updateProgressInterval > now) {
      return;
    }
    _updateProgressInterval = now + 500.0;

    final controller = _controller;
    if (controller == null) return;
    if (!controller.value.isInitialized) return;
    if (_duration == null) {
      _duration = _controller.value.duration;
    }
    var duration = _duration;
    if (duration == null) return;

    var position = await controller.position;
    _position = position;
    final playing = controller.value.isPlaying;
    final isEndOfClip = position.inMilliseconds > 0 &&
        position.inSeconds + 1 >= duration.inSeconds;
    if (playing) {
      // handle progress indicator
      if (_disposed) return;
      setState(() {
        _progress = position.inMilliseconds.ceilToDouble() /
            duration.inMilliseconds.ceilToDouble();
      });
    }

    // handle clip end
    if (_isPlaying != playing || _isEndOfClip != isEndOfClip) {
      _isPlaying = playing;
      _isEndOfClip = isEndOfClip;
      debugPrint(
          "updated -----> isPlaying=$playing / isEndOfClip=$isEndOfClip");
      if (isEndOfClip && !playing) {
        debugPrint(
            "========================== End of Clip / Handle NEXT ========================== ");
        final isComplete = _playingIndex == videos.length - 1; //test
        if (isComplete) {
          print("played all!!");
          if (!_showingDialog) {
            _showingDialog = true;
            _showPlayedAllDialog().then((value) {
              _exitFullScreen();
              _showingDialog = false;
            });
          }
        } else {
          _initializeAndPlay(_playingIndex + 1);
        }
      }
    }
  }

  Future<bool> _showPlayedAllDialog() async {
    return showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(child: Text("Played all videos.")),
            actions: <Widget>[
              FlatButton(
                child: Text("Close"),
                onPressed: () => Navigator.pop(context, true),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyTheme.secondryColor,
      body: _isFullScreen
          ? Container(
              child: Center(child: _playView(context)),
              decoration: BoxDecoration(color: MyTheme.secondryColor))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                  Container(
                    child: Center(child: _playView(context)),
                    decoration: BoxDecoration(color: Colors.black),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(" More Videos",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: MyTheme.white)),
                  SizedBox(height: size.height * 0.01),
                  allVideos(size, context)
                ]),
    );
  }

  void _onTapCard(int index) {
    _initializeAndPlay(index);
  }

  Widget _playView(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      return AspectRatio(
        //aspectRatio: controller.value.aspectRatio,
        aspectRatio: controller.value.aspectRatio, //16.0 / 9.0,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child: VideoPlayer(controller),
              onTap: _onTapVideo,
            ),
            _controlAlpha > 0
                ? AnimatedOpacity(
                    opacity: _controlAlpha,
                    duration: Duration(milliseconds: 250),
                    child: _controlView(context),
                  )
                : Container(),
            PopButton(
              fromTop: 32,
              onCancel: _isFullScreen
                  ? () {
                      _toggleFullscreen();
                    }
                  : () {
                      print("ON BACKKKK");
                      _controller?.pause(); // mute instantly

                      Navigator.pop(context);
                    },
            )
          ],
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: 16.0 / 9.0,
        child: Center(
            child: ProcessingIndicator(
          size: size.height * 0.0015,
        )),
      );
    }
  }

  allVideos(Size size, BuildContext blocContext) {
    return Container(
      height: size.height * 0.22,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: videos.length,
          itemBuilder: (context, index) {
            return _buildCard(index, size);
          }),
    );
  }

  Widget _controlView(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _centerUI(),
        ),
        _bottomUI()
      ],
    );
  }

  Widget _centerUI() {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          onPressed: () async {
            final index = _playingIndex - 1;
            if (index > 0 && videos.length > 0) {
              _initializeAndPlay(index);
            }
          },
          child: Icon(
            Icons.skip_previous, //changes
            size: 36.0,
            color: Colors.white,
          ),
        ),
        InkWell(
          onTap: () async {
            if (_isPlaying) {
              _controller?.pause();
              _isPlaying = false;
            } else {
              final controller = _controller;
              if (controller != null) {
                final pos = _position?.inSeconds ?? 0;
                final dur = _duration?.inSeconds ?? 0;
                final isEnd = pos == dur;
                if (isEnd) {
                  _initializeAndPlay(_playingIndex);
                } else {
                  controller.play();
                }
              }
            }
            setState(() {});
          },
          child: Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: MyTheme.primaryColor),
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              size: 45.0,
              color: Colors.white,
            ),
          ),
        ),
        FlatButton(
          onPressed: () async {
            final index = _playingIndex + 1;
            if (index < videos.length - 1) {
              _initializeAndPlay(index);
            }
          },
          child: Icon(
            Icons.skip_next, //changes
            size: 36.0,
            color: Colors.white,
          ),
        ),
      ],
    ));
  }

  String convertTwo(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  Widget _bottomUI() {
    final noMute = (_controller?.value?.volume ?? 0) > 0;
    final duration = _duration?.inSeconds ?? 0;
    final head = _position?.inSeconds ?? 0;
    final remained = max(0, duration - head);
    final minutes = convertTwo(remained ~/ 60.0);
    final sec = convertTwo(remained % 60);
    return Row(
      children: <Widget>[
        InkWell(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 4.0,
                      color: Color.fromARGB(50, 0, 0, 0)),
                ]),
                child: Icon(
                  noMute ? Icons.volume_up : Icons.volume_off,
                  color: Colors.white,
                )),
          ),
          onTap: () {
            if (noMute) {
              _controller?.setVolume(0);
            } else {
              _controller?.setVolume(1.0);
            }
            setState(() {});
          },
        ),
        SizedBox(width: 8),
        Text(
          "$minutes:$sec",
          style: TextStyle(
            color: Colors.white,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(0.0, 1.0),
                blurRadius: 4.0,
                color: Color.fromARGB(150, 0, 0, 0),
              ),
            ],
          ),
        ),
        Expanded(
          child: Slider(
            thumbColor: MyTheme.primaryColor,
            activeColor: MyTheme.primaryColor,
            inactiveColor: MyTheme.primaryColorWithAlpha120,
            value: max(0, min(_progress * 100, 100)),
            min: 0,
            max: 100,
            onChanged: (value) {
              setState(() {
                _progress = value * 0.01;
              });
            },
            onChangeStart: (value) {
              debugPrint("-- onChangeStart $value");
              _controller?.pause();
            },
            onChangeEnd: (value) {
              debugPrint("-- onChangeEnd $value");
              final duration = _controller?.value?.duration;
              if (duration != null) {
                var newValue = max(0, min(value, 99)) * 0.01;
                var millis = (duration.inMilliseconds * newValue).toInt();
                _controller?.seekTo(Duration(milliseconds: millis));
                _controller?.play();
              }
            },
          ),
        ),
        Padding(
          //changes
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
              onTap: _toggleFullscreen,
              child: Image.asset(
                STRETCH_SCREEN_ASSET,
                height: 25,
                width: 25,
              )),
        ),
      ],
    );
  }

  Widget _buildCard(int index, Size size) {
    final playing = index == _playingIndex;
    String runtime = "60";
    // if (clip.runningTime > 60) {
    //   runtime = "${clip.runningTime ~/ 60}분 ${clip.runningTime % 60}초";
    // } else {
    //   runtime = "${clip.runningTime % 60}초";
    // }
    return Container(
        margin: const EdgeInsets.only(right: 10),
        alignment: Alignment.center,
        height: size.height * 0.30,
        width: size.width * 0.6,
        decoration: BoxDecoration(
            color: MyTheme.black,
            image: DecorationImage(
                image: NetworkImage(videos[index].videoImage),
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
            ),
            Container(
              alignment: Alignment.center,
              // color: MyTheme.black38,
              height: size.height * 0.30,
              width: size.width,
              child: InkWell(
                onTap: () {
                  _onTapCard(index);
                },
                child: Container(
                    height: 45,
                    width: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: MyTheme.primaryColor),
                    child: Icon(playing ? Icons.pause : Icons.play_arrow,
                        color: MyTheme.white)),
              ),
            ),
          ],
        ));
  }
}




///////////
