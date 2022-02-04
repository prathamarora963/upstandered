import 'package:upstanders/common/model/quiz_model.dart';

abstract class VideoState {}

class VideoQuizInitial extends VideoState {
  @override
  String toString() {
    return "VideoQuizInitial";
  }
}

class VideoQuizLoadInProgress extends VideoState {
  @override
  String toString() {
    return "VideoQuizLoadInProgress";
  }
}

class VideoQuizLoadSuccess extends VideoState {
  final QuizModel quizModel;
  VideoQuizLoadSuccess(this.quizModel);
  @override
  String toString() {
    return "VideoQuizLoadSuccess";
  }
}

class VideoQuizCompleted extends VideoState {
  VideoQuizCompleted();
  @override
  String toString() {
    return "VideoQuizCompleted";
  }
}

class VideoQuizLoadFailure extends VideoState {
  @override
  String toString() {
    return "VideoQuizLoadFailure";
  }
}

class SubmitAnswerFailed extends VideoState {
  @override
  String toString() {
    return "SubmitAnswerFailed";
  }
}

class GettingAllVideos extends VideoState {
  @override
  String toString() {
    return "GettingAllVideos";
  }
}

class GotAllVideos extends VideoState {
  @override
  String toString() {
    return "GotAllVideos";
  }
}

class GettingAllVideosFailed extends VideoState {
  final error;

  GettingAllVideosFailed(this.error);
  @override
  String toString() {
    return "GettingAllVideosFailed";
  }
}

class GettingNextVideo extends VideoState {
 
  @override
  String toString() {
    return "GettingNextVideo";
  }
}


class GotNextVideo extends VideoState {
 
  @override
  String toString() {
    return "GotNextVideo";
  }
}

class GotNextVideoFailed extends VideoState {
 
  @override
  String toString() {
    return "GotNextVideoFailed";
  }
}


