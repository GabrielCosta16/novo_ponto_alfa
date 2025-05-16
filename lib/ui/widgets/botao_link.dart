import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: must_be_immutable
class BotaoLink extends StatelessWidget {
  String titulo;
  Color? textColor;
  Function? onClick;
  EdgeInsetsGeometry padding;
  bool? disabled;
  TextAlign? textAlign;
  TextStyle? textStyle;

  BotaoLink({
    super.key,
    required this.titulo,
    required this.onClick,
    this.textColor,
    this.padding = const EdgeInsets.all(0),
    this.disabled = false,
    this.textAlign = TextAlign.left,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: disabled ?? false,
      child: Padding(
        padding: padding,
        child: InkWell(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 6),
                  child: Text(
                    titulo,
                    textAlign: textAlign,
                    style: textStyle ??
                        TextStyle(
                          color: textColor ?? Color(0xFF3E4095),
                          decoration: TextDecoration.none,
                          fontSize: context.textTheme.bodySmall!.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            onClick?.call();
          },
        ),
      ),
    );
  }
}
