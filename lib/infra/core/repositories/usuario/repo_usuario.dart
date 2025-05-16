import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:novo_ponto_alfa/infra/core/configuracao/ambiente.dart';
import 'package:novo_ponto_alfa/infra/core/requisicoes/validacao/validacao_requisicao.dart';

class RepoUsuario extends GetConnect {
  Future<Map> login({login, senha, cnpj}) async {
    final response = await post(
      PathRequisicao.URL_AUTENTICAR_LOGIN,
      json.encode({'cnpj': cnpj, 'email': login, 'password': senha}),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
    );

    return ValidacaoRequisicao.validar(response);
  }

  Future<Map> obterTokenGryfoSDK(String idEmpresa) async{
    final response = await post(
      PathRequisicao.URL_AUTENTICAR_LOGIN_GRYFO,
      json.encode({'company_id': idEmpresa}),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
    );

    return ValidacaoRequisicao.validar(response);
  }
}
