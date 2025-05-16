import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RelogioAtual extends StatelessWidget {
  const RelogioAtual({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text("Carregando...");

        final horaAtual = snapshot.data!;
        final horaFormatada = DateFormat.Hms().format(horaAtual); // HH:mm:ss

        return Text(
          horaFormatada,
          style:context.textTheme.bodyLarge
              ?.copyWith(color: Colors.black45)
        );
      },
    );
  }
}
