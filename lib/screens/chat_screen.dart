import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import'package:cloud_firestore/cloud_firestore.dart';
final _firestore=FirebaseFirestore.instance;
//ChatScreen Widgets
User loggedInUser;
class ChatScreen extends StatefulWidget {
  static const String id='chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController=TextEditingController();
  final _auth=FirebaseAuth.instance;

  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  // we use this to get the current users details from the database that way we can access the users information from the database using.
  void getCurrentUser()async{
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    }catch(e){
      print(e);
    }
  }

 /* void getMessages()async{
    final messages=await _firestore.collection('messages').get();//retrieving data from our firebase in this its the messages in messages collection we note updated about the chjanges that have occured we only pulling data in our collection at this very moment
    for(var message in messages.docs){//pulling messages from collection as value pairs
      print(message.data());
    }

  }*/

  void MessagesStream()async{//we using stream instead of the above to make it instant, look into streams if confused,its basically listening for changes to database and updating via stream of data snapshots.
    await for(var snapshot in  _firestore.collection('messages').snapshots()){// snapshots are like screen shots of our 'messages' collection.
      for(var message in snapshot.docs){//here we pulling out messages from our snapshot.docs and then printing out the key-value pairs of the messages from firestore.
        print(message.data());//printing data in our messages
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
               /* _auth.signOut();//signing the user out
                Navigator.pushNamed(context, LoginScreen.id);*/
                MessagesStream();

              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //Look deeper into Streams this is an example of flutter AsyncStreams different to firestore Streams LOOK IT Up!!
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(color:Colors.black),
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      //messageText +loggedInUser.email  we will upload these to FireBase
                      _firestore.collection('messages').add({
                        'text':messageText,
                        'sender':loggedInUser.email,
                        'time': FieldValue.serverTimestamp()
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:_firestore
          .collection('messages')
          .orderBy('time', descending: false)//add this
          .snapshots(),
      builder:(context,snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages=snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles=[];
        for(var message in messages){
          final messageText= message.data()['text'];
          final messageSender=message.data()['sender'];
          final messageTime = message.data()['time'] as Timestamp;
          final currentUser=loggedInUser.email;
          final messageBubble=MessageBubble(text: messageText,sender: messageSender,isMe: currentUser==messageSender,time: messageTime);
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0),

            children: messageBubbles,
          ),
        );

      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  final Timestamp time;
  MessageBubble({this.sender,this.text,this.isMe,this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children:<Widget> [
          Text(sender,style: TextStyle(fontSize: 12.0,color:Colors.black54),),
          Material(color:isMe? Colors.lightBlueAccent:Colors.white,
              elevation: 5.0,
              borderRadius:isMe? BorderRadius.only(topLeft: Radius.circular(30.0),bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30)):BorderRadius.only(topRight: Radius.circular(30.0),bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30)),

              child: Padding(
                padding:  EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                child: Text(text,style: TextStyle(fontSize: 15.0,color:isMe?Colors.white:Colors.black54)),
              )),
        ],
      ),
    );
  }
}

