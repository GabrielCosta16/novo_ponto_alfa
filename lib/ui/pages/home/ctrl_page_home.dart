import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_gryfo_lib/flutter_gryfo_lib.dart';
import 'package:flutter_gryfo_lib/fragment_container.dart';
import 'package:get/get.dart';
import 'package:novo_ponto_alfa/domain/model/ponto/registros_ponto.dart';
import 'package:novo_ponto_alfa/domain/model/ponto/registros_ponto_dao.dart';
import 'package:novo_ponto_alfa/domain/model/reconhecimento_facial/global_gryfo_lib.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/my_exception.dart';
import 'package:novo_ponto_alfa/infra/core/processos/sincronizacao/sincronizacao.dart';
import 'package:novo_ponto_alfa/main.dart';
import 'package:novo_ponto_alfa/ui/pages/registrar_ponto/text_widget.dart';

class CtrlPageHome {
  TextWidget? latestMessage = TextWidget(text: Text(''));
  TextWidget? latestRecognizeMessage = TextWidget(text: Text(''));
  TextWidget? returnText = TextWidget(text: Text(''));
  FragmentContainer? fragmentContainer;
  StreamSubscription<dynamic>? recognizeEventSubscription = null;
  var isExibirBotoes = false.obs;

  var qtdeRegistrosNaoEnviados = 0.obs;

  void inicializar() {

    MyGlobalInstanceGryfo.instance.gryfo.onMessage.listen((event) {
      latestMessage?.getState()?.refresh('message: \n${event.toString()}');
      log("${event.toString()}");
    });

    recognizeEventSubscription = MyGlobalInstanceGryfo
        .instance.gryfo.recognizeEventStream.stream
        .listen((event) {
      latestMessage?.getState()?.refresh('message: \n${event.toString()}');
      log("> ${event.toString()}");
    });
  }

  Future onCLickSincronizar(BuildContext context) async {
    try {
      await _sincronizar(context, automatico: false, apenasEnviar: false);
    } catch (e) {
      MyException.exibir(e);
    }
  }

  Future _sincronizar(BuildContext context,
      {bool automatico = false, bool apenasEnviar = false}) async {
    if (automatico) {
      Sincronizacao()
          .isSincAutomatica(automatico)
          .somenteEnviarRegistros(apenasEnviar)
          .setRxIntQtdeRegistrosNaoEnviados(qtdeRegistrosNaoEnviados)
          .executar(context);
    } else {
      await Sincronizacao()
          .isSincAutomatica(automatico)
          .somenteEnviarRegistros(apenasEnviar)
          .setRxIntQtdeRegistrosNaoEnviados(qtdeRegistrosNaoEnviados)
          .executar(context);
    }

    await _atualizarDadosTela();
  }

  Future _atualizarDadosTela() async {
    RegistrosPontoDAO registrosPontoDAO = await RegistrosPontoDAO().init();
    List<RegistrosPonto> registros =
        await registrosPontoDAO.obterRegistrosAindaNaoSincronizados();
    qtdeRegistrosNaoEnviados.value = registros.length;
  }

  Map<String, dynamic> settingsCamera() {
    return {
      "ellipseFrontFlash": true,
      "defaultCamera": 0,
      "timeToNewRecognize": 3,
      "livenessEnabled": true,
      "activeLivenessEnabled": false,
      "livenessBrightnessDisabled": true,
      "auditEnabled": true,
      "auditWifiOnly": true,
      "showMaskHelp": false,
      "hideFragmentSwitchCameraButton": true,
      "hideFragmentFlashlightButton": true,
      "auditsNeedConfirmation": true,
      "embedderVersion": "v3",
      "livenessBlockTime": 1,
      "livenessBlockTimeIncrement": 5,
      "livenessSingleFrame": false,
      "livenessSensitivity": 2,
      "periodicSyncEnabled": false,
      "recognizeActivityTimeout": 10,
      "secretApiUrl": "https://prod.embedder.gryfo.com.br:5000",
      "showAdviceMessages": false,
    };
  }
}
