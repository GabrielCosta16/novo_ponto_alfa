import 'package:get/get.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao/pt_br.dart';
class Traducoes extends Translations {
  @override
  Map<String, Map<String, String>> get keys => montarMapTraducoes();

  Map<String, Map<String, String>> montarMapTraducoes() {
    Map<String, Map<String, String>> mmap = {};

    mmap.addAll(PTBR.obter());

    return mmap;
  }
}
