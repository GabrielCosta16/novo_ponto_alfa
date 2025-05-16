import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:novo_ponto_alfa/infra/core/configuracao/ambiente.dart';
import 'package:novo_ponto_alfa/infra/core/requisicoes/validacao/validacao_requisicao.dart';

class AutenticarLoginApiPrincipal extends GetConnect {
  Future<Map> executar() async {
    final response = await post(
      PathRequisicao.URL_AUTENTICAR_LOGIN_API_PRINCIPAL,
      json.encode({
        'email': "developer@bigworks.com.br",
        'password': "1QW23ER45T;",
      }),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
    );

    return ValidacaoRequisicao.validar(response);
  }
}
