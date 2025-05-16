import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_tente_novamente.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_tratada.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';

class MyException {
  static exibir(var ex, {Function? executarApos}) {
    String mensagem = ex.toString().replaceAll('Exception: ', '');

    if (ex is String) {
      if (ex.toLowerCase().contains("service temporarily unavailable")) {
        mensagem = '${Traducao.obter(Str.ERRO_INTERNO_DO_SERVIDOR)} $ex';
      } else if (ex.toLowerCase().contains('too many attempts')) {
        mensagem = '${Traducao.obter(Str.ERRO_MAX_REQUISICOES_SERVIDOR)}'
            '\n${Traducao.obter(Str.RETORNO_DO_SERVIDOR)} $ex';
      }
    }

    if (ex is TenteNovamenteExcetion) {
      mensagem += '\n\n${Traducao.obter(Str.TENTE_NOVAMENTE_MAIS_TARDE)}';
    } else if (ex is PlatformException) {
      if (mensagem.contains("file does not exist")) {
        mensagem =
            Traducao.obter(Str.ARQUIVO_DA_FOTO_NAO_ENCONTRADO_OU_CORROMPIDO);
      }
    }

    // MyAlertDialog.exibirOk('Opss..', mensagem, () {
    //   Get.back();
    //
    //   executarApos?.call();
    // });

    // if (ex is ExceptionTratada) {
    //   if (ex.isFatal) {
    //     Rotas.irSemRetorno(Rotas.login_page);
    //   }
    // } else {
    //   MySentry.reportar(ex);
    // }
  }
}
