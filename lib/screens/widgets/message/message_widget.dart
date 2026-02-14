import 'package:chat_package/controllers/voice_controller.dart';
import 'package:chat_package/screens/voice_message_view.dart';
import 'package:chat_package/screens/widgets/message/audio_message/audio_message_widget.dart';
import 'package:chat_package/screens/widgets/message/date_time_widget.dart';
import 'package:chat_package/screens/widgets/message/image_message/image_message_widget.dart';
import 'package:chat_package/screens/widgets/message/text_message/text_message_widget.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/utils/constants.dart';
import 'package:flutter/material.dart';

/// A chat bubble that renders text, image, audio (or future video) messages,
/// along with a timestamp.
///
/// Aligns to the right for sender messages and to the left for receiver messages,
/// applying distinct bubble colors and styles.
class MessageWidget extends StatelessWidget {
  /// Data for this chat message (text, media, timestamp, sender flag).
  final ChatMessage message;

  /// Bubble color for messages sent by the user.
  final Color senderColor;

  /// Bubble color for messages received from others.
  final Color receiverColor;

  /// Inactive track color for audio message slider.
  final Color inactiveAudioSliderColor;

  /// Active track color for audio message slider.
  final Color activeAudioSliderColor;

  /// Optional text style applied inside image message containers.
  final TextStyle? senderTextStyle;

  /// Optional text style applied inside image message containers.
  final TextStyle? receiverTextStyle;

  /// Optional style for the timestamp text.
  final TextStyle? sendDateTextStyle;

  /// Optional text direction
  final TextDirection? textDirection;

  /// Optional voice source type [url, file]
  final bool? isAudioFile;

  /// Creates a [MessageWidget].
  ///
  /// All color parameters are required to ensure consistent theming.
  const MessageWidget({
    Key? key,
    required this.message,
    required this.senderColor,
    required this.receiverColor,
    required this.inactiveAudioSliderColor,
    required this.activeAudioSliderColor,
    this.senderTextStyle,
    this.receiverTextStyle,
    this.textDirection,
    this.sendDateTextStyle,
    this.isAudioFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSender = message.isSender;
    final Alignment alignment = isSender
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final CrossAxisAlignment crossAxisAlignment = isSender
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final Color bubbleColor = isSender ? senderColor : receiverColor;

    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Align(
        alignment: alignment,
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            _buildContent(bubbleColor, isSender),
            const SizedBox(height: 3),
            DateTimeWidget(
              message: message,
              sendDateTextStyle: sendDateTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  /// Chooses and returns the correct content widget based on [message].
  ///
  /// - Text messages render with [TextMessageWidget].
  /// - Image messages use [ImageMessageWidget].
  /// - Audio messages use [AudioMessageWidget].
  /// - Video messages are not yet implemented.
  Widget _buildContent(Color bubbleColor, bool isSender) {
    if (message.chatMedia == null) {
      return TextMessageWidget(
        message: message,
        senderColor: bubbleColor,
        style: isSender ? senderTextStyle : receiverTextStyle,
        textDirection: textDirection,
      );
    }

    return message.chatMedia!.mediaType.when(
      imageMediaType: () => ImageMessageWidget(
        message: message,
        senderColor: bubbleColor,
        messageContainerTextStyle: isSender
            ? senderTextStyle
            : receiverTextStyle,
      ),
      /*audioMediaType: () => AudioMessageWidget(
        message: message,
        senderColor: bubbleColor,
        inactiveAudioSliderColor: inactiveAudioSliderColor,
        activeAudioSliderColor: activeAudioSliderColor,
      ),*/
      audioMediaType: () => VoiceMessageView(
        circlesColor: isSender ? Colors.white : senderColor,
        activeSliderColor: isSender ? Colors.white : bubbleColor,
        backgroundColor: isSender ? bubbleColor : Colors.grey.shade100,
        playIcon: Icon(
          Icons.play_arrow,
          color: isSender ? bubbleColor : Colors.white,
        ),
        pauseIcon: Icon(
          Icons.pause,
          color: isSender ? bubbleColor : Colors.white,
        ),
        counterTextStyle: TextStyle(
          color: isSender ? Colors.white : Colors.grey,
        ),
        circlesTextStyle: TextStyle(
          color: isSender ? bubbleColor : Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
        controller: VoiceController(
          audioSrc: message.chatMedia!.url,
          onComplete: () {},
          onPause: () {},
          onPlaying: () {},
          onError: (err) {},
          maxDuration: const Duration(seconds: 60),
          // isFile: isAudioFile ?? true,
          isFile: message.chatMedia!.url.startsWith('http') ? false : true,
        ),
        innerPadding: 12,
        cornerRadius: 20,
      ),
      videoMediaType: () {
        // TODO: Replace with VideoMessageWidget when available
        return const SizedBox.shrink();
      },
    );
  }
}
