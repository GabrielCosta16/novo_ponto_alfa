
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_permissao_negada.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissaoLocalizacao {
  static Future solicitarPermissao() async {
    if (await Permission.location.isGranted) {
      return;
    }
    if (await Permission.location.isLimited) {
      return;
    }

    await _requisitarPermissaoLocation();

    // if (Platform.isAndroid) {
    //   await AlertSolicitarPermissao.exibir(
    //     descricao: Traducao.obter(Str.ACESSO_A_LOCALIZACAO),
    //     icon: MyIcons.iconeLocalizacaoPermissao,
    //     detalhado: Traducao.obter(Str
    //         .O_PONTO_RAPIDO_PRECISA_DE_ACESSO_A_LOCALIZACAO_PARA_PODER_REGISTRAR_O_PONTO),
    //     onClickSolicitar: _requisitarPermissaoLocation,
    //   );
    // } else {
    //   await _requisitarPermissaoLocation();
    // }
  }

  static Future _requisitarPermissaoLocation() async {
    PermissionStatus status = await Permission.location.request();

    switch (status) {
      case PermissionStatus.granted:
        return;
      case PermissionStatus.limited:
        return;
      case PermissionStatus.denied:
        throw PermissaoNegadaExcetion(
            Traducao.obter(Str.PERMISSAO_NEGADA),
            '${Traducao.obter(Str.PERMISSAO_PARA_A_LOCALIZACAO_NAO_ESTA_ACEITA)}\n\n${Traducao.obter(
                    Str.PARA_ACEITAR_A_PERMISSAO_ACESSE_AS_CONFIGURACOES)}');
      case PermissionStatus.permanentlyDenied:
        throw PermissaoNegadaExcetion(
            Traducao.obter(Str.PERMISSAO_PERMANENTEMENTE_NEGADA),
            '${Traducao.obter(Str
                    .PERMISSAO_PARA_A_LOCALIZACAO_ESTA_PERMANENTEMENTE_NEGADA)}\n\n${Traducao.obter(
                    Str.PARA_ACEITAR_A_PERMISSAO_ACESSE_AS_CONFIGURACOES)}');
      case PermissionStatus.restricted:
        throw PermissaoNegadaExcetion(
            Traducao.obter(Str.PERMISSAO_RESTRITA),
            Traducao.obter(Str
                .HABILITE_A_PERMISSAO_DIRETAMENTE_NAS_CONFIGURACOES_DO_SISTEMA));
      default:
        break;
    }
  }
}
