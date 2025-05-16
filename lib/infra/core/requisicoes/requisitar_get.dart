import 'dart:io';

import 'package:get/get.dart';
import 'package:novo_ponto_alfa/infra/core/requisicoes/requisitar_token_acesso.dart';
import 'package:novo_ponto_alfa/infra/core/requisicoes/validacao/validacao_requisicao.dart';

class RequisicaoGet extends GetConnect {
  Future<List<dynamic>> executar(String url) async {
    final acessToken = await RequisicaoTokenAcesso().executar();

    final response = await get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $acessToken',
        HttpHeaders.acceptHeader: 'application/json',
      },
    );

    final map = ValidacaoRequisicao.validar(response, validarTagData: true);

    return map['data'];
  }
}
