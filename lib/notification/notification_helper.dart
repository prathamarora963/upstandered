import 'package:firebase_messaging/firebase_messaging.dart';


class NotificationHelper {
  FirebaseMessaging fbMsg = FirebaseMessaging.instance;
  Future<String> getToken() {
    var token = fbMsg.getToken();
    return token;
  }

  
}
