import 'package:flutter/material.dart';
import 'package:upstanders/appState/view/view.dart';
import 'package:upstanders/chat/pages/chat_screen.dart';
import 'package:upstanders/home/view/view.dart';
import 'package:upstanders/login/view/view.dart';
import 'package:upstanders/register/view/view.dart';
import 'package:upstanders/settings/view/view.dart';


class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case '/':
          return MaterialPageRoute(builder: (context) => App());
      
      case '/chat' :
       return MaterialPageRoute(builder: (context) => ChatScreen());
      

      case '/splash':
        return MaterialPageRoute(builder: (context) => SplashScreen());

       case '/onboarding':
        return MaterialPageRoute(builder: (context) => OnboardingScreen());

      case '/login':
              return MaterialPageRoute(builder: (context) => LoginScreen());

      case '/signup':
              return MaterialPageRoute(builder: (context) => SignUpScreen());

      // case '/verifyAccount': return MaterialPageRoute(builder: (context) => VerifyAccountScreen(number: )); 

      case '/home':
              return MaterialPageRoute(builder: (context) => HomeScreen());

      case '/profile':
              return MaterialPageRoute(builder: (context) => ProfileAccountScreen());
      
     case '/trainingVideos':
              return MaterialPageRoute(builder: (context) => TrainingVideos());


      case '/acronyms':
              return MaterialPageRoute(builder: (context) => AcronymsScreen());


      case '/reportedList':
              return MaterialPageRoute(builder: (context) => ReportedListScreen());


     case '/recordings':
              return MaterialPageRoute(builder: (context) => RecordingsScreen());
     
      default:
        return null;
    }
  }
}
