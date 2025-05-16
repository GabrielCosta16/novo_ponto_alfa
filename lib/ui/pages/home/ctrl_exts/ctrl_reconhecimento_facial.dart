import 'package:flutter/cupertino.dart';
import 'package:novo_ponto_alfa/domain/model/reconhecimento_facial/global_gryfo_lib.dart';
import 'package:novo_ponto_alfa/domain/model/reconhecimento_facial/reconhecimento_facial_gryfo.dart';
import 'package:novo_ponto_alfa/main.dart';
import 'package:novo_ponto_alfa/ui/pages/home/ctrl_page_home.dart';
import 'package:novo_ponto_alfa/ui/widgets/dialog/my_alert_dialog.dart';

class CtrlReconhecimentoFacial extends CtrlPageHome {
  Future iniciarReconhecimentoFacial(BuildContext ctx) async {
    try {
      await MyGlobalInstanceGryfo.instance.gryfo.openRecognize();
    } catch (e) {
      MyAlertDialog.exibirOk("", e.toString(), () {
        Navigator.of(ctx).pop();
      });
    }
  }
}
