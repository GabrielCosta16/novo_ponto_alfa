import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:get/get.dart';
import 'package:novo_ponto_alfa/domain/model/aparelho/aparelho_dao.dart';
import 'package:novo_ponto_alfa/domain/model/filial/filial_dao.dart';
import 'package:novo_ponto_alfa/domain/model/user/usuario.dart';
import 'package:novo_ponto_alfa/infra/colors.dart';
import 'package:novo_ponto_alfa/infra/core/configuracao/ambiente.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_tente_novamente.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_tratada.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/my_exception.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:novo_ponto_alfa/infra/core/preferences/preferencias.dart';
import 'package:novo_ponto_alfa/infra/core/repositories/usuario/usuario_dao.dart';
import 'package:novo_ponto_alfa/infra/core/requisicoes/checar_conexao_internet.dart';
import 'package:novo_ponto_alfa/infra/core/utils/device_utils.dart';
import 'package:novo_ponto_alfa/infra/core/utils/util.dart';
import 'package:novo_ponto_alfa/infra/rotas/rotas.dart';
import 'package:novo_ponto_alfa/ui/pages/custom/custom_getx_controller.dart';
import 'package:novo_ponto_alfa/ui/widgets/dialog/my_loading_dialog.dart';

class CtrlLogin extends CustomGetXController {
  AparelhoDAO? aparelhosDAO;
  FilialDAO? filialDAO;
  UsuarioDAO? usersDAO;
  TextEditingController tecCnpj = TextEditingController();
  TextEditingController txcLoginEmail = TextEditingController();
  TextEditingController txcLoginSenha = TextEditingController();

  var versaoApp = ''.obs;
  var udidAparelho = ''.obs;
  var apelidoAparelho = ''.obs;
  var ambiente = ''.obs;

  @override
  void onInit() async {
    try {
      DeviceUtils.loadPackageInfo(renew: true);

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      aparelhosDAO = await AparelhoDAO().init();
      filialDAO = await FilialDAO().init();
      usersDAO = await UsuarioDAO().init();

      udidAparelho.value =
          '${Traducao.obter(Str.IDENTIFICADOR_DO_APARELHO)} ${(await FlutterUdid.udid)}';
      ambiente.value = Ambiente.AMBIENTE_ASYNC;
      apelidoAparelho.value =
          Preferences.obter(Preference.APELIDO_APARELHO) ?? '';
      versaoApp.value =
          '${Traducao.obter(Str.VERSAO)} ${DeviceUtils.versionDisplay().toString()}';

      txcLoginEmail.text = Preferences.obter(Preference.LOGIN, padrao: '');
      txcLoginSenha.text = Preferences.obter(Preference.SENHA, padrao: '');
      tecCnpj.text = Preferences.obter(Preference.CNPJ, padrao: '');
    } catch (e) {
      MyException.exibir(e);
    }

    super.onInit();
  }

  Future onClickEntrarEmpresa(BuildContext context) async {
    try {
      MyLoadingDialog.exibir(context, MyDialogType.LOADING,
          mensagem: Traducao.obter(Str.VERIFICANDO_CNPJ));
      filialDAO = await FilialDAO().init();

      Preferences.salvar(Preference.MOD_ULTIMO_LOGIN, ModLogin.MOD_EMPRESA);

      await filialDAO?.obterPorCnpj(Util.somenteNumeros(tecCnpj.text));

      await verificarPermissaoAparelho();

      if (!Preferences.obter(Preference.PERMITIR_LOGIN_EMPRESA,
          padrao: false)) {
        throw ExceptionTratada(Traducao.obter(
            Str.ESTE_APARELHO_NAO_E_PERMITIDO_PARA_USO_COLETIVO));
      }

      if (trocouEmpresaPorOutraOuUsuario()) {
        Preferences.setDate(
            Preference.DATA_ULTIMA_SINC, DateTime.parse('1990-01-01'));
      }

      Preferences.salvar(Preference.CNPJ, Util.somenteNumeros(tecCnpj.text));
      Preferences.salvar(Preference.MOD_ULTIMO_LOGIN, ModLogin.MOD_EMPRESA);

      MyLoadingDialog.ocultar();
    } catch (e) {
      MyLoadingDialog.ocultarComAbrirDialogErro(e);
      throw Exception("Erro");
    }
  }

  Future onClickEntrarUsuario(BuildContext context) async {
    try {
      MyLoadingDialog.exibir(context, MyDialogType.LOADING,
          mensagem: Traducao.obter(Str.AUTENTICANDO));

      usersDAO = await UsuarioDAO().init();

      Preferences.salvar(Preference.MOD_ULTIMO_LOGIN, ModLogin.MOD_USUARIO);
      Preferences.salvar(Preference.USAR_TOKEN_ADMIN, true);

      Usuario? user = await usersDAO?.obterLogin(txcLoginEmail.text,
          txcLoginSenha.text, Util.somenteNumeros(tecCnpj.text));

      if (user == null) {
        var temInternet = await ConexaoInternet.temConexao();

        if (temInternet) {
          throw TenteNovamenteExcetion(
              Traducao.obter(Str.SERVIDOR_TEMPORARIAMENTE_INDISPONIVEL));
        } else {
          throw TenteNovamenteExcetion(Traducao.obter(Str
              .OS_DADOS_DE_ACESSO_INFORMADOS_NAO_ENCONTRADOS_NA_BASE_DE_DADOS_OFFLINE));
        }
      }

      await verificarPermissaoAparelho(idUser: user.id, tentativas: 1);

      if (!Preferences.obter(Preference.PERMITIR_LOGIN_USUARIO,
          padrao: false)) {
        throw ExceptionTratada(Traducao.obter(
            Str.ESTE_APARELHO_NAO_E_PERMITIDO_PARA_LOGIN_DE_USUARIO));
      }

      if (trocouUsuarioPorOutroOuEmpresa()) {
        Preferences.setDate(
            Preference.DATA_ULTIMA_SINC, DateTime.parse('1990-01-01'));
      }

      Preferences.salvar(Preference.CNPJ, Util.somenteNumeros(tecCnpj.text));
      Preferences.salvar(Preference.LOGIN, txcLoginEmail.text);
      Preferences.salvar(Preference.SENHA, txcLoginSenha.text);
      Preferences.salvar(Preference.MOD_ULTIMO_LOGIN, ModLogin.MOD_USUARIO);
      Preferences.salvar(Preference.USAR_TOKEN_ADMIN, false);

      MyLoadingDialog.ocultar();

      Rotas.irSemRetorno(context, Rotas.homePage);
    } catch (e) {
      MyLoadingDialog.ocultarComAbrirDialogErro(e);
      throw Exception("erro");
    }
  }

  Future verificarPermissaoAparelho({int? idUser, int tentativas = 20}) async {
    MyLoadingDialog.atualizarMensagem(
        Traducao.obter(Str.VERIFICANDO_AUTORIZACAO));

    bool autorizado = false;
    aparelhosDAO = await AparelhoDAO().init();
    if (tentativas > 1) {
      for (var i = 1; i <= tentativas; i++) {
        if (i > 1) {
          MyLoadingDialog.atualizarMensagem(Traducao.obter(
              Str.AGUARDANDO_AUTORIZACAO_X,
              params: [(i).toString()]));
        }

        autorizado = await aparelhosDAO?.pedirAutorizacaoAparelho(
                Util.somenteNumeros(tecCnpj.text), idUser) ??
            false;

        if (autorizado) {
          break;
        }

        await Future.delayed(const Duration(seconds: 3));
      }
    } else {
      autorizado = await aparelhosDAO?.pedirAutorizacaoAparelho(
              Util.somenteNumeros(tecCnpj.text), idUser) ??
          false;
    }

    if (autorizado) {
      return;
    }

    throw ExceptionTratada(Traducao.obter(Str.APARELHO_NAO_AUTORIZADO));
  }

  bool trocouUsuarioPorOutroOuEmpresa() {
    return (Preferences.obter(Preference.CNPJ) !=
            Util.somenteNumeros(tecCnpj.text)) ||
        (Preferences.obter(Preference.LOGIN) != txcLoginEmail.text) ||
        (Preferences.obter(Preference.MOD_ULTIMO_LOGIN) !=
            ModLogin.MOD_USUARIO);
  }

  bool trocouEmpresaPorOutraOuUsuario() {
    return (Preferences.obter(Preference.CNPJ) !=
            Util.somenteNumeros(tecCnpj.text)) ||
        (Preferences.obter(Preference.MOD_ULTIMO_LOGIN) !=
            ModLogin.MOD_EMPRESA);
  }
}
