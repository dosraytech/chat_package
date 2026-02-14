import 'package:flutter/material.dart';

/// Style configuration for [RecordingButton].
class RecordingButtonStyle {
  /// Background color of the button.
  final Color buttonColor;

  /// Color of the icon.
  final Color iconColor;

  /// Size of the icon.
  final double iconSize;

  /// Inner padding around the icon.
  final EdgeInsets padding;

  /// Icon to show when [hasText] is true.
  final IconData sendIcon;

  /// Icon to show when [hasText] is false.
  final IconData micIcon;

  /// Optional decoration for the button container (overrides [buttonColor] & shape).
  final BoxDecoration? decoration;

  /// Duration of the icon switch animation.
  final Duration switchDuration;

  /// Animation curve for the icon switch.
  final Curve switchCurve;

  /// Icon to show when recording.
  final IconData stopIcon;

  const RecordingButtonStyle({
    this.buttonColor = const Color(0xFF075E54),
    this.iconColor = Colors.white,
    this.iconSize = 24.0,
    this.padding = const EdgeInsets.all(12),
    this.sendIcon = Icons.send,
    this.micIcon = Icons.mic,
    this.stopIcon = Icons.send,
    this.decoration,
    this.switchDuration = const Duration(milliseconds: 200),
    this.switchCurve = Curves.easeInOut,
  });
}

/// A customizable recording/send button with drag‑offset support.
///
/// - Shows a mic icon when [hasText] is false, or a send icon when true.
/// - Animates icon changes via an [AnimatedSwitcher].
/// - Applies a horizontal [dragOffset] translation.
/// - Exposes full styling via [style].
class RecordingButton extends StatelessWidget {
  /// Horizontal drag offset (negative moves left).
  final double dragOffset;

  /// Called on long‑press start (begin recording).
  final GestureLongPressStartCallback onLongPressStart;

  /// Called as the finger moves during a long press.
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;

  /// Called on long‑press end (stop recording).
  final GestureLongPressEndCallback? onLongPressEnd;

  /// Called on normal tap (send text).
  final VoidCallback onTap;

  /// Whether there’s text to send (switches to send icon).
  final bool hasText;

  /// Styling parameters.
  final RecordingButtonStyle style;

  /// Whether the recorder is active (shows stop icon).
  final bool isRecording;

  const RecordingButton({
    Key? key,
    required this.dragOffset,
    required this.onLongPressStart,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    required this.onTap,
    required this.hasText,
    required this.isRecording,
    this.style = const RecordingButtonStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deco =
        style.decoration ??
        BoxDecoration(color: style.buttonColor, shape: BoxShape.circle);

    // Determine which icon to show based on state
    final IconData currentIcon = hasText
        ? style.sendIcon
        : (isRecording ? style.stopIcon : style.micIcon);

    // The GestureDetector is now much simpler
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: style.switchDuration,
        switchInCurve: style.switchCurve,
        switchOutCurve: style.switchCurve,
        child: Container(
          // Use the icon as the key to ensure the animation triggers
          key: ValueKey<IconData>(currentIcon),
          decoration: deco,
          padding: style.padding,
          child: Icon(
            currentIcon,
            color: style.iconColor,
            size: style.iconSize,
          ),
        ),
      ),
    );
  }
}
