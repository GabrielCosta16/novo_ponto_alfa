import 'package:get/get.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_tratada.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:novo_ponto_alfa/infra/core/preferences/preferencias.dart';
import 'package:novo_ponto_alfa/infra/core/repositories/usuario/repo_usuario.dart';
class RequisicaoTokenAcesso extends GetConnect {
  Future<String> executar() async {
    final isLoginEmpresa =
        Preferences.obter(Preference.MOD_ULTIMO_LOGIN) == ModLogin.MOD_EMPRESA;

    var cnpj;
    var login = 'developer@bigworks.com.br';
    var senha = '1QW23ER45T;';
    var usarTokenAdmin =
        Preferences.obter(Preference.USAR_TOKEN_ADMIN, padrao: false);

    if (isLoginEmpresa == false && !usarTokenAdmin) {
      cnpj = Preferences.obter(Preference.CNPJ, padrao: '');
      login = Preferences.obter(Preference.LOGIN, padrao: '');
      senha = Preferences.obter(Preference.SENHA, padrao: '');
    }

    final mapUser = await RepoUsuario()
        .login(login: login, senha: senha, cnpj: cnpj);

    if (!mapUser.containsKey('access_token')) {
      if (mapUser.containsKey('message')) {
        throw ExceptionTratada(mapUser['message']);
      } else {
        throw ExceptionTratada(Traducao.obter(Str.ERRO_INTERNO_DO_SERVIDOR));
      }
    }

    return mapUser['access_token'];
  }
}
