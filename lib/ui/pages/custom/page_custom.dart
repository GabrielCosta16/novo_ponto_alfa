import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageCustom extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const PageCustom({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: context.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFf2f2f7), Color(0xFFd1d9f0)],
            ),
          ),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
