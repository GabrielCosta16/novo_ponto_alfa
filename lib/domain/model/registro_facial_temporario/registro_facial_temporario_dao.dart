import 'package:novo_ponto_alfa/domain/model/custom_dao.dart';
import 'package:novo_ponto_alfa/domain/model/registro_facial_temporario/mdl_registro_facial_temporario.dart';
import 'package:novo_ponto_alfa/infra/core/services/database.dart';

class RegistroFacialTemporarioDAO extends CustomDAO<RegistroFacialTemporario> {
  @override
  String table() {
    return "registro_facial_temporario";
  }

  Future<RegistroFacialTemporarioDAO> init() async {
    database = await DbHelper.getInstance();
    return this;
  }


  Future<int> deleteByExternalId(String externalId) async {
    return await database!.delete(table(), where: 'external_id = ?', whereArgs: [externalId]);
  }

  Future<RegistroFacialTemporario?> obterPorId(String? idUsuario) async {
    RegistroFacialTemporarioDAO registroFacialTemporarioDAO =
        await RegistroFacialTemporarioDAO().init();
    RegistroFacialTemporario? registro = await registroFacialTemporarioDAO
        .getBy(RegistroFacialTemporario(), " where idUsuario = '$idUsuario'");

    return registro;
  }
}
