import 'dart:io';

import 'package:get/get.dart';
import 'package:novo_ponto_alfa/infra/core/requisicoes/requisitar_token_acesso.dart';
import 'package:novo_ponto_alfa/infra/core/requisicoes/validacao/validacao_requisicao.dart';

class RequisitarGetEquals extends GetConnect {
  Future<List<dynamic>> executar(
      String url, Map<String, dynamic> filter, String? customParams) async {
    final acessToken = await RequisicaoTokenAcesso().executar();

    var filtros = '';

    filter.forEach((key, value) {
      if (value is String) {
        final valueStr = value;

        if (valueStr.contains(';')) {
          final values = valueStr.split(';');

          filtros += "filtros[$key]=${values[0]}:${values[1]}&";
        } else {
          filtros += "filtros[$key]=eq:$value&";
        }
      } else {
        filtros += "filtros[$key]=eq:$value&";
      }
    });

    if (customParams != null && customParams.isNotEmpty) {
      if (!customParams.startsWith('&')) {
        customParams = '&$customParams';
      }
    } else {
      customParams = '';
    }

    if (!url.contains('?')) {
      filtros = '?$filtros';
    } else {
      filtros = '&$filtros';
    }

    final fullUrl = "$url$filtros$customParams";

    final response = await get(fullUrl, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $acessToken',
      HttpHeaders.acceptHeader: 'application/json',
    });

    final map = ValidacaoRequisicao.validar(response, validarTagData: true);

    return map['data'];
  }
}
