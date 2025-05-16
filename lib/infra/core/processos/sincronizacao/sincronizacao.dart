import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:novo_ponto_alfa/domain/model/aparelho/aparelho_dao.dart';
import 'package:novo_ponto_alfa/domain/model/cerco/cercos_dao.dart';
import 'package:novo_ponto_alfa/domain/model/dados_auxiliares/dados_auxiliares_dao.dart';
import 'package:novo_ponto_alfa/domain/model/empresa/empresa.dart';
import 'package:novo_ponto_alfa/domain/model/empresa/empresa_dao.dart';
import 'package:novo_ponto_alfa/domain/model/filial/filial.dart';
import 'package:novo_ponto_alfa/domain/model/filial/filial_dao.dart';
import 'package:novo_ponto_alfa/domain/model/horarios/horarios_dao.dart';
import 'package:novo_ponto_alfa/domain/model/justificativa/falta/justificativas_falta_dao.dart';
import 'package:novo_ponto_alfa/domain/model/justificativa/lancamento/lancamento_justificativas.dart';
import 'package:novo_ponto_alfa/domain/model/justificativa/lancamento/lancamento_justificativas_dao.dart';
import 'package:novo_ponto_alfa/domain/model/pendencia/pendencias_dao.dart';
import 'package:novo_ponto_alfa/domain/model/periodo/periodos_dao.dart';
import 'package:novo_ponto_alfa/domain/model/ponto/registros_ponto.dart';
import 'package:novo_ponto_alfa/domain/model/ponto/registros_ponto_dao.dart';
import 'package:novo_ponto_alfa/domain/model/reconhecimento_facial/autenticacao_gryfo.dart';
import 'package:novo_ponto_alfa/domain/model/reconhecimento_facial/global_gryfo_lib.dart';
import 'package:novo_ponto_alfa/domain/model/reconhecimento_facial/pesos_gryfo.dart';
import 'package:novo_ponto_alfa/domain/model/reconhecimento_facial/sincronizacao_gryfo.dart';
import 'package:novo_ponto_alfa/domain/model/user/usuario.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_tratada.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:novo_ponto_alfa/infra/core/preferences/preferencias.dart';
import 'package:novo_ponto_alfa/infra/core/processos/sincronizacao/limpeza_dados_offline.dart';
import 'package:novo_ponto_alfa/infra/core/repositories/usuario/usuario_dao.dart';
import 'package:novo_ponto_alfa/ui/widgets/dialog/my_loading_dialog.dart';

class Sincronizacao {
  bool sincAutomatica = false;
  bool apenasEnviar = false;
  RxInt? qtdeRegistrosNaoEnviados;

  Sincronizacao somenteEnviarRegistros(bool apenasEnviar) {
    this.apenasEnviar = apenasEnviar;
    return this;
  }

  Sincronizacao isSincAutomatica(bool sincAutomatica) {
    this.sincAutomatica = sincAutomatica;
    return this;
  }

  Sincronizacao setRxIntQtdeRegistrosNaoEnviados(
      RxInt qtdeRegistrosNaoEnviados) {
    this.qtdeRegistrosNaoEnviados = qtdeRegistrosNaoEnviados;
    return this;
  }

  bool _exibirLoading() => !sincAutomatica;

  bool _precisaBaixarDados() => !apenasEnviar;

  Future executar(BuildContext context) async {
    try {
      if (_exibirLoading()) {
        MyLoadingDialog.exibir(context, MyDialogType.LOADING,
            mensagem: Traducao.obter(Str.SINCRONIZANDO));
      }

      await _enviarDados();

      if (_precisaBaixarDados()) {
        await _baixarDados();
      }

      if (_exibirLoading()) {
        MyLoadingDialog.atualizarMensagem(
            Traducao.obter(Str.PROCESSANDO_REGISTROS));
      }

      await LimpezaDadosOffline().executar();

      if (DateTime.now().hour > 2) {
        Preferences.setDate(Preference.DATA_ULTIMA_SINC, DateTime.now());
      }

      await _sincronizarDadosGryfo(context);

      MyLoadingDialog.atualizarMensagem("Sincronizacao efetuada com sucesso!");

      await Future.delayed(const Duration(seconds: 1));

      MyLoadingDialog.ocultar();
    } on ExceptionTratada catch (e) {
      if (_exibirLoading()) {
        MyLoadingDialog.ocultarComAbrirDialogErro(e);
      }
    } on SocketException catch (e) {
      if (_exibirLoading()) {
        MyLoadingDialog.ocultarComAbrirDialogMensagem(e.toString());
      }
    } catch (e) {
      if (_exibirLoading()) {
        MyLoadingDialog.ocultarComAbrirDialogErro(e);
      }
    } finally {
      Filial? filial = await Preferences.filialLogada();

      AparelhoDAO aparelhosDAO = await AparelhoDAO().init();
      final autorizado =
          await aparelhosDAO.pedirAutorizacaoAparelho(filial!.cnpj ?? '', null);

      if (!autorizado) {
        throw ExceptionTratada(
            Traducao.obter(Str.O_ACESSO_DESTE_DISPOSITIVO_FOI_REVOGADO),
            isFatal: true);
      }

      if (Preferences.obter(Preference.MOD_ULTIMO_LOGIN) ==
          ModLogin.MOD_USUARIO) {
        if (!Preferences.obter(Preference.PERMITIR_LOGIN_USUARIO)) {
          throw ExceptionTratada(
              Traducao.obter(Str.O_ACESSO_DESTE_DISPOSITIVO_FOI_REVOGADO),
              isFatal: true);
        }
      } else {
        if (!Preferences.obter(Preference.PERMITIR_LOGIN_EMPRESA)) {
          throw ExceptionTratada(
              Traducao.obter(Str.O_ACESSO_DESTE_DISPOSITIVO_FOI_REVOGADO),
              isFatal: true);
        }
      }
    }
  }

  Future _sincronizarDadosGryfo(BuildContext context) async {
    SincronizacaoGryfo sincronizacaoGryfo = SincronizacaoGryfo();
    PesosGryfo pesosGryfo = PesosGryfo();
    AutenticacaoGryfo autenticacaoGryfo = AutenticacaoGryfo();

    if (_exibirLoading()) {
      MyLoadingDialog.atualizarMensagem("Autenticando Gryfo");
    }

    await autenticacaoGryfo.autenticarEmpresaGryfo();

    if (_exibirLoading()) {
      MyLoadingDialog.atualizarMensagem("Baixando pesos Gryfo");
    }
    await pesosGryfo.baixarPesosGryfo();

    if (_exibirLoading()) {
      MyLoadingDialog.atualizarMensagem("Sincronizando Gryfo");
    }

    await sincronizacaoGryfo.sincronizarDados(context);
  }

  Future _enviarDados() async {
    if (_exibirLoading()) {
      MyLoadingDialog.atualizarMensagem(Traducao.obter(Str.ENVIANDO_REGISTROS));
    }

    RegistrosPontoDAO registrosPontoDAO = await RegistrosPontoDAO().init();
    List<RegistrosPonto> registros =
        await registrosPontoDAO.obterRegistrosAindaNaoSincronizados();
    for (RegistrosPonto registro in registros) {
      await _enviarPonto(registro);
    }

    await registrosPontoDAO.deletarTodosEnviadosExetoDoDia();

    LancamentoJustificativasDAO lancamentoJustificativasDAO =
        await LancamentoJustificativasDAO().init();
    List<LancamentoJustificativas> lancamentos =
        await lancamentoJustificativasDAO.obterRegistrosAindaNaoSincronizados();
    for (LancamentoJustificativas lancamento in lancamentos) {
      await _enviarJustificativa(lancamento);
    }
    await lancamentoJustificativasDAO.deletarTodosEnviadosExetoDoDia();
  }

  Future _baixarDados() async {
    FilialDAO filiaisDAO = await FilialDAO().init();
    Filial? filial;

    MyLoadingDialog.atualizarMensagem(
        Traducao.obter(Str.SINCRONIZANDO_DADOS_DA_EMPRESA));

    if (Preferences.obter(Preference.MOD_ULTIMO_LOGIN) ==
        ModLogin.MOD_EMPRESA) {
      filial =
          await filiaisDAO.obterPorCnpj(Preferences.obter(Preference.CNPJ));

      UsuarioDAO usersDAO = await UsuarioDAO().init();

      await usersDAO.importAllFromServerFiltered(
          Usuario(), {'filial_id': filial.id, 'ativo': true});
    } else {
      Usuario? user = await Preferences.usuarioLogado();

      await filiaisDAO
          .importAllFromServerFiltered(Filial(), {'id': user!.filialId});
      filial = await filiaisDAO.getById(Filial(), user.filialId);
    }

    EmpresaDAO empresasDAO = await EmpresaDAO().init();
    await empresasDAO
        .importAllFromServerFiltered(Empresa(), {'id': filial?.empresaId});

    MyLoadingDialog.atualizarMensagem(
        Traducao.obter(Str.SINCRONIZANDO_DADOS_AUXILIARES));

    DadosAuxiliaresDAO dadosAuxiliaresDAO = await DadosAuxiliaresDAO().init();
    await dadosAuxiliaresDAO.importarDados();

    MyLoadingDialog.atualizarMensagem(Traducao.obter(Str.SINCRONIZANDO_CERCOS));

    CercosDAO cercosDAO = await CercosDAO().init();
    await cercosDAO.importarDados();

    MyLoadingDialog.atualizarMensagem(
        Traducao.obter(Str.SINCRONIZANDO_PERIODOS));

    PeriodosDAO periodosDAO = await PeriodosDAO().init();
    await periodosDAO.importarDados();

    MyLoadingDialog.atualizarMensagem(
        Traducao.obter(Str.SINCRONIZANDO_HORARIOS));

    HorarioDAO horariosDAO = await HorarioDAO().init();
    await horariosDAO.importarDados();

    MyLoadingDialog.atualizarMensagem(
        Traducao.obter(Str.SINCRONIZANDO_JUSTIFICATIVAS));

    JustificativasFaltaDAO justDAO = await JustificativasFaltaDAO().init();
    await justDAO.importarDados();

    MyLoadingDialog.atualizarMensagem(
        Traducao.obter(Str.SINCRONIZANDO_PENDENCIAS));

    PendenciasDAO pendenciasDAO = await PendenciasDAO().init();
    await pendenciasDAO.importarDados();
  }

  Future _enviarPonto(RegistrosPonto registro) async {
    try {
      await registro.enviar();

      if (qtdeRegistrosNaoEnviados != null &&
          qtdeRegistrosNaoEnviados!.value > 0) {
        qtdeRegistrosNaoEnviados!.value = qtdeRegistrosNaoEnviados!.value - 1;
      }
    } on TimeoutException {
      throw ExceptionTratada(Traducao.obter(Str
          .SUA_CONEXAO_NAO_E_ESTAVEL_TENTE_MAIS_TARDE_OU_COM_UMA_CONEXAO_MELHOR));
    } catch (e) {
      String message = e.toString();

      // Verifica se é um erro de Unique ID duplicado.
      if (message.contains('SQLSTATE[23505]: Unique violation')) {
        // Envia-o para o Sentry, porém, não o propaga.
        // A duplicação de Unique ID acontece em casos exclusos por falhas no assíncronismo.
        // A API garante que nenhum registro duplicado seja inserido, então
        // passamos a ignorar erros deste tipo.
        //Sentry().report(error, trace);
      } else {
        // MySentry.reportar(e);
      }
    }
  }

  Future _enviarJustificativa(LancamentoJustificativas registro) async {
    try {
      await registro.enviar();
    } on TimeoutException {
      throw ExceptionTratada(Traducao.obter(Str
          .SUA_CONEXAO_NAO_E_ESTAVEL_TENTE_MAIS_TARDE_OU_COM_UMA_CONEXAO_MELHOR));
    } catch (error) {
      rethrow;
    }
  }
}
