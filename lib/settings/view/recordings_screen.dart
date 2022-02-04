import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/resource/file_resource.dart';
import 'package:upstanders/common/resource/time_ago.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upstanders/home/bloc/alert_bloc.dart';
import 'package:upstanders/home/data/model/get_current_alert_model.dart';
import 'package:upstanders/settings/constants/title_constants.dart';
import '../../common/resource/page_manager.dart';

List<Record> recordinds;

class RecordingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyTheme.primaryColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: MyTheme.secondryColor,
                ),
                onPressed: () => Navigator.of(context).pop()),
            Text(
              RECORDINGS,
              style: TextStyle(
                color: MyTheme.secondryColor,
              ),
            ),
          ],
        ),
      ),
      body: BlocProvider(
        create: (context) => AlertBloc()..add(GetOldAlerts()),
        child: BlocBuilder<AlertBloc, AlertState>(
          builder: (BuildContext context, AlertState state) {
            if (state.alertStatus == AlertStatus.gettingOldAlertsFailed ||
                state.alertStatus == AlertStatus.deletionAlertFailed) {
              return _OldAlertFailed(
                error: state.res['message'],
              );
            }
            if (state.alertStatus == AlertStatus.gotOldAlerts ||
                state.alertStatus == AlertStatus.deletedAlert ||
                state.alertStatus == AlertStatus.deletionAlert) {
              if (state.alertStatus == AlertStatus.deletedAlert) {
                BlocProvider.of<AlertBloc>(context).add(GetOldAlerts());
              }
              recordinds = [];
              List<AlertData> records =
                  BlocProvider.of<AlertBloc>(context).oldAlertModel;

              records.forEach((item) {
                recordinds.add(
                  Record(
                      alertId: item.id,
                      audio: item.audioFile,
                      title: item.type,
                      duration: item.duration,
                      addedTime: item.createAt,
                      isPlaying: false),
                );
              });
              return _bodyForm(state);
            }
            return Center(
              child: ShimmerLoadingAudioList(), //LottieLoadingBar
            );
          },
        ),
      ),
    );
  }

  _bodyForm(AlertState state) {
    return Stack(
      children: [
        _RecordingsForm(),
        state.alertStatus == AlertStatus.deletionAlert
            ? DeletionProcessBar()
            : Container()
      ],
    );
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

class _RecordingsForm extends StatefulWidget {
  @override
  __RecordingsFormState createState() => __RecordingsFormState();
}

class __RecordingsFormState extends State<_RecordingsForm> {
  AudioPlayer advancedPlayer = AudioPlayer();

  AudioCache audioCache = AudioCache();

  int myIndex = 0;

  @override
  void dispose() {
    super.dispose();
    advancedPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
            itemCount: recordinds.length,
            itemBuilder: (context, index) {
              return AudioTile(record: recordinds[index]);
              // return _audioTileBar(recordinds[index], index);
            }));
  }

  _audioTileBar(Record record, int index) {
    return ListTile(
        onTap: () => onAudioPlayer(recordinds[index], index),
        trailing: _trailingMenuBar(recordinds[index]),
        contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        leading: _leading(),
        title: _title(recordinds[index]));
  }

  onAudioPlayer(Record record, int index) {
    // showAudioPlayer(context, record.audio);

    setState(() {
      recordinds[index].isPlaying = !recordinds[index].isPlaying;
    });
    if (recordinds[index].isPlaying) {
      play(recordinds[index], index);
    } else {
      advancedPlayer.stop();
    }
  }

  _leading() {
    return Image.asset(
      RECORD_AUDIO_ASSET,
      height: 60,
      width: 60,
    );
  }

  _trailingMenuBar(Record record) {
    if (record.isPlaying) {
      return Image.asset(
        PLAYING_ASSET,
        height: 20,
        width: 20,
      );
    } else {
      return PopupMenuButton(
          elevation: 3,
          child: Image.asset(
            VERTICAL_MENU_ASSET,
            height: 20,
            width: 20,
          ),
          itemBuilder: (_) => <PopupMenuEntry<String>>[
                new PopupMenuItem(
                    value: "DELETE",
                    height: 10,
                    child: Row(
                      children: [
                        Text(
                          "DELETE",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 4),
                        Image.asset(
                          DELETE_ASSET,
                          height: 13,
                          width: 13,
                        ),
                      ],
                    ))
              ],
          onSelected: (val) => BlocProvider.of<AlertBloc>(context)
              .add(DeleteAlert(record.alertId.toString())));
    }
  }

  _title(Record record) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (record.title).toUpperCase(),
          style: TextStyle(
              color: MyTheme.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 2),
        Text(
          "Duration ${record.duration} min",
          style: TextStyle(
              fontSize: 11, color: MyTheme.black, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 2),
        Text(
          "${TimeAgo.timeAgoSinceDate(record.addedTime)}",
          style: TextStyle(
              fontSize: 11, color: MyTheme.grey, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  play(Record record, int index) async {
    var result = await advancedPlayer.play(record.audio).catchError((error) {
      Fluttertoast.showToast(msg: "Error While playing Audio :$error");
    });

    if (result == 1) {
      advancedPlayer.onPlayerCompletion.listen((event) {
        advancedPlayer.stop();
        setState(() => recordinds[index].isPlaying = false);
      });
    }
  }
}

class Record {
  int alertId;
  String audio;
  String title;
  String duration;
  String addedTime;
  bool isPlaying;
  Record(
      {this.alertId,
      this.audio,
      this.title,
      this.duration,
      this.addedTime,
      this.isPlaying});
}

///AUDIO PLAYER
class AudioTile extends StatefulWidget {
  final Record record;

  const AudioTile({Key key, this.record}) : super(key: key);

  @override
  _AudioTileState createState() => _AudioTileState();
}

class _AudioTileState extends State<AudioTile> {
  PageManager pageManager;
  @override
  void initState() {
    pageManager = PageManager(widget.record.audio);

    super.initState();
  }

  @override
  void dispose() {
    pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListTile(
        onTap: () => onAudioPlayer(),
        trailing: _trailingMenuBar(size),
        contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        leading: _leading(),
        title: _title(widget.record));
  }

  onAudioPlayer() {
    pageManager.play();
    showAudioPlayer(context, pageManager);
  }

  _leading() {
    final size = MediaQuery.of(context).size;
    return ValueListenableBuilder<ButtonState>(
      valueListenable: pageManager.buttonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return ProcessingIndicator(
              size: size.height * 0.0015,
            );
          case ButtonState.paused:
            return LeadingAsset();
          // leadingAsset();
          case ButtonState.playing:
            return PauseButton(
              onPause: () => pageManager.pause(),
            );
        }
        return ProcessingIndicator(
          size: size.height * 0.0015,
        );
      },
    );
  }

  _trailingMenuBar(Size size) {
    return ValueListenableBuilder<ButtonState>(
      valueListenable: pageManager.buttonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return ProcessingIndicator(
              size: size.height * 0.0015,
            );
          case ButtonState.paused:
            return _trailingMenu();
          case ButtonState.playing:
            return AudioPlayingBar();
          // _trailingAsset();
        }
        return ProcessingIndicator(
          size: size.height * 0.0015,
        );
      },
    );
  }

  _trailingAsset() {
    return Image.asset(
      PLAYING_ASSET,
      height: 20,
      width: 20,
    );
  }

  _trailingMenu() {
    return PopupMenuButton(
        elevation: 3,
        child: Image.asset(
          VERTICAL_MENU_ASSET,
          height: 20,
          width: 20,
        ),
        itemBuilder: (_) => <PopupMenuEntry<String>>[
              new PopupMenuItem(
                  value: "DELETE",
                  height: 10,
                  child: Row(
                    children: [
                      Text(
                        "DELETE",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 4),
                      Image.asset(
                        DELETE_ASSET,
                        height: 13,
                        width: 13,
                      ),
                    ],
                  ))
            ],
        onSelected: (val) => BlocProvider.of<AlertBloc>(context)
            .add(DeleteAlert(widget.record.alertId.toString())));
  }

  _title(Record record) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (record.title).toUpperCase(),
          style: TextStyle(
              color: MyTheme.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 2),
        Text(
          "Duration ${record.duration} min",
          style: TextStyle(
              fontSize: 11, color: MyTheme.black, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 2),
        Text(
          "${TimeAgo.timeAgoSinceDate(record.addedTime)}",
          style: TextStyle(
              fontSize: 11, color: MyTheme.grey, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
