import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/Components/buttons_card.dart';
import 'package:flash_chat/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';//note how we initial id in LoginScreen stful intstead of in state
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth=FirebaseAuth.instance;
  String email;
  String password;
  bool _showSpinner=false;

  void _submti(){
    setState(() {
      _showSpinner=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                onChanged: (value) {
                  email=value;
                },
                decoration: kDecorationTextField.copyWith(hintText: 'Enter your E-mail')
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  style: TextStyle(color: Colors.black),
                  obscureText: true,
                  textAlign: TextAlign.center,
                onChanged: (value) {
                  password=value;
                },
                decoration: kDecorationTextField.copyWith(hintText: 'Enter your Password')
              ),
              SizedBox(
                height: 24.0,
              ),
              ButtonsCard(
                  colur: Colors.lightBlueAccent,
                  OnPressed: () async{
                   _submti();
                    try {
                      final newUser = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);//  Firebase is so nice no need to worry about DataBase Api's :)
                      if(newUser!=null){
                        setState(() {
                          _showSpinner=false;
                        });
                        Navigator.pushNamed(context, ChatScreen.id);
                      }

                    }catch(e){
                      print(e);
                    }

                  },
                  title: Text('Log In'))
            ],
          ),
        ),
      inAsyncCall: _showSpinner,),
    );
  }
}

