

import 'package:novo_ponto_alfa/domain/model/custom_dao.dart';
import 'package:novo_ponto_alfa/domain/model/filial/filial.dart';
import 'package:novo_ponto_alfa/domain/model/pendencia/pendencias.dart';
import 'package:novo_ponto_alfa/domain/model/user/usuario.dart';
import 'package:novo_ponto_alfa/infra/core/configuracao/ambiente.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_tratada.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:novo_ponto_alfa/infra/core/preferences/preferencias.dart';
import 'package:novo_ponto_alfa/infra/core/services/database.dart';

class PendenciasDAO extends CustomDAO<Pendencias> {
  Future<PendenciasDAO> init() async {
    database = await DbHelper.getInstance();
    return this;
  }

  @override
  String table() {
    return 'pendencias';
  }

  Future importarDados() async {
    if (Preferences.obter(Preference.MOD_ULTIMO_LOGIN) ==
        ModLogin.MOD_EMPRESA) {
      Filial? filial = await Preferences.filialLogada();
      if (filial == null) {
        throw ExceptionTratada(Traducao.obter(
            Str.A_FILIAL_ASSOCIADA_A_ESTE_USUARIO_NAO_FOI_ENCONTRADA));
      }

      var url =
          PathRequisicao.URL_OBTER_PENDENCIAS_FILIAL + (filial.id).toString();

      deleteWithWhere("");
      await importAllFromServerFiltered(Pendencias(), {}, urlCustom: url);
    } else {
      Usuario? user = await Preferences.usuarioLogado();
      if (user == null) {
        throw ExceptionTratada(
            Traducao.obter(Str.O_USUARIO_ATUAL_NAO_PODE_SER_IDENTIFICADO));
      }

      var url =
          PathRequisicao.URL_OBTER_PENDENCIAS_USUARIO + (user.id).toString();
      deleteWithWhere("");
      await importAllFromServerFiltered(Pendencias(), {}, urlCustom: url);
    }
  }
}
