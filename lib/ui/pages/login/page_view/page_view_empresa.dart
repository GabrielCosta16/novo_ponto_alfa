import 'package:flutter/material.dart';
import 'package:novo_ponto_alfa/domain/model/empresa/empresa.dart';
import 'package:novo_ponto_alfa/infra/core/preferences/preferencias.dart';
import 'package:novo_ponto_alfa/infra/rotas/rotas.dart';
import 'package:novo_ponto_alfa/ui/pages/home/page_home.dart';
import 'package:novo_ponto_alfa/ui/pages/login/ctrl_login.dart';
import 'package:novo_ponto_alfa/ui/pages/login/widgets/campo_cnpj.dart';
import 'package:novo_ponto_alfa/ui/widgets/botao.dart';
import 'package:novo_ponto_alfa/ui/widgets/botao_link.dart';
import 'package:novo_ponto_alfa/ui/widgets/dialog/my_alert_dialog.dart';

class PageViewEmpresa extends StatefulWidget {
  PageController pageController;
  CtrlLogin ctrlLogin;

  PageViewEmpresa(
      {required this.pageController, required this.ctrlLogin, super.key});

  @override
  State<PageViewEmpresa> createState() => _PageViewEmpresaState();
}

class _PageViewEmpresaState extends State<PageViewEmpresa> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CampoCNPJ(widget.ctrlLogin.tecCnpj),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: BotaoLink(titulo: "Solicitar acesso", onClick: () {}),
            )
          ],
        ),
        const SizedBox(
          height: 80,
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
            const SizedBox(
              width: 16,
            ),
            Expanded(
                flex: 2,
                child: Botao(
                    titulo: "Entrar",
                    onClick: () async {
                      try {
                        await widget.ctrlLogin.onClickEntrarEmpresa(context);

                        Empresa? empresa = await Preferences.empresaLogada();

                        Rotas.irSemRetorno(
                            context, PageHome(titulo: empresa?.nome ?? ""));
                      } catch (e) {
                        MyAlertDialog.exibirOk("Erro", e.toString(), () {});
                      }
                    })),
          ],
        ),
      ],
    );
  }
}
