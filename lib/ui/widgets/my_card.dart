import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCard extends StatelessWidget {
  Widget estrutura;
  Color? color;
  Color? backgroundColor;
  bool isCardStatus;

  MyCard(
      {super.key,
      required this.estrutura,
      this.color,
      this.backgroundColor,
      this.isCardStatus = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor ?? context.theme.dialogBackgroundColor,
                borderRadius: BorderRadius.circular(10),
                border: isCardStatus
                    ? Border(
                        left:
                            BorderSide(color: color ?? Colors.blue, width: 10))
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: estrutura,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
