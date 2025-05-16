import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:novo_ponto_alfa/infra/colors.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:novo_ponto_alfa/infra/text_styles.dart';

class MyAlertDialog {
  static exibirMensagem(String msg, {String? titulo, Function? executarApos}) {
    exibirOk(titulo, msg, Get.back);

    executarApos?.call();
  }

  static exibirOk(String? titulo, String mensagem, Function onTapOk) {
    var actions = [
      _defaultAction(Traducao.obter(Str.OK), onTapOk),
    ];

    _construirDialog(titulo, mensagem, actions);
  }

  static confirmacaoOkCancelar(String? titulo, String mensagem,
      Function onTapOk, Function onTapCancelar) {
    var actions = [
      _defaultAction(Traducao.obter(Str.CANCELAR), onTapCancelar),
      _defaultAction(Traducao.obter(Str.OK), onTapOk),
    ];

    _construirDialog(titulo, mensagem, actions);
  }

  static confirmacaoSimCancelar(
      String titulo, String mensagem, Function onTapOk) {
    var actions = [
      _defaultAction(Traducao.obter(Str.CANCELAR), Get.back),
      _defaultAction(Traducao.obter(Str.SIM), onTapOk),
    ];

    _construirDialog(titulo, mensagem, actions);
  }

  static confirmacaoSalvarDescartarCancelar(String titulo, String mensagem,
      {required Function onTapSalvar, required Function onTapDescartar}) {
    var actions = [
      _defaultActionSimDescartarCancelar(onTapSalvar, onTapDescartar),
    ];

    _construirDialog(titulo, mensagem, actions);
  }

  static confirmacaoExclusao(String titulo, String mensagem, Function onTapOk) {
    var actions = [
      _defaultAction(Traducao.obter(Str.CANCELAR), Get.back),
      _vermelhoAction(Traducao.obter(Str.SIM), () {
        Get.back();
        onTapOk.call();
      }),
    ];

    _construirDialog(titulo, mensagem, actions);
  }

  static _construirDialog(
      String? titulo, String mensagem, List<Widget> actions) {
    showPlatformDialog(
      context: Get.context!,
      builder: (_) => PlatformAlertDialog(
        material: (context, plat) {
          return MaterialAlertDialogData(
              backgroundColor: Get.isDarkMode
                  ? Get.theme.dialogBackgroundColor
                  : Get.theme.colorScheme.surface,
              elevation: 4,
              actionsAlignment: MainAxisAlignment.end);
        },
        cupertino: (context, plat) {
          return CupertinoAlertDialogData();
        },
        title: titulo != null
            ? Text(
                titulo,
                style: TextStyles.styleTituloNormal(),
              )
            : null,
        content: Text(
          mensagem,
          style: TextStyles.styleTituloWidget(),
        ),
        actions: actions,
      ),
    );
  }

  static PlatformDialogAction _defaultAction(String titulo, Function onTap) {
    return PlatformDialogAction(
      child: Text(
        titulo,
        style: TextStyles.styleTituloNormal(),
      ),
      onPressed: () {
        onTap.call();
      },
    );
  }

  static Widget _defaultActionSimDescartarCancelar(
    Function onTapSalvar,
    Function onTapDescartar,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: PlatformDialogAction(
              child: Text(
                Traducao.obter(Str.CANCELAR),
                style: TextStyles.styleTituloNormal()
                    .copyWith(color: MyColors.preto),
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ),
        Row(
          children: [
            PlatformDialogAction(
              child: Text(
                Traducao.obter(Str.DESCARTAR),
                style: TextStyles.styleTituloNormal()
                    .copyWith(color: Colors.red.shade800),
              ),
              onPressed: () {
                onTapDescartar.call();
              },
            ),
            PlatformDialogAction(
              child: Text(
                Traducao.obter(Str.SALVAR),
                style: TextStyles.styleTituloNormal()
                    .copyWith(color: MyColors.destaqueVerde),
              ),
              onPressed: () {
                onTapSalvar.call();
              },
            ),
          ],
        )
      ],
    );
  }

  static PlatformDialogAction _vermelhoAction(String titulo, Function onTap) {
    return PlatformDialogAction(
      child: Text(
        titulo,
        style:
            TextStyles.styleTituloNormal().copyWith(color: Colors.red.shade800),
      ),
      onPressed: () {
        onTap.call();
      },
    );
  }
}
