import 'package:flutter_gryfo_lib/flutter_gryfo_lib.dart';
import 'package:novo_ponto_alfa/domain/model/reconhecimento_facial/global_gryfo_lib.dart';
import 'package:novo_ponto_alfa/infra/core/preferences/preferencias.dart';

class PesosGryfo {
  bool isPrecisaBaixarPesos() {
    if (Preferences.obter(Preference.STATUS_PESOS_GRYFO) !=
        StatusPesosGryfo.DOWNLOAD_JA_REALIZADO) {
      return true;
    }
    return false;
  }

  Future<Map<dynamic, dynamic>> baixarPesosGryfo() async {
    // if (isPrecisaBaixarPesos()) {

    var retorno = await MyGlobalInstanceGryfo.instance.gryfo.downloadWeights();

    Preferences.salvar(
        Preference.STATUS_PESOS_GRYFO, StatusPesosGryfo.DOWNLOAD_JA_REALIZADO);

    return retorno;
    }
    // return {};
  // }
}
