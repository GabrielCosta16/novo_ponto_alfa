import 'dart:io';

import 'package:novo_ponto_alfa/infra/core/configuracao/ambiente.dart';

class ConexaoInternet {
  static Future<bool> temConexao() async {
    try {
      final result = await InternetAddress.lookup(
        Ambiente.HOST_CHECK_STATUS_INTERNET,
      );
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
