import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:novo_ponto_alfa/domain/model/empresa/empresa.dart';
import 'package:novo_ponto_alfa/domain/model/empresa/empresa_dao.dart';
import 'package:novo_ponto_alfa/domain/model/filial/filial.dart';
import 'package:novo_ponto_alfa/domain/model/filial/filial_dao.dart';
import 'package:novo_ponto_alfa/domain/model/user/usuario.dart';
import 'package:novo_ponto_alfa/infra/core/repositories/usuario/usuario_dao.dart';

class Preferences {
  static final box = GetStorage();

  static obter(Preference preference, {dynamic padrao}) {
    return box.read(preference.name) ?? padrao;
  }

  static salvar(Preference preference, dynamic valor) {
    return box.write(preference.name, valor);
  }

  static DateTime getDate(Preference chave) {
    String? valor = obter(chave);

    if (valor == null || valor.isEmpty) {
      return DateTime.parse('1990-01-01');
    }

    return DateTime.parse(valor);
  }

  static setDate(Preference chave, DateTime valor) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String valorData = dateFormat.format(valor);

    salvar(chave, valorData);
  }

  static Future<Empresa?> empresaLogada() async {
    EmpresaDAO empresasDAO = await EmpresaDAO().init();

    if (obter(Preference.MOD_ULTIMO_LOGIN) == ModLogin.MOD_EMPRESA) {
      String? cnpj = obter(Preference.CNPJ);
      return empresasDAO.obterPorCnpj(cnpj);
    } else {
      var login = obter(Preference.LOGIN);
      var senha = obter(Preference.SENHA);

      UsuarioDAO usersDAO = await UsuarioDAO().init();
      Usuario? user = await usersDAO.obterLoginDaBase(login, senha);

      return await empresasDAO.obterPorFilialId(user.filialId);
    }
  }

  static Future<Filial?> filialLogada() async {
    FilialDAO filiaisDAO = await FilialDAO().init();
    if (Preferences.obter(Preference.MOD_ULTIMO_LOGIN) ==
        ModLogin.MOD_EMPRESA) {
      String? cnpj = obter(Preference.CNPJ);
      return filiaisDAO.obterPorCnpjBase(cnpj);
    } else {
      var login = obter(Preference.LOGIN);
      var senha = obter(Preference.SENHA);

      UsuarioDAO usersDAO = await UsuarioDAO().init();
      Usuario user = await usersDAO.obterLoginDaBase(login, senha);

      return await filiaisDAO.getById(Filial(), user.filialId);
    }
  }

  static Future<Usuario?> usuarioLogado() async {
    if (Preferences.obter(Preference.MOD_ULTIMO_LOGIN) ==
        ModLogin.MOD_USUARIO) {
      var login = obter(Preference.LOGIN);
      var senha = obter(Preference.SENHA);

      UsuarioDAO usersDAO = await UsuarioDAO().init();
      Usuario user = await usersDAO.obterLoginDaBase(login, senha);

      return user;
    }

    return null;
  }

  static Future<bool> isPrimeiraSincDia() async {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    DateTime now = DateTime.now();
    now = DateTime.parse(dateFormat.format(now));

    DateTime ultimaSinc = getDate(Preference.DATA_ULTIMA_SINC);

    return ultimaSinc.isBefore(now) && DateTime.now().hour > 2;
  }
}

class ModLogin {
  static const MOD_USUARIO = "user";
  static const MOD_EMPRESA = "empresa";
}

class StatusPesosGryfo {
  static const DOWNLOAD_PENDENTE = "download pendente";
  static const DOWNLOAD_JA_REALIZADO = "download ja realizado";
}

enum Preference {
  LOGIN,
  CHAVE_DADOS_AUXILIAR,
  DADOS_AUXILIAR_INSERIR_AUTOMATICAMENTE_NA_MARCACAO,
  MOSTRAR_CAMPO_ADICIONAL_NO_REGISTRO_PONTO,
  SENHA,
  CNPJ,
  LEMBRAR_LOGIN_SENHA,
  LEMBRAR_CNPJ,
  USAR_TOKEN_ADMIN,
  HABILITAR_RECONHECIMENTO_DE_FACE,
  PERMITIR_LOGIN_USUARIO,
  ENVIAR_PONTO_AO_REGISTRAR,
  APELIDO_APARELHO,
  TIPO_LAYOUT_REGISTRO_PONTO,
  API,
  AMBIENTE,
  PERMITIR_LOGIN_EMPRESA,
  MOD_ULTIMO_LOGIN,
  DATA_ULTIMA_SINC,
  THEME_MODE,
  ACEITOU_POLITICA,
  STATUS_PESOS_GRYFO,
  DATA_ULTIMA_AUTENTICACAO_GRYFO, TOKEN_GRYFO, DATA_ULTIMA_SINCRONIZACAO_GRYFO,
}
