import 'package:flutter/widgets.dart';

class TitleText extends Text {
  final String text;
  const TitleText(
    this.text, {
    Key? key,
  }) : super(
          key: key,
          text,
          // textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        );
}
