

import 'package:flutter/cupertino.dart';
import 'package:novo_ponto_alfa/domain/model/registro_facial_temporario/registro_facial_temporario_dao.dart';
import 'package:novo_ponto_alfa/domain/model/registro_facial_temporario/repo_registro_facial.dart';
import 'package:sqflite/sqflite.dart';

class UcEnviarRegistrosFaciaisGryfo {
  Future executar(BuildContext context) async {
    RegistroFacialTemporarioDAO recTempDao = RegistroFacialTemporarioDAO();
    await recTempDao.init();

    final result = await recTempDao.database?.rawQuery('SELECT COUNT(*) as total FROM registro_facial_temporario');

    final count = Sqflite.firstIntValue(result!) ?? 0;

    if(count == 0){
      return;
    }

    await RepoCadastroFacial().enviarRegistroFacialGryfo(context);
  }
}
