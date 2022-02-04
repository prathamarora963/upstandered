class QuizModel {
  final String videoLink;
  final String videoImage;
  final List<Questions> questions;

  QuizModel({this.videoLink, this.videoImage, this.questions});

  @override
  String toString() {
    return "$videoLink $videoImage $questions";
  }
}

class Questions {
  final int videoId;
  final String question;
  final List<String> options;
  Questions({this.options, this.videoId, this.question});

  @override
  String toString() {
    return "$videoId $question $options";
  }
}
