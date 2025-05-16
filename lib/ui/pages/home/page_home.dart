import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:novo_ponto_alfa/domain/model/registro_facial_temporario/registro_facial_task.dart';
import 'package:novo_ponto_alfa/domain/model/reconhecimento_facial/global_gryfo_lib.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:novo_ponto_alfa/ui/pages/custom/page_custom.dart';
import 'package:novo_ponto_alfa/ui/pages/home/ctrl_exts/ctrl_cadastro_facial.dart';
import 'package:novo_ponto_alfa/ui/pages/home/ctrl_exts/ctrl_reconhecimento_facial.dart';
import 'package:novo_ponto_alfa/ui/pages/home/ctrl_page_home.dart';
import 'package:novo_ponto_alfa/ui/pages/home/widgets/botao_home.dart';
import 'package:novo_ponto_alfa/ui/pages/home/widgets/relogio.dart';
import 'package:novo_ponto_alfa/ui/pages/manutencao/page_manutencao.dart';

import '../../widgets/dialog/my_alert_dialog.dart';

class PageHome extends StatefulWidget {
  String titulo;

  PageHome({required this.titulo, super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  late CtrlPageHome controller;
  late CtrlCadastroFacial controllerCadastroFacial;
  late CtrlReconhecimentoFacial controllerReconhecimentoFacial;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    controller = CtrlPageHome();
    controller.inicializar();
    controllerCadastroFacial = CtrlCadastroFacial();
    controllerReconhecimentoFacial = CtrlReconhecimentoFacial();
    pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      MyGlobalInstanceGryfo.instance.gryfo
          .setSettings(controller.settingsCamera());
    });
  }

  @override
  void dispose() {
    log("dispose");
    controller.recognizeEventSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.fragmentContainer = MyGlobalInstanceGryfo.instance.gryfo
        .createFragmentContainer(
            hideDefaultOverlay: false, backgroundColor: Colors.black);

    return PageCustom(
      child: PageView(
        controller: pageController,
        children: [
          Stack(
            children: [
              corpoInicial(context),
              controller.fragmentContainer!,
            ],
          ),
          PageManutencao(
            pageController: pageController,
            onClickCadastrarFace: (matricula) {
              try {
                controllerCadastroFacial.cadastrarFace(context, matricula);
              } catch (e) {
                MyAlertDialog.exibirOk("", e.toString(), () {
                  Navigator.of(context).pop();
                });
              }
            },
          )
        ],
      ),
    );
  }

  Widget corpoInicial(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        cabecalho(),
        const SizedBox(
          height: 80,
        ),
        Expanded(
          flex: 3,
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            padding: const EdgeInsets.all(8.0),
            children: botoesHome(),
          ),
        ),
      ],
    );
  }

  Widget cabecalho() {
    return Expanded(
      flex: 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "${DateTime.now().day}, ${obterNomeMes()} - ",
                      style: context.textTheme.bodyLarge
                          ?.copyWith(color: Colors.black45),
                    ),
                    RelogioAtual()
                  ],
                ),
                Text(
                  "${Traducao.obter(Str.OLA)}, ${widget.titulo}",
                  style: context.textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                FontAwesomeIcons.gear,
                color: Color(0xFF3E4095),
              ))
        ],
      ),
    );
  }

  String obterNomeMes() {
    DateTime agora = DateTime.now();

    String nomeMes = DateFormat.MMMM('pt_BR').format(agora);

    nomeMes = toBeginningOfSentenceCase(nomeMes)!;

    return nomeMes;
  }

  List<Widget> botoesHome() {
    return [
      BotaoHome(Traducao.obter(Str.REGISTRAR_PONTO), FontAwesomeIcons.user,
          () async {
        await controllerReconhecimentoFacial
            .iniciarReconhecimentoFacial(context);
        setState(() {});
      }),
      BotaoHome(
          Traducao.obter(Str.MANUTENCAO), FontAwesomeIcons.screwdriverWrench,
          () async {
            RegistroFacialTask cadastroFacialGryfo =
            RegistroFacialTask("02");
            await cadastroFacialGryfo.cadastrarFaceGryfo(context);
        // pageController.animateToPage(
        //   2,
        //   duration: const Duration(milliseconds: 300),
        //   curve: Curves.easeInOut,
        // );
      }),
      BotaoHome(Traducao.obter(Str.SINCRONIZAR), FontAwesomeIcons.rotate,
          () async {
        await controller.onCLickSincronizar(context);

        // atualizarTela();
      }),
      BotaoHome(
          Traducao.obter(Str.SAIR), FontAwesomeIcons.rightFromBracket, () {}),
    ];
  }
}
