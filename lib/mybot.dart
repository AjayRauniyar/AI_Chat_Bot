import 'dart:convert';
import 'dart:io';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart'as http;
class mychatbot extends StatefulWidget {
  const mychatbot({super.key});

  @override
  State<mychatbot> createState() => _mychatbotState();
}

class _mychatbotState extends State<mychatbot> {
  ChatUser user=ChatUser(id: '1',firstName: 'Ajay');
  ChatUser bot=ChatUser(id: '2',firstName: 'Gemini');

  List<ChatUser> typing=[];

  List<ChatMessage> allMessages=[];
  final oururl='https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyBz2-4AHBls9DqmuZZ6qpHoFyZ0S16BxIk';
  final header={
    'Content-Type': 'application/json'
  };

  getdata(ChatMessage m) async {
    typing.add(bot);
    allMessages.insert(0, m);
    setState(() {

    });

    var data={"contents":[{"parts":[{"text":m.text}]}]};
    await http.post(Uri.parse(oururl),headers:header,body:jsonEncode(data))
        .then((value){
          if(value.statusCode==200){
               var result=jsonDecode(value.body);
               print(result['candidates'][0]['content']['parts'][0]['text']);
               ChatMessage m1=ChatMessage(
                   text: result['candidates'][0]['content']['parts'][0]['text'],
                   user: bot, createdAt: DateTime.now());

               allMessages.insert(0, m1);
               setState(() {

               });
          }else{
            print("error occured");
          }
    }).catchError((e){});
    typing.remove(bot);
    setState(() {

    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(


         title: const Text('AI Chat Bot'),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
      ),
      body: DashChat(
        typingUsers: typing,
        currentUser: user,
        onSend: (ChatMessage m) {
         getdata(m);
        },
        messages: allMessages,
      ),
    );
  }
}