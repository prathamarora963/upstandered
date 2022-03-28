import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:upstanders/appState/view/router/route_generator.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

AndroidNotificationChannel channel;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


void main() async {

  // final client = await redis.Client.connect('redis://52.14.21.106:6379');

  // // Runs some commands.
  // final commands = client.asCommands<String, String>();

  // // SET key value
  // await commands.set('key', 'value');

  // // GET key
  // final value = await commands.get('key');
  // print(value);

  // // Disconnects.
  // await client.disconnect();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: MyTheme.primaryColor));
  runApp(MyApp());
}

final theme = ThemeData(
  textTheme: GoogleFonts.karlaTextTheme(),
  primaryColor: MyTheme.primaryColor,
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Upstanders',
      theme: theme,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: '/',
      localeListResolutionCallback: (locales, supportedLocales) {
        for (Locale locale in locales) {
          if (supportedLocales.contains(locale)) {
            return locale;
          }
        }
        return Locale('en', 'US');
      },
      supportedLocales: [
        Locale('en', 'US'),
      ],
      locale: Locale('en', 'US'),
    );
  }
}
