
import 'package:flutter_udid/flutter_udid.dart';
import 'package:novo_ponto_alfa/domain/model/aparelho/aparelho.dart';
import 'package:novo_ponto_alfa/domain/model/custom_dao.dart';
import 'package:novo_ponto_alfa/domain/model/filial/filial.dart';
import 'package:novo_ponto_alfa/domain/model/filial/filial_dao.dart';
import 'package:novo_ponto_alfa/infra/core/configuracao/ambiente.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_tratada.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:novo_ponto_alfa/infra/core/preferences/preferencias.dart';
import 'package:novo_ponto_alfa/infra/core/requisicoes/requisitar_get.dart';
import 'package:novo_ponto_alfa/infra/core/services/database.dart';
import 'package:novo_ponto_alfa/infra/core/utils/device_utils.dart';

class AparelhoDAO extends CustomDAO<Aparelho> {
  Future<AparelhoDAO> init() async {
    database = await DbHelper.getInstance();
    return this;
  }

  @override
  String table() {
    return 'aparelhos';
  }

  Future<Aparelho> obterIdMeuAparelho() async {
    String udid = await FlutterUdid.udid;

    Aparelho? aparelhos =
        await getBy(Aparelho(), " where unique_id = '$udid'");

    if (aparelhos == null) {
      throw ExceptionTratada(Traducao.obter(Str
          .ESTE_APARELHO_NAO_FAZ_PARTE_DA_RELACAO_DE_DISPOSITIVOS_CONHECIDOS));
    }

    return aparelhos;
  }

  Future<bool> pedirAutorizacaoAparelho(String? cnpj, int? userId) async {
    String udid = await FlutterUdid.udid;

    try {
      var userIdString = "";
      if (userId != null) {
        userIdString = "user_id=$userId";
      }

      var versaoApp = DeviceUtils.versionDisplay();

      var url = "${PathRequisicao.URL_AMBIENTE_BASE}${table()}/pedirAutorizacao?cnpj=$cnpj&unique_id=$udid&$userIdString&versao_app=$versaoApp";

      final response = await RequisicaoGet().executar(url);

      await deleteWithWhere("");

      for (dynamic responseObj in response) {
        Preferences.salvar(Preference.HABILITAR_RECONHECIMENTO_DE_FACE,
            responseObj['habilitar_reconhecimento_de_face'] ?? false);

        Preferences.salvar(Preference.PERMITIR_LOGIN_EMPRESA,
            responseObj['permitir_login_empresa'] ?? false);

        Preferences.salvar(Preference.PERMITIR_LOGIN_USUARIO,
            responseObj['permitir_login_usuario'] ?? false);

        Preferences.salvar(Preference.ENVIAR_PONTO_AO_REGISTRAR,
            responseObj['enviar_ponto_ao_registrar'] ?? false);

        Preferences.salvar(
            Preference.APELIDO_APARELHO, responseObj['apelido'] ?? '');

        Preferences.salvar(Preference.TIPO_LAYOUT_REGISTRO_PONTO,
            responseObj['tipo_layout_registro_ponto_id'] ?? 0);

        await update(Aparelho().convertJson(responseObj));
      }
    } catch (e) {
      // TODO - testar request
      print(e);
    }

    FilialDAO filiaisDAO = await FilialDAO().init();
    Filial? filial = await filiaisDAO.obterPorCnpjBase(cnpj);

    if (filial != null) {
      Aparelho? obj = await getBy(Aparelho(),
          " where unique_id = '$udid' and filial_id = ${filial.id}");

      if (obj != null && obj.autorizado!) {
        return true;
      }
    }

    return false;
  }
}
