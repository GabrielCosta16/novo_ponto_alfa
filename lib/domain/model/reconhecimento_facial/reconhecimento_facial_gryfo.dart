import 'dart:io';

import 'package:novo_ponto_alfa/domain/model/reconhecimento_facial/global_gryfo_lib.dart';

class ReconhecimentoFacialGryfo {
  Future executar() async {
    await MyGlobalInstanceGryfo.instance.gryfo.openRecognize();
  }
}
