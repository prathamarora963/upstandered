import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:upstanders/common/model/quiz_model.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/pop_button.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';
import 'package:upstanders/common/widgets/question_dialog_box.dart';
import 'package:upstanders/home/widgets/right_on-screen.dart';
import 'package:upstanders/home/widgets/uh_oh_screen.dart';
import 'package:upstanders/settings/view/view.dart';
import 'package:upstanders/videos/bloc/video_bloc.dart';
import 'package:upstanders/videos/bloc/video_event.dart';
import 'package:upstanders/videos/bloc/video_state.dart';
import 'package:upstanders/videos/components/video/video.dart';
import 'package:video_player/video_player.dart';

QuizModel quizModel;
int index = 0;
BuildContext buildContext;

class VideosStreamingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: MyTheme.primaryColor,
          automaticallyImplyLeading: false,
          title: Text(
            "WATCH VIDEO AND MCQ",
            style: TextStyle(
              color: MyTheme.secondryColor,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: MyTheme.secondryColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        //
        backgroundColor: MyTheme.secondryColor,
        body: BlocProvider(
          create: (context) => VideoQuizBloc(),
          child: BlocConsumer<VideoQuizBloc, VideoState>(
            listener: (context, state) {},
            builder: (context, state) {
              buildContext = context;
              if (state is VideoQuizLoadSuccess) {
                quizModel = state.quizModel;
                index = BlocProvider.of<VideoQuizBloc>(context).index;
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  streamingVideo(context, quizModel.videoLink);
                });

                return QuizVideo();
              } else if (state is VideoQuizCompleted) {
                Future.delayed(Duration(seconds: 1), () {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => RightOnScreen()));
                  });
                });
                return Center(
                  child: ProcessingIndicator(
                    size: size.height * 0.0015,
                  ),
                );
              } else if (state is SubmitAnswerFailed) {
                Fluttertoast.showToast(msg: "SubmitAnswerFailed");
                Future.delayed(Duration(seconds: 1), () {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => UHOHScreen()));
                  });
                });
                return Center(
                  child: ProcessingIndicator(
                    size: size.height * 0.0015,
                  ),
                );
              } else {
                if (state is VideoQuizInitial) {
                  print(state);
                  BlocProvider.of<VideoQuizBloc>(context)
                      .add(VideoQuizOpened());
                }

                return Center(
                  child: ProcessingIndicator(
                    size: size.height * 0.0015,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class QuizVideo extends StatefulWidget {
  QuizVideo();
  @override
  _QuizVideoState createState() => _QuizVideoState();
}

class _QuizVideoState extends State<QuizVideo> {
  final scrollDirection = Axis.horizontal;
  AutoScrollController controller;
  int groupIndex = -1;
  String answer = "";

  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.01),
                videosList(quizModel.videoLink, quizModel.videoImage),
                SizedBox(height: size.height * 0.01),
                Text(" MCQ",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: MyTheme.white)),
                SizedBox(height: size.height * 0.01),
                MCQDialogBox(
                  index: index,
                  totalMCQlength: quizModel.questions.length,
                  question: quizModel.questions.elementAt(index),
                  optionsList: optionsList(
                    quizModel.questions.elementAt(index),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                //  Spacer(),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        if (groupIndex != -1) {
                          if (index + 1 == quizModel.questions.length) {
                            groupIndex = -1;

                            BlocProvider.of<VideoQuizBloc>(buildContext)
                                .answerMap[index] = answer;

                            BlocProvider.of<VideoQuizBloc>(buildContext).add(
                                VideoQuizAnswerSubmitted(quizModel.questions
                                    .elementAt(index)
                                    .videoId));
                          } else {
                            BlocProvider.of<VideoQuizBloc>(buildContext)
                                .answerMap[index] = answer;
                            index = index + 1;
                            BlocProvider.of<VideoQuizBloc>(buildContext).index =
                                index;
                            // streamingVideo(quizModel.videoLink);

                            setState(() {
                              groupIndex = -1;
                            });
                          }
                        } else {
                          Fluttertoast.showToast(msg: "select option");
                        }
                      },
                      child: Container(
                        height: size.height * 0.07,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: MyTheme.primaryColor,
                        ),
                        child: Text(
                          index + 1 == quizModel.questions.length
                              ? "Submit"
                              : "Next",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17.0),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  optionsList(Questions questions) {
    return ListView.builder(
      itemCount: questions.options.length,
      itemBuilder: (context, i) {
        return Container(
          margin: const EdgeInsets.only(bottom: 5),
          child: RadioListTile(
            activeColor: MyTheme.primaryColor,
            value: i,
            groupValue: groupIndex,
            onChanged: (newValue) {
              quizAnswer(i);
              setState(() {
                groupIndex = i;
              });
            },
            title: Text(questions.options.elementAt(i)),
          ),
        );
      },
    );
  }

  void quizAnswer(int i) {
    switch (i) {
      case 0:
        answer = "a";
        break;
      case 1:
        answer = "b";
        break;
      case 2:
        answer = "c";
        break;
      case 3:
        answer = "d";
        break;
      case 4:
        answer = "e";
        break;
      case 5:
        answer = "f";
        break;
      default:
        answer = "";
    }
  }

  videosList(String videoUrl, String imageUrl) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.25,
      child: _videoComponent(videoUrl, imageUrl),
    );
  }

  Widget _videoComponent(String videoUrl, String imageUrl) {
    final size = MediaQuery.of(context).size;
    return _wrapScrollTag(
      index: 0,
      child: Container(
          margin: const EdgeInsets.only(right: 10, left: 10),
          color: MyTheme.white,
          alignment: Alignment.center,
          height: size.height * 0.33,
          width: size.width * 0.95,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
              ),
              Container(
                alignment: Alignment.center,
                height: size.height * 0.33,
                width: size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(imageUrl), fit: BoxFit.cover),
                ),
                child: InkWell(
                  onTap: () {
                    showGeneralDialog(
                      barrierLabel: "Barrier",
                      barrierDismissible: false,
                      barrierColor: Colors.black.withOpacity(0.5),
                      transitionDuration: Duration(milliseconds: 700),
                      context: context,
                      pageBuilder: (_, __, ___) {
                        return Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: EdgeInsets.only(
                              top: 85,
                            ),
                            child: VideoDialogBox(
                              videoAsset: videoUrl,
                            ),
                          ),
                        );
                      },
                      transitionBuilder: (_, anim, __, child) {
                        return SlideTransition(
                          position:
                              Tween(begin: Offset(0, -1), end: Offset(0, 0))
                                  .animate(anim),
                          child: child,
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: MyTheme.primaryColor),
                    child: Icon(
                      Icons.play_arrow,
                      size: 40,
                      color: MyTheme.white,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _wrapScrollTag({int index, Widget child}) => AutoScrollTag(
        key: ValueKey(index),
        controller: controller,
        index: index,
        child: child,
        highlightColor: Colors.black.withOpacity(0.1),
      );
}

class VideoDialogBox extends StatefulWidget {
  final String videoAsset;

  const VideoDialogBox({Key key, this.videoAsset}) : super(key: key);

  @override
  State<VideoDialogBox> createState() => _VideoDialogBoxState();
}

class _VideoDialogBoxState extends State<VideoDialogBox> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        alignment: Alignment.center,
        color: MyTheme.primaryColor, //black38
        height: size.height * 0.38,
        width: size.width,
        child: Material(
            child: PlayerView(
          videourl: widget.videoAsset,
        )
            //     MyVideoPlayer(
            //   videoAsset: widget.videoAsset,
            // )
            ));
  }
}

class PlayerView extends StatefulWidget {
  final String videourl;

  const PlayerView({Key key, this.videourl}) : super(key: key);

  @override
  _PlayerViewState createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  VideoPlayerController _controller;
  String get video => widget.videourl;

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
    _initializeAndPlay();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    disposing();
  }

  disposing() {
    _disposed = true;
    _timerVisibleControl?.cancel();
    // Wakelock.disable();

    _controller?.pause(); // mute instantly
    _controller?.dispose();
    _controller = null;
  }

  void _initializeAndPlay() async {
    final clip = video;
    final controller = VideoPlayerController.network(clip);

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
            "========================== End of Clip  ========================== ");
        _initializeAndPlay();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Center(child: _playView(context, size)),
      decoration: BoxDecoration(color: Colors.black),
    );
  }

  Widget _playView(BuildContext context, Size size) {
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
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
              fromTop: 0,
              onCancel: () {
                controller?.pause();
                Navigator.pop(context);
              },
            ),
            _durationView()
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

  _durationView() {
    final duration = _duration?.inSeconds ?? 0;
    final head = _position?.inSeconds ?? 0;
    final remained = max(0, duration - head);
    final minutes = convertTwo(remained ~/ 60.0);
    final sec = convertTwo(remained % 60);
    return Positioned(
      top: 10,
      right: 10,
      child: Text(
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
                  _initializeAndPlay();
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
      ],
    ));
  }

  String convertTwo(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  Widget _bottomUI() {
    final noMute = (_controller?.value?.volume ?? 0) > 0;
    // final duration = _duration?.inSeconds ?? 0;
    // final head = _position?.inSeconds ?? 0;
    // final remained = max(0, duration - head);
    // final minutes = convertTwo(remained ~/ 60.0);
    // final sec = convertTwo(remained % 60);
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
        // SizedBox(width: 8),
        // Text(
        //   "$minutes:$sec",
        //   style: TextStyle(
        //     color: Colors.white,
        //     shadows: <Shadow>[
        //       Shadow(
        //         offset: Offset(0.0, 1.0),
        //         blurRadius: 4.0,
        //         color: Color.fromARGB(150, 0, 0, 0),
        //       ),
        //     ],
        //   ),
        // ),
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
      ],
    );
  }
}

class MyVideoPlayer extends StatefulWidget {
  final String videoAsset;

  const MyVideoPlayer({Key key, this.videoAsset}) : super(key: key);
  @override
  _MyVideoPlayerState createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer>
    with SingleTickerProviderStateMixin {
  VideoPlayerController _controller;
  AnimationController aniController;
  String sDuration = "00:00";

  @override
  void initState() {
    super.initState();

    aniController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 400),
    );
    _controller = VideoPlayerController.network(widget.videoAsset)
      ..initialize().then((_) {
        _controller.addListener(() {
          setState(() {
            sDuration =
                "${_controller.value.position.inMinutes.remainder(60)}:${(_controller.value.position.inSeconds.remainder(60))}";
            print("postion:$sDuration");
            if (_controller.value.isInitialized &&
                (_controller.value.duration == _controller.value.position)) {
              setState(() {});

              Navigator.of(context).pop();
            }
          });
        });
      });
    _controller.play();
    aniController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.pause();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      height: size.height * 0.38,
      width: size.width,
      color: MyTheme.primaryColor,
      child: Stack(
        children: [
          _controller.value.isInitialized ? _body(size) : _progressingBar(size)
        ],
      ),
    );
  }

  _body(Size size) {
    return Stack(
      children: [
        _videoViewer(),
        _videoTimeTicker(),
        _videoControllerComponents(size),
      ],
    );
  }

  _progressingBar(Size size) {
    return Align(
        alignment: Alignment.center,
        child: ProcessingIndicator(
            size: size.height * 0.0015, processColor: MyTheme.white));
  }

  _videoViewer() {
    return Center(
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      ),
    );
  }

  _videoTimeTicker() {
    return Positioned(
        top: 10,
        right: 10,
        child: Text(
          sDuration,
          style: TextStyle(fontWeight: FontWeight.bold, color: MyTheme.white),
        ));
  }

  _videoControllerComponents(Size size) {
    return !_controller.value.isBuffering
        ? Center(child: _playPauseButton())
        : _progressingBar(size);
  }

  _playPauseButton() {
    return InkWell(
      onTap: () {
        setState(() {
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();

          _controller.value.isPlaying
              ? aniController.forward()
              : aniController.reverse();
        });
      },
      child: Container(
          height: 45,
          width: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: MyTheme.primaryColor),
          child: AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            progress: aniController,
            size: 40,
            color: MyTheme.white,
          )),
    );
  }
}

streamingVideo(BuildContext context, String videoUrl) {
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.8),
    transitionDuration: Duration(milliseconds: 700),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.only(
            top: 85,
          ),
          child: VideoDialogBox(
            videoAsset: videoUrl,
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim),
        child: child,
      );
    },
  );
}
