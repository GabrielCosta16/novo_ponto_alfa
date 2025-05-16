import 'package:novo_ponto_alfa/domain/model/custom_dao.dart';
import 'package:novo_ponto_alfa/domain/model/dados_auxiliares/dados_auxiliares.dart';
import 'package:novo_ponto_alfa/domain/model/filial/filial.dart';
import 'package:novo_ponto_alfa/domain/model/filial/filial_dao.dart';
import 'package:novo_ponto_alfa/domain/model/user/usuario.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_tratada.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:novo_ponto_alfa/infra/core/preferences/preferencias.dart';
import 'package:novo_ponto_alfa/infra/core/repositories/usuario/usuario_dao.dart';
import 'package:novo_ponto_alfa/infra/core/services/database.dart';

class DadosAuxiliaresDAO extends CustomDAO<DadosAuxiliares> {
  Future<DadosAuxiliaresDAO> init() async {
    database = await DbHelper.getInstance();
    return this;
  }

  @override
  String table() {
    return 'dados_auxiliares';
  }

  Future importarDados() async {
    FilialDAO filiaisDAO = await FilialDAO().init();

    int? empresaId;

    if (Preferences.obter(Preference.MOD_ULTIMO_LOGIN) ==
        ModLogin.MOD_EMPRESA) {
      var cnpj = Preferences.obter(Preference.CNPJ);
      Filial? filial =
          await filiaisDAO.getBy(Filial(), " where cnpj = '$cnpj'");

      empresaId = filial?.empresaId;
    } else {
      UsuarioDAO usersDAO = await UsuarioDAO().init();

      String? login = Preferences.obter(Preference.LOGIN);
      String? senha = Preferences.obter(Preference.SENHA);
      Usuario user = await usersDAO.obterLoginDaBase(login, senha);
      Filial? filial = await filiaisDAO.getById(Filial(), user.filialId);
      empresaId = filial?.empresaId;
    }

    if (empresaId == null) {
      throw ExceptionTratada(Traducao.obter(
          Str.A_EMPRESA_ASSOCIADA_A_ESTE_USUARIO_NAO_FOI_ENCONTRADA));
    }

    deleteWithWhere("");
    await importAllFromServerFiltered(
        DadosAuxiliares(), {'empresa_id': empresaId, 'ativo': true});
  }
}
