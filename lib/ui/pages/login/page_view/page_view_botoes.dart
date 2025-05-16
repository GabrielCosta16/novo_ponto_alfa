import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novo_ponto_alfa/ui/pages/login/ctrl_login.dart';
import 'package:novo_ponto_alfa/ui/pages/login/page_view/page_view_empresa.dart';
import 'package:novo_ponto_alfa/ui/pages/login/page_view/page_view_usuario.dart';
import 'package:novo_ponto_alfa/ui/widgets/botao.dart';

class PageViewBotoes extends StatefulWidget {
  final PageController pageController;
  CtrlLogin ctrlLogin;

  PageViewBotoes(
      {super.key, required this.ctrlLogin, required this.pageController});

  @override
  State<PageViewBotoes> createState() => _PageViewBotoesState();
}

class _PageViewBotoesState extends State<PageViewBotoes> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: _addLogo()),
        Expanded(
          child: PageView(
            controller: widget.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _addBotoes(),
              PageViewEmpresa(
                pageController: widget.pageController,
                ctrlLogin: widget.ctrlLogin,
              ),
              PageViewUsuario(
                ctrlLogin: widget.ctrlLogin,
                pageController: widget.pageController,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _addLogo() {
    return Image.asset(
      "assets/img/clock-logo.png",
      height: 100,
    );
  }


  Widget _addBotoes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Como deseja acessar?",
              style: context.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            _addBotaoEmpresa(),
            _addDivisor(),
            _addBotaoUsuario(),
          ],
        ),
      ],
    );
  }



  Widget _addBotaoEmpresa() {
    return Botao(
      titulo: "Empresa",
      onClick: () {
        widget.pageController.animateToPage(
          1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  Widget _addBotaoUsuario() {
    return Botao(
      titulo: "Usuario",
      onClick: () {
        widget.pageController.animateToPage(
          2,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      cor: Colors.white,
      corTexto: Color(0xFF3E4095),
    );
  }

  Widget _addDivisor() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: Divider(color: Color(0xFF3E4095))),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("ou"),
          ),
          Expanded(child: Divider(color: Color(0xFF3E4095))),
        ],
      ),
    );
  }
}
