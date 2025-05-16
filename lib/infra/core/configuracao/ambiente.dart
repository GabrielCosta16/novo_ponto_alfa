
import 'package:novo_ponto_alfa/infra/core/preferences/preferencias.dart';

enum Environment { HOMOLOGACAO, PRODUCAO }

class Ambiente {
  static Map<String, dynamic>? _config;

  static void useHomologacao() {
    _config = _Config.homologacao;
  }

  static void useProducao() {
    _config = _Config.producao;
  }

  static get AMBIENTE_ASYNC {
    var ambiente = Preferences.obter(Preference.AMBIENTE);
    if (ambiente == null || ambiente == '') return _config![_Config.AMBIENTE];

    return ambiente;
  }

  static get AMBIENTE {
    return _config![_Config.AMBIENTE];
  }

  static get URL {
    return _config![_Config.URL];
  }

  static get API_ASYNC {
    var api = Preferences.obter(Preference.API);
    if (api == null || api == '') return _config![_Config.API];

    return api;
  }

  static get API_PRINCIPAL {
    return _config![_Config.API_PRINCIPAL];
  }

  static get POLITICA_PRIVACIDADE {
    return _config![_Config.POLITICA_PRIVACIDADE];
  }

  static get POLITICA_PRIVACIDADE_2 {
    return _config![_Config.POLITICA_PRIVACIDADE_2];
  }

  static get ENVIRONMENT {
    return _config![_Config.ENVIRONMENT];
  }

  static get HOST_CHECK_STATUS_INTERNET {
    return _config![_Config.HOST_CHECK_STATUS_INTERNET];
  }

  static get HOST_CHECK_STATUS_PONTO {
    return _config![_Config.HOST_CHECK_STATUS_PONTO];
  }
}

class PathRequisicao {
  static var URL_LANCAMENTO_JUSTIFICATIVA =
      '${Ambiente.API_ASYNC}base/LancamentoJustificativa/registrar';

  static var URL_REGISTRAR_PONTO =
      '${Ambiente.API_ASYNC}base/RegistrosPonto/registrar';

  static var URL_AUTENTICAR_LOGIN_API_PRINCIPAL =
      '${Ambiente.API_PRINCIPAL}login';

  static var URL_AUTENTICAR_CNPJ =
      '${Ambiente.API_PRINCIPAL}base/ambiente/obterAmbiente?cnpj=';

  static var URL_AUTENTICAR_LOGIN = '${Ambiente.API_ASYNC}login';

  static var URL_AUTENTICAR_LOGIN_GRYFO = '${Ambiente.API_ASYNC}login-gryfo';

  static var URL_AMBIENTE_BASE = '${Ambiente.API_ASYNC}base/';

  static var URL_OBTER_PENDENCIAS_FILIAL =
      '${Ambiente.API_ASYNC}base/pendencias/obterPendenciasFilial?filial_id=';

  static var URL_OBTER_PENDENCIAS_USUARIO =
      '${Ambiente.API_ASYNC}base/pendencias/obterPendenciasUser?user_id=';

  static var URL_CONSULTAR_PONTOS =
      '${Ambiente.API_ASYNC}base/registros_ponto/all';

  static var URL_ESPELHO_PONTO =
      '${Ambiente.API_ASYNC}admin/controle-de-ponto-espelho/';
}

class _Config {
  static const AMBIENTE = 'AMBIENTE';
  static const URL = 'URL';
  static const API = 'API';
  static const API_PRINCIPAL = 'API_PRINCIPAL';
  static const POLITICA_PRIVACIDADE = 'POLITICA_PRIVACIDADE';
  static const ENVIRONMENT = 'ENVIRONMENT';
  static const HOST_CHECK_STATUS_PONTO = 'URL_CHECK_STATUS_PONTO';
  static const HOST_CHECK_STATUS_INTERNET = 'URL_CHECK_STATUS_INTERNET';
  static const POLITICA_PRIVACIDADE_2 = 'POLITICA_PRIVACIDADE_2';

  static Map<String, dynamic> homologacao = {
    AMBIENTE: 'HOMOLOGAÇÃO',
    URL: 'http://homologacao.pontoalfa.net.br/',
    API: 'http://homologacao.pontoalfa.net.br/api/',
    HOST_CHECK_STATUS_PONTO: 'homologacao.pontoalfa.net.br',
    HOST_CHECK_STATUS_INTERNET: 'google.com.br',
    API_PRINCIPAL: 'https://homologacao.pontoalfa.net.br/api/',
    POLITICA_PRIVACIDADE:
        'https://www.alfainformatica.net.br/termos-de-uso-ponto-alfa',
    POLITICA_PRIVACIDADE_2:
        'https://www.alfainformatica.net.br/politicas-de-confidencialidade-ponto-alfa',
    ENVIRONMENT: 'homologacao',
  };

  static Map<String, dynamic> producao = {
    AMBIENTE: '',
    HOST_CHECK_STATUS_PONTO: 'https://sistema.pontoalfa.net.br/',
    HOST_CHECK_STATUS_INTERNET: 'google.com.br',
    URL: 'https://sistema.pontoalfa.net.br/',
    API: 'http://sistema.pontoalfa.net.br/api/',
    API_PRINCIPAL: 'http://sistema.pontoalfa.net.br/api/',
    POLITICA_PRIVACIDADE:
        'https://www.alfainformatica.net.br/termos-de-uso-ponto-alfa',
    POLITICA_PRIVACIDADE_2:
        'https://www.alfainformatica.net.br/politicas-de-confidencialidade-ponto-alfa',
    ENVIRONMENT: 'prod',
  };
}
