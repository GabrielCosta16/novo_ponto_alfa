import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:novo_ponto_alfa/infra/core/requisicoes/requisitar_token_acesso.dart';
import 'package:novo_ponto_alfa/infra/core/requisicoes/validacao/validacao_requisicao.dart';

class RequisicaoPost extends GetConnect {
  late int rTimeout;

  RequisicaoPost({this.rTimeout = 20});

  @override
  void onInit() {
    timeout = Duration(seconds: rTimeout);

    super.onInit();
  }

  Future<Map<dynamic, dynamic>> executar(
      String url, Map<String, dynamic> data) async {
    final acessToken = await RequisicaoTokenAcesso().executar();
    final jsonBody = json.encode(data);

    final response = await post(
      url,
      jsonBody,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $acessToken',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: '+json',
      },
    );

    // TODO cogo/nestor -> olhar isso com mais calma. O servidor retorna um Int quando lança uma justificativa.
    if (response.body is int) {
      return {'data': 1, 'id': response.body};
    }

    return ValidacaoRequisicao.validar(response);
  }
}
