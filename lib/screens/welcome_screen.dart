import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/Components/buttons_card.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  //note how we used with to make our state class be able to act as ticker Provider for animations(Mixins)

  AnimationController controller;
  Animation animation; //to use curved animations such as bouncing etc

  @override
  void initState() {
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation = ColorTween(begin: Colors.grey, end: Colors.white).animate(
        controller); //look into tween animations they take beginning and end valuesgic
    super.initState();
    controller.forward();

    /*  animation.addStatusListener((status) {//this could help us detect when our animation has done do so we can apply some other animations maybe
      print(status);
    });*/

    controller.addListener(() {
      setState(() {
        //we dont have to put anything in our setstate as we already have the colour changing somewhere else
      });
      print(controller.value);
    });
  }

  @override
  void dispose() {
    //when screen is disposed do this,so cause animations run forever in the background wasting resources
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            ButtonsCard(
              colur: Colors.blue,
              title: Text('Log in'),
              OnPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            ButtonsCard(colur: Colors.blueAccent, OnPressed: (){
              Navigator.pushNamed(context, RegistrationScreen.id);
            }, title: Text('Register'))
          ],
        ),
      ),
    );
  }
}


