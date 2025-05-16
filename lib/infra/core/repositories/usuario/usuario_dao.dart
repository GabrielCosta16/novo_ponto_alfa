import 'package:novo_ponto_alfa/domain/model/custom_dao.dart';
import 'package:novo_ponto_alfa/domain/model/empresa/empresa.dart';
import 'package:novo_ponto_alfa/domain/model/empresa/empresa_dao.dart';
import 'package:novo_ponto_alfa/domain/model/filial/filial.dart';
import 'package:novo_ponto_alfa/domain/model/filial/filial_dao.dart';
import 'package:novo_ponto_alfa/domain/model/reconhecimento_facial/autenticacao_gryfo.dart';
import 'package:novo_ponto_alfa/domain/model/user/usuario.dart';
import 'package:novo_ponto_alfa/infra/core/enum/enum_reconhecimento_facial.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_tratada.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:novo_ponto_alfa/infra/core/preferences/preferencias.dart';
import 'package:novo_ponto_alfa/infra/core/repositories/usuario/repo_usuario.dart';
import 'package:novo_ponto_alfa/infra/core/requisicoes/requisitar_uri_ambiente.dart';
import 'package:novo_ponto_alfa/infra/core/services/database.dart';

class UsuarioDAO extends CustomDAO<Usuario> {
  Future<UsuarioDAO> init() async {
    database = await DbHelper.getInstance();
    return this;
  }

  @override
  String table() {
    return 'users';
  }

  Future<Usuario> obterLogin(String login, String senha, String cnpj) async {
    try {
      await RequisicaoUriAmbiente().executar(cnpj);

      Map response =
          await RepoUsuario().login(login: login, senha: senha, cnpj: cnpj);

      await limparBaseSeTrocarDeUsuario(login);

      (response['user'] as Map<String, dynamic>).addAll({'password': senha});

      await SecureStorage.tokenRF
          .salvar(valorSalvo: response["tokenRF"].toString());

      await update(Usuario().convertJson(response['user']));

      FilialDAO filiaisDAO = await FilialDAO().init();

      await filiaisDAO.importAllFromServerFiltered(
          Filial(), {'id': response['user']['filial_id']});

      Filial? filial =
          await filiaisDAO.getById(Filial(), response['user']['filial_id']);

      EmpresaDAO empresasDAO = await EmpresaDAO().init();
      await empresasDAO
          .importAllFromServerFiltered(Empresa(), {'id': filial?.empresaId});
    } catch (e) {
      print(e);
      // TODO - testar request
    }

    return await obterLoginDaBase(login, senha);
  }

  Future limparBaseSeTrocarDeUsuario(String loginDigitado) async {
    try {
      String loginSalvo = Preferences.obter(Preference.LOGIN);

      if (loginSalvo != loginDigitado) {
        await DbHelper.clearAllTables();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Usuario> obterLoginDaBase(String? login, String? senha) async {
    if (login == null || senha == null) {
      throw ExceptionTratada(Traducao.obter(Str
          .OS_DADOS_DE_ACESSO_INFORMADOS_NAO_ENCONTRADOS_NA_BASE_DE_DADOS_OFFLINE));
    }

    final colunaLogin = login.contains('@') ? 'email' : 'matricula';
    final user = await getBy(Usuario(),
        " WHERE LOWER($colunaLogin) = LOWER(TRIM('$login')) AND password = '$senha'");

    if (user == null) {
      throw ExceptionTratada(Traducao.obter(Str
          .OS_DADOS_DE_ACESSO_INFORMADOS_NAO_ENCONTRADOS_NA_BASE_DE_DADOS_OFFLINE));
    }

    if (user.ativo == false) {
      throw ExceptionTratada(Traducao.obter(
          Str.O_USUARIO_INFORMADO_ESTA_INATIVO_E_NAO_PODE_SER_ACESSADO));
    }

    return user;
  }

  Future<String> obterIdUsuario(String? matricula) async {
    Usuario? usuario = await Preferences.usuarioLogado();

    UsuarioDAO usuarioDAO = await UsuarioDAO().init();

    if (matricula == null) {
      return usuario!.id!.toString();
    }

    usuario =
        await usuarioDAO.getBy(Usuario(), " where matricula = '$matricula'");

    return usuario!.id.toString();
  }
}
