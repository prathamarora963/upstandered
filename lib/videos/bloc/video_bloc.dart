import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upstanders/core/constants.dart';
import 'package:upstanders/common/local/local_data_helper.dart';
import 'package:upstanders/common/model/quiz_model.dart';
import 'package:upstanders/home/data/model/video_model.dart';
import 'package:upstanders/common/repository/repository.dart';
import 'package:upstanders/videos/bloc/video_event.dart';
import 'package:upstanders/videos/bloc/video_state.dart';

class VideoQuizBloc extends Bloc<VideoQuizEvent, VideoState> {
  VideoQuizBloc() : super(VideoQuizInitial());
  Repository _repository = Repository();
  LocalDataHelper localDataHelper = LocalDataHelper();
  int index = 0;
  Map<int, String> answerMap = Map<int, String>();
  List<VideoModel> allVideos = [];
  VideoModel nextVideo = VideoModel();

  @override
  Stream<VideoState> mapEventToState(
    VideoQuizEvent event,
  ) async* {
    if (event is VideoQuizOpened) {
      var res = await _repository.getMcq();
      if (res['status'] == 200) {
        try {
          Map data = res['data'];

          bool next = data['next'];

          if (next) {
            var videoData = data['video'];
            var videoUrl = videoData['url'];
            var videoImage = videoData['video_image'];
            var questionData = List<dynamic>.from(data['questions']);
            List<Questions> questionList = [];
            questionData.forEach((element) {
              String question = element['question'];
              int videoId = element['video_id'];
              List<String> options = List<String>.from(element['options']);
              Questions questionObj = Questions(
                  options: options, question: question, videoId: videoId);
              questionList.add(questionObj);
            });

            QuizModel quizModel = QuizModel(
                videoImage: videoImage,
                videoLink: videoUrl,
                questions: questionList);
            yield VideoQuizLoadSuccess(quizModel);
          } else {
            localDataHelper.saveStringValue(
                key: Constants.ACCOUNT_STATUS, value: "3");
            yield VideoQuizCompleted();
          }
        } catch (e) {
          print("getMcqVideo1 $e");
        }
      } else {
        yield VideoQuizLoadFailure();
      }
      print(res.toString());
    } else if (event is VideoQuizAnswerSubmitted) {
      List<String> answerList = [];
      answerMap.forEach((key, value) {
        answerList.add(value);
      });
      var res = await _repository.submitAnswer(event.videoId, answerList);
      print("submitAnswer RESPONSEEEEEEEE  $res");
      if (res['status'] == 200) {
        answerMap = Map<int, String>();
        index = 0;
        add(VideoQuizOpened());
      } else {
        yield SubmitAnswerFailed();
      }
    } else if (event is GetAllVideoAndQuestions) {
      yield GettingAllVideos();
      var res = await _repository.getAllVideoAndQuestions();
      if (res['status'] == 200) {
        print("get All Video And Questions:$res");
        var videos = res['data'];

        videos.forEach((video) => allVideos.add(VideoModel.fromJson(video)));
        nextVideo = allVideos[0];

        yield GotAllVideos();
      } else {
        yield GettingAllVideosFailed(res['message']);
      }
    } else if (event is NextVideo) {
      yield GettingNextVideo();
      nextVideo = allVideos[event.index];

      yield GotNextVideo();
    }
  }
}
