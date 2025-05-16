import 'package:flutter/material.dart';
import 'package:novo_ponto_alfa/domain/model/user/usuario.dart';
import 'package:novo_ponto_alfa/infra/core/preferences/preferencias.dart';
import 'package:novo_ponto_alfa/infra/rotas/rotas.dart';
import 'package:novo_ponto_alfa/ui/pages/home/page_home.dart';
import 'package:novo_ponto_alfa/ui/pages/login/ctrl_login.dart';
import 'package:novo_ponto_alfa/ui/pages/login/widgets/campo_cnpj.dart';
import 'package:novo_ponto_alfa/ui/pages/login/widgets/campo_email_login.dart';
import 'package:novo_ponto_alfa/ui/pages/login/widgets/campo_senha_login.dart';
import 'package:novo_ponto_alfa/ui/widgets/botao.dart';
import 'package:novo_ponto_alfa/ui/widgets/botao_link.dart';

class PageViewUsuario extends StatefulWidget {
  PageController pageController;
  CtrlLogin ctrlLogin;

  PageViewUsuario(
      {required this.ctrlLogin, required this.pageController, super.key});

  @override
  State<PageViewUsuario> createState() => _PageViewUsuarioState();
}

class _PageViewUsuarioState extends State<PageViewUsuario> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          children: [
            CampoCNPJ(widget.ctrlLogin.tecCnpj),
            const SizedBox(height: 16),
            CampoEmailLogin(widget.ctrlLogin.txcLoginEmail),
            const SizedBox(height: 16),
            CampoSenha(widget.ctrlLogin.txcLoginSenha),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: BotaoLink(titulo: "Esqueci a senha", onClick: () {}),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Botao(
                titulo: "Voltar",
                onClick: () {
                  widget.pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.bounceInOut,
                  );
                },
                cor: Colors.white,
                corTexto: Color(0xFF3E4095),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
                flex: 2,
                child: Botao(
                    titulo: "Entrar",
                    onClick: () async {
                      try {
                        await widget.ctrlLogin.onClickEntrarUsuario(context);
                        Usuario? usuario = await Preferences.usuarioLogado();
                        Rotas.irSemRetorno(
                            context,
                            PageHome(
                              titulo: usuario?.name ?? "",
                            ));
                      } catch (e) {
                        print(e);
                      }
                    })),
          ],
        ),
      ],
    );
  }
}
