import 'package:get/get.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_tente_novamente.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_tratada.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
class ValidacaoRequisicao {
  static Map validar(Response<dynamic> response,
      {bool validarTagData = false}) {
    try {
      if (response.statusCode == null) {
        throw ExceptionTratada(
            Traducao.obter(Str.VERIFIQUE_SUA_CONEXAO_INTERNET));
      }

      final map = response.body;

      if (map == null) {
        throw TenteNovamenteExcetion(
            Traducao.obter(Str.NENHUM_RETORNO_RECEBIDO_DO_SERVIDOR));
      }

      if (map.containsKey('error')) {
        throw ExceptionTratada(map['error']);
      }

      if (map.containsKey('mensagem_tratada')) {
        throw ExceptionTratada(map['message']);
      }

      if (validarTagData) {
        if (!map.containsKey('data')) {
          throw TenteNovamenteExcetion(
              Traducao.obter(Str.A_TAG_DATA_NAO_FOI_RECEBIDA));
        }
      }

      return map;
    } on ExceptionTratada {
      rethrow;
    } catch (e) {
      throw TenteNovamenteExcetion(
          '${Traducao.obter(Str.ERRO_INTERNO_DO_SERVIDOR)}\n${e.toString()}');
    }
  }
}
