

class VideoModel {
  int id;
  String url;
  int videoId;
  String videoImage;
  

  VideoModel({this.id, this.url, this.videoId, this.videoImage,});

  VideoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    videoId = json['video_id'];
    videoImage = json['video_image'];
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['video_id'] = this.videoId;
    data['video_image'] = this.videoImage;
    
    return data;
  }
}

