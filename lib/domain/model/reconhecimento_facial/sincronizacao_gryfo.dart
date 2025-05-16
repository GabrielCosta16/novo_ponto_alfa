import 'package:flutter/cupertino.dart';
import 'package:flutter_gryfo_lib/flutter_gryfo_lib.dart';
import 'package:intl/intl.dart';
import 'package:novo_ponto_alfa/domain/model/registro_facial_temporario/uc_enviar_registros_faciais_gryfo.dart';
import 'package:novo_ponto_alfa/domain/model/reconhecimento_facial/global_gryfo_lib.dart';
import 'package:novo_ponto_alfa/infra/core/preferences/preferencias.dart';

class SincronizacaoGryfo {
  final _dateFormat = DateFormat('dd/MM/yyyy');

  Future sincronizarDados(BuildContext context) async {
    await UcEnviarRegistrosFaciaisGryfo().executar(context);

    Preferences.obter(Preference.MOD_ULTIMO_LOGIN) == ModLogin.MOD_USUARIO
        ? await _sincronizarDadosUsuarioGryfo()
        : await _sincronizarDadosEmpresaGryfo();
  }

  bool isPrecisaSincronizarGryfo() {
    final hoje = _dateFormat.format(DateTime.now());

    if (Preferences.obter(Preference.DATA_ULTIMA_SINCRONIZACAO_GRYFO) != hoje) {
      return true;
    }
    return false;
  }

  Future<Map<dynamic, dynamic>> _sincronizarDadosEmpresaGryfo() async {
    FlutterGryfoLib gryfo = FlutterGryfoLib();
    salvarDataUltimaSincronizacao();
    var retorno = await gryfo.synchronize(forceSync: true);

    return retorno;
  }

  Future<Map<dynamic, dynamic>> _sincronizarDadosUsuarioGryfo() async {
    String idUsuario =
        await Preferences.usuarioLogado().then((value) => value!.id.toString());

    var retorno = await MyGlobalInstanceGryfo.instance.gryfo
        .synchronizeExternalIds([idUsuario]);

    salvarDataUltimaSincronizacao();

    return retorno;
  }

  void salvarDataUltimaSincronizacao() {
    final hoje = _dateFormat.format(DateTime.now());

    Preferences.salvar(Preference.DATA_ULTIMA_SINCRONIZACAO_GRYFO, hoje);
  }
}
