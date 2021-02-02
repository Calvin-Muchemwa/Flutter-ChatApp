import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';

import 'screens/chat_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/login_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/welcome_screen.dart';

void main()async{

///This is very important to do when using firebase otherwise it will throw errors .
  WidgetsFlutterBinding.ensureInitialized();//The important stuff
  await Firebase.initializeApp();//The other important stuff we gotta use
  runApp(FlashChat());

}

class FlashChat extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.id,//note how we using static variables to tap into screen id's to avoid mistakes :)
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id:(context)=>ChatScreen(),
      },
    );
  }
}
