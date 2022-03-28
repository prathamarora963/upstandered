// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';
//
// class MqqtServices{
//   MqttServerClient client =
//   MqttServerClient.withPort('52.14.21.106', 'android', 1883);
//
//   Future<MqttServerClient> connect() async {
//     client.logging(on: false);
//     client.onConnected = onConnected;
//     client.keepAlivePeriod = 20;
//     client.onDisconnected = onDisconnected;
//     //client.onUnsubscribed = onUnsubscribed as UnsubscribeCallback;
//     client.onSubscribed = onSubscribed;
//     client.onSubscribeFail = onSubscribeFail;
//     client.pongCallback = pong;
//
//     final connMessage = MqttConnectMessage()
//         .authenticateAs('username', 'password')
//         .withWillTopic('willtopic')
//         .withWillMessage('Will message')
//         .startClean()
//         .withWillQos(MqttQos.atLeastOnce);
//     client.connectionMessage = connMessage;
//     try {
//       await client.connect();
//     } catch (e) {
//       print('Exception: $e');
//       client.disconnect();
//     }
//
//     client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
//       final  MqttPublishMessage message = c[0].payload as MqttPublishMessage;
//
//       print('Messaged:' + message.toString());
//
//       final payload = message.toString();
//
//       print('Received message:$payload from topic: ${c[0].topic}>');
//     });
//
//     return client;
//   }
//
//   void onConnected() {
//     print('Connected');
//   }
//
//   void onDisconnected() {
//     print('Disconnected');
//   }
//
//   void onSubscribed(String topic) {
//     print('Subscribed topic: $topic');
//   }
//
//   void onSubscribeFail(String topic) {
//     print('Failed to subscribe $topic');
//   }
//
//   void pong() {
//     print('Ping response client callback invoked');
//   }
// }