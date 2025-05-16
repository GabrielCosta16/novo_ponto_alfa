
import 'package:novo_ponto_alfa/domain/model/custom_dao.dart';
import 'package:novo_ponto_alfa/domain/model/empresa/empresa.dart';
import 'package:novo_ponto_alfa/domain/model/justificativa/falta/justificativas_falta.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_tratada.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:novo_ponto_alfa/infra/core/preferences/preferencias.dart';
import 'package:novo_ponto_alfa/infra/core/services/database.dart';

class JustificativasFaltaDAO extends CustomDAO<JustificativasFalta> {
  Future<JustificativasFaltaDAO> init() async {
    database = await DbHelper.getInstance();
    return this;
  }

  @override
  String table() {
    return 'justificativas_falta';
  }

  Future importarDados() async {
    Empresa? empresa = await Preferences.empresaLogada();

    if (empresa == null) {
      throw ExceptionTratada(Traducao.obter(
          Str.A_EMPRESA_ASSOCIADA_A_ESTE_USUARIO_NAO_FOI_ENCONTRADA));
    }

    deleteWithWhere("");
    await importAllFromServerFiltered(
        JustificativasFalta(), {'empresa_id': empresa.id});
  }
}
