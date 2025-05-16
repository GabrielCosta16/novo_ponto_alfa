
import 'package:flutter/material.dart';

class TextWidget extends StatefulWidget {
  TextWidget({
    Key? key,
    this.text,
  }) : super(key: key);

  Text? text;

  _TextWidgetState? state;

  @override
  State<StatefulWidget> createState() => state = _TextWidgetState();

  _TextWidgetState? getState() => state;
}

class _TextWidgetState extends State<TextWidget> {
  void refresh(String text) {
    var newText = Text(text);
    if (mounted) {
      setState(() {
        widget.text = newText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.text!;
  }
}
