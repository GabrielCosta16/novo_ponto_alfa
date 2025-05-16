import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Botao extends StatelessWidget {
  final String titulo;
  final Function() onClick;
  final Color? cor;
  final Color? corTexto;
  final IconData? icone;
  EdgeInsetsGeometry? padding;
  bool? disable;

  Botao({
    required this.titulo,
    required this.onClick,
    this.padding,
    this.icone,
    this.disable = false,
    this.cor,
    this.corTexto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MaterialButton(
          height: 50,
          onPressed: disable!
              ? null
              : () async {
                  onClick();
                },
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black54,
          color: cor ?? Color(0xFF3E4095),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconeBotao(),
              tituloBotao(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget tituloBotao(BuildContext context) {
    return Container(
      child: Expanded(
        child: Text(
          titulo,
          style: context.textTheme.titleSmall!
              .copyWith(color: corTexto ?? Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget iconeBotao() {
    return icone != null
        ? Icon(
            icone,
            color: Colors.white,
          )
        : SizedBox(
            height: 0,
          );
  }
}
