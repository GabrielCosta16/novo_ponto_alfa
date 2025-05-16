import 'package:flutter_gryfo_lib/flutter_gryfo_lib.dart';
import 'package:intl/intl.dart';
import 'package:novo_ponto_alfa/domain/model/reconhecimento_facial/global_gryfo_lib.dart';
import 'package:novo_ponto_alfa/infra/core/enum/enum_reconhecimento_facial.dart';
import 'package:novo_ponto_alfa/infra/core/preferences/preferencias.dart';

class AutenticacaoGryfo {
  bool isPrecisaAutenticar() {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final hoje = dateFormat.format(DateTime.now());

    if (Preferences.obter(Preference.DATA_ULTIMA_AUTENTICACAO_GRYFO) != hoje) {
      return true;
    }

    return false;
  }

  /// Metodo que ira chamar a API gryfo e devolvera o token
  Future<Map<dynamic, dynamic>> autenticarEmpresaGryfo() async {
    SecureStorage.tokenRF.salvar(valorSalvo: _obterToken());

    String token = await SecureStorage.tokenRF.obter();

    return await MyGlobalInstanceGryfo.instance.gryfo
        .authenticate(_obterToken());
  }

  String _obterToken() {
    return "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c3IiOiJhbGZhLWRldmVsb3BtZW50IiwiaWF0IjoxNzQ3NDAyMTYyLCJjb21wYW55X2lkIjoiMzI1YzcwYzgtZGNjMS00OTFiLWI4ODEtODZkY2I2NjAyZjg5In0.H7PZzxgu4VDMUN6yVf-1aoAvrSevhScZrHWIYPTpW9Y";
  }
}
