abstract class VideoQuizEvent {}

class VideoQuizOpened extends VideoQuizEvent {
  @override
  String toString() {
    return "VideoQuizOpened";
  }
}

class VideoQuizAnswerSubmitted extends VideoQuizEvent {
  final int videoId;
  VideoQuizAnswerSubmitted(this.videoId);
  @override
  String toString() {
    return "VideoQuizAnswerSubmitted";
  }
}

class GetAllVideoAndQuestions extends VideoQuizEvent {
  @override
  String toString() {
    return "GetAllVideoAndQuestions";
  }
}

class NextVideo extends VideoQuizEvent {
  final int index;
  NextVideo(this.index);

  @override
  String toString() {
    return "NextVideo";
  }
}
