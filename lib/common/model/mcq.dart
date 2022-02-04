class MCQ {
  String title;
  int option;

  MCQ({ this.title, this.option,});

  MCQ.fromJson(Map<String, dynamic> json) {
    option = json['option'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['option'] = this.option;
    data['title'] = this.title;
    return data;
  }
}
