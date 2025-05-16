import 'package:novo_ponto_alfa/domain/model/custom_dao.dart';
import 'package:novo_ponto_alfa/domain/model/filial/filial.dart';
import 'package:novo_ponto_alfa/domain/model/periodo/periodos.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_tratada.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:novo_ponto_alfa/infra/core/preferences/preferencias.dart';
import 'package:novo_ponto_alfa/infra/core/services/database.dart';

class PeriodosDAO extends CustomDAO<Periodos> {
  Future<PeriodosDAO> init() async {
    database = await DbHelper.getInstance();
    return this;
  }

  @override
  String table() {
    return 'periodos';
  }

  Future importarDados() async {
    Filial? filial = await Preferences.filialLogada();

    if (filial == null) {
      throw ExceptionTratada(Traducao.obter(
          Str.A_EMPRESA_ASSOCIADA_A_ESTE_USUARIO_NAO_FOI_ENCONTRADA));
    }

    deleteWithWhere("");
    await importAllFromServerFiltered(Periodos(), {'filial_id': filial.id});
  }
}
