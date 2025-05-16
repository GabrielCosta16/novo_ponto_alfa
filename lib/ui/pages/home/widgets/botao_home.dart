import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BotaoHome extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final VoidCallback onClick;

  BotaoHome(this.titulo, this.icone, this.onClick);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onClick,
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 48, color: Colors.red.shade800),
            const SizedBox(height: 24),
            Text(
              titulo,
              style: context.textTheme.titleSmall?.copyWith( fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
