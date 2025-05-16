import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CampoSenha extends StatefulWidget {
  TextEditingController controller;
  Function(String)? onChanged;
  bool? exibirEsqueciSenha;

  CampoSenha(this.controller,
      {this.onChanged, this.exibirEsqueciSenha = false});

  @override
  _CampoSenhaState createState() => _CampoSenhaState();
}

class _CampoSenhaState extends State<CampoSenha> {
  bool obscureText = true;
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8),
          child: Text('Senha',
              style: context.textTheme.bodyMedium!.copyWith(
                  color: Colors.black54, fontWeight: FontWeight.w600)),
        ),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: 'Digite sua senha',
                hintStyle:
                    context.textTheme.bodySmall!.copyWith(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFF3E4095), width: 2),
                ),
                border: OutlineInputBorder(),
              ),
              maxLines: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                icon: obscureText
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
                color: obscureText ? Colors.grey : Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
