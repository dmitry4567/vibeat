import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class ConditionalMarquee extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double blankSpace;
  final double velocity;
  final Duration startAfter;
  final Duration pauseAfterRound;

  const ConditionalMarquee({super.key, 
    required this.text,
    required this.style,
    this.blankSpace = 30.0,
    this.velocity = 50.0,
    this.startAfter = const Duration(seconds: 2),
    this.pauseAfterRound = const Duration(seconds: 2),
  });

  bool _isTextOverflow(String text, TextStyle style, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: double.infinity);
    return textPainter.width > maxWidth;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isOverflow = _isTextOverflow(text, style, constraints.maxWidth);

        return SizedBox(
          width: constraints.maxWidth,
          height: 25,
          child: isOverflow
              ? Marquee(
                  text: text,
                  style: style,
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: blankSpace,
                  velocity: velocity,
                  startAfter: startAfter,
                  pauseAfterRound: pauseAfterRound,
                )
              : Text(
                  text,
                  style: style,
                  overflow: TextOverflow.clip,
                ),
        );
      },
    );
  }
}