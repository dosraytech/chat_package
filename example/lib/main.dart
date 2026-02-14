import 'package:chat_package/chat_package.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/models/media/chat_media.dart';
import 'package:chat_package/models/media/media_type.dart';
import 'package:example/constants/app_constants.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Ui example',
      theme: ThemeData(
        primaryColor: const Color(0xFF075E54),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final textEditingController = TextEditingController();



  final messages = [
    ChatMessage(text: 'Good Morning!', isSender: true),
    ChatMessage(text: 'Hello, How are you?', isSender: false),
    ChatMessage(
      isSender: true,
      text: 'This is you cat.',
      chatMedia:  ChatMedia(
        url: AppConstants.image,
        mediaType: MediaType.imageMediaType(),
      ),
    ),
    ChatMessage(
      text: '',
      isSender: false,
      chatMedia: const ChatMedia(
        url: AppConstants.voice,
        mediaType: MediaType.audioMediaType(),
      ),
    ),
    ChatMessage(
      text: '',
      isSender: true,
      chatMedia: const ChatMedia(
        url: AppConstants.voice,
        mediaType: MediaType.audioMediaType(),
      ),
    ),
  ];

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Chat Example', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      body: ChatScreen(
        messages: messages,
        isAudioFile: true,
        senderTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        receiverTextStyle: textTheme.bodyMedium,
        receiverColor: Colors.grey,
        senderColor: Colors.green,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(50),
        ),
        scrollController: ScrollController(),
        onRecordComplete: (audioMessage) {
          messages.add(audioMessage);
          setState(() {});
        },
        onImageSelected: (imageMessage) {
          messages.add(imageMessage);
          setState(() {});
        },
        textEditingController: textEditingController,
        onTextSubmit: (textMessage) {
          messages.add(textMessage);
          setState(() {});
        },
      ),
    );
  }
}
