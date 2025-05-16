import 'dart:io';

import 'package:get/get.dart';
import 'package:novo_ponto_alfa/infra/core/configuracao/ambiente.dart';
import 'package:novo_ponto_alfa/infra/core/preferences/preferencias.dart';
import 'package:novo_ponto_alfa/infra/core/requisicoes/autenticar_login_api_principal.dart';
import 'package:novo_ponto_alfa/infra/core/requisicoes/validacao/validacao_requisicao.dart';

class RequisicaoUriAmbiente extends GetConnect {
  Future<String> executar(cnpj) async {
    final user = await AutenticarLoginApiPrincipal().executar();

    final accesToken = user['access_token'];

    final response =
        await get((PathRequisicao.URL_AUTENTICAR_CNPJ + cnpj), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $accesToken',
      HttpHeaders.acceptHeader: 'application/json',
    });

    final map = ValidacaoRequisicao.validar(response, validarTagData: true);

    for (dynamic responseObj in map['data']) {
      Preferences.salvar(Preference.API, responseObj['url']);
      Preferences.salvar(Preference.AMBIENTE, responseObj['descricao']);

      return responseObj['url'];
    }

    Preferences.salvar(Preference.API, Ambiente.API_PRINCIPAL);
    Preferences.salvar(Preference.AMBIENTE, Ambiente.AMBIENTE);

    return Ambiente.API_PRINCIPAL;
  }
}
