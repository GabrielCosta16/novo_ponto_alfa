import 'package:flutter/material.dart';
import 'package:novo_ponto_alfa/domain/model/registro_facial_temporario/registro_facial_task.dart';
import 'package:novo_ponto_alfa/ui/pages/home/ctrl_page_home.dart';
import 'package:novo_ponto_alfa/ui/widgets/dialog/my_alert_dialog.dart';
import 'package:novo_ponto_alfa/ui/widgets/dialog/my_loading_dialog.dart';

class CtrlCadastroFacial extends CtrlPageHome {
  Future cadastrarFace(BuildContext context, String matricula) async {
    try {
      MyLoadingDialog.exibir(context, MyDialogType.LOADING,
          mensagem: "Cadastrando face...");

      RegistroFacialTask cadastroFacialGryfo = RegistroFacialTask(matricula);
      await cadastroFacialGryfo.cadastrarFaceGryfo(context);

      MyLoadingDialog.atualizarMensagem("Sucesso!");

      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      MyAlertDialog.exibirOk("", e.toString(), () {
        Navigator.of(context).pop();
      });
    }
  }
}
