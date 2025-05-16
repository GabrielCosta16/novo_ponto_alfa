
import 'package:get/get.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';

class Traducao {
  static String obter(Str config, {List<String>? params}) {
    if (params == null) {
      return config.toString().tr;
    }

    if (params.isEmpty) {
      return config.toString().tr;
    }

    return config.toString().trArgs(params);
  }
}
