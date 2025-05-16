import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';

class PTBR {
  static Map<String, Map<String, String>> obter() {
    Map<String, String> mmap = {};

    mmap[Str.VERSAO.toString()] = 'Versão: ';
    mmap[Str.IDENTIFICADOR_DO_APARELHO.toString()] = 'ID do aparelho:';
    mmap[Str.EMPRESA.toString()] = 'Empresa';
    mmap[Str.USUARIO.toString()] = 'Usuário';
    mmap[Str.CNPJ.toString()] = 'CNPJ';
    mmap[Str.O_CNPJ_INFORMADO_E_INVALIDO.toString()] =
        'O CNPJ informado é inválido.';
    mmap[Str.VERIFICANDO_CNPJ.toString()] = 'Verificando CNPJ';
    mmap[Str.EMAIL_OU_MATRICULA.toString()] = 'E-mail ou matrícula';
    mmap[Str.ENTRAR.toString()] = 'Entrar';
    mmap[Str.SENHA.toString()] = 'Senha';
    mmap[Str.ABERTO.toString()] = ' - ABERTO';
    mmap[Str.AGUARDANDO_AUTORIZACAO.toString()] = 'Aguardando autorização.';
    mmap[Str.AGUARDANDO_AUTORIZACAO_X.toString()] =
        'Aguardando autorização. Tentativa %s';
    mmap[Str.APARELHO_NAO_AUTORIZADO.toString()] = 'Aparelho não autorizado!';
    mmap[Str.ESTE_APARELHO_NAO_E_PERMITIDO_PARA_USO_COLETIVO.toString()] =
        'Este aparelho não é permitido para uso coletivo!';
    mmap[Str.ESTE_APARELHO_NAO_E_PERMITIDO_PARA_LOGIN_DE_USUARIO.toString()] =
        'Este aparelho não é permitido para login de usuário!';
    mmap[Str.AUTENTICANDO.toString()] = 'Autenticando...';
    mmap[Str.O_LOGIN_E_OU_SENHA_INFORMADA_SAO_INVALIDOS.toString()] =
        'O login e/ou a senha informada são inválidos';
    mmap[Str.OS_DADOS_DE_ACESSO_INFORMADOS_NAO_ENCONTRADOS_NA_BASE_DE_DADOS_OFFLINE
            .toString()] =
        'Os dados de acesso informados não foram encontrados na base de dados offline. Por favor, tente realizar o acesso utilizando uma conexão de internet.';
    mmap[Str.OS_DADOS_DE_ACESSO_INFORMADOS_SAO_INVALIDOS_NENHU_USUARIO_FOI_ENCONTRADO_VERIFIQUE_SUA_CONEXAO_E_TENTE_NOVAMENTE
            .toString()] =
        'Os dados de acesso informados são inválidos, nenhum usuário foi encontrado. Verifique a sua conexão e tente novamente.';
    mmap[Str.ESTE_APARELHO_NAO_FAZ_PARTE_DA_RELACAO_DE_DISPOSITIVOS_CONHECIDOS
            .toString()] =
        'Este aparelho não faz parte da relação de dispositivos conhecidos.';
    mmap[Str.PONTO_RAPIDO.toString()] = 'Ponto Alfa';
    mmap[Str.CONSULTA_DE_PONTOS.toString()] = 'Consulta de pontos';
    mmap[Str.REGISTRAR_PONTO.toString()] = 'Registrar ponto';
    mmap[Str.MANUTENCAO.toString()] = 'Manutenção';
    mmap[Str.SINCRONIZAR.toString()] = 'Sincronizar';
    mmap[Str.CONFIGURACOES.toString()] = 'Configurações';
    mmap[Str.SAIR.toString()] = 'Sair';
    mmap[Str.LIMPAR.toString()] = 'Limpar';
    mmap[Str.SALVAR.toString()] = 'Salvar';
    mmap[Str.GRAVAR.toString()] = 'Gravar';
    mmap[Str.APAGAR.toString()] = 'Apagar';
    mmap[Str.AVISO.toString()] = 'Aviso';
    mmap[Str.OK.toString()] = 'OK';
    mmap[Str.CANCELAR.toString()] = 'Cancelar';
    mmap[Str.DESCARTAR.toString()] = 'Descartar';
    mmap[Str.CONTINUAR.toString()] = 'Continuar';
    mmap[Str.SOLICITAR.toString()] = 'Solicitar';
    mmap[Str.SIM.toString()] = 'Sim';
    mmap[Str.NAO.toString()] = 'Não';
    mmap[Str.LANCAMENTO_MANUAL.toString()] = 'Lançamento manual';
    mmap[Str.ADICIONAR_JUSTIFICATIVA.toString()] = 'Adicionar justificativa';
    mmap[Str.JUSTIFICATIVA.toString()] = 'Justificativa';
    mmap[Str.SEM_PONTOS_REGISTRADOS.toString()] = 'Sem pontos registrados!';
    mmap[Str.SEM_POSICAO_NO_MAPA.toString()] = 'Sem posição no mapa.';
    mmap[Str.REGISTROS_DE_HOJE.toString()] = 'Registros de hoje:';
    mmap[Str.SEM_PONTOS.toString()] = 'Sem pontos!';
    mmap[Str.REGISTRADO_AS_X1.toString()] = 'Registrado às %s';
    mmap[Str.SEM_FOTO.toString()] = 'Sem foto!';
    mmap[Str.TIRAR_FOTO.toString()] = 'Tirar foto';
    mmap[Str.FOTO_PARA_ANEXO.toString()] = 'Foto para anexo.';
    mmap[Str.DATA_E_HORA_DO_PONTO.toString()] = 'Data e hora do ponto';
    mmap[Str.NAO_SELECIONADO.toString()] = 'Não selecionado';
    mmap[Str.OUTRA_FOTO.toString()] = 'Outra foto';
    mmap[Str.CUIDADO.toString()] = 'Cuidado';
    mmap[Str.VOCE_DESEJA_SAIR_SEM_GRAVAR_O_PONTO.toString()] =
        'Você deseja sair sem gravar o ponto?';
    mmap[Str.A_MATRICULA_INFORMADA_E_INVALIDA.toString()] =
        'A matrícula informada é inválida.';
    mmap[Str.SELECIONE_A_MATRICULA.toString()] = 'Selecione a matrícula';
    mmap[Str.A_EMPRESA_ASSOCIADA_A_ESTE_USUARIO_NAO_FOI_ENCONTRADA.toString()] =
        'A empresa associada a este usuário não foi encontrada.';
    mmap[Str.A_FILIAL_ASSOCIADA_A_ESTE_USUARIO_NAO_FOI_ENCONTRADA.toString()] =
        'A filial associada a este usuário não foi encontrada.';
    mmap[Str.O_USUARIO_ATUAL_NAO_PODE_SER_IDENTIFICADO.toString()] =
        'O usuário atual não pode ser identificado.';
    mmap[Str.O_USUARIO_INFORMADO_ESTA_INATIVO_E_NAO_PODE_SER_ACESSADO
            .toString()] =
        'O usuário informado está inativo e não pode ser acessado.';
    mmap[Str.A_LOCALIZACAO_ATUAL_NAO_PODE_SER_OBTIDA.toString()] =
        'A localização atual não pode ser obtida.';
    mmap[Str.VOCE_NAO_ESTA_DENTRO_DE_NENHUM_CERCO_DE_TRABALHO.toString()] =
        'Você não está dentro de nenhum cerco de trabalho.';
    mmap[Str.VOCE_NAO_PODE_LANCAR_UM_PONTO_PARA_UMA_DATA_E_HORA_FATURADA
            .toString()] =
        'Você não pode lançar um ponto para uma data e hora futura.';
    mmap[Str.IMAGEM_DE_ASSINATURA_DE_REGISTRO_DE_PONTO_NAO_ENCONTRADA_UNIQUE_ID_X1
            .toString()] =
        'Imagem de assinatura de registro de ponto não encontrada, unique ID: %s';
    mmap[Str.O_REGISTRO_X1_NAO_PODE_SER_ENVIADO.toString()] =
        'O registro %s não pode ser enviado.';
    mmap[Str.IMAGEM_DE_FACE_DE_REGISTRO_DE_PONTO_NAO_PODE_SER_ENCONTRADA_UNIQUE_ID_X1
            .toString()] =
        'Imagem de face de registro de ponto não encontrada, unique ID: %s';
    mmap[Str.O_ARQUIVO_CAPTURA_DE_FACE_DO_REGISTRO_X1_NAO_FOI_ENCONTRADO
            .toString()] =
        'O arquivo "captura de face" do registro %s não foi encontrada no dispositivo.';
    mmap[Str.PARA_CONSULTAR_VOCE_PRECISA_ESTAR_CONECTADO_COM_A_INTERNET
            .toString()] =
        'Para consultar você precisa estar conectado a internet!';
    mmap[Str.BUSCANDO_PONTOS.toString()] = 'Buscando pontos';
    mmap[Str.X1_E_DE_PREENCHIMENTO_OBRIGATORIO.toString()] =
        '%s é de preenchimento obrigatório!';
    mmap[Str.A_HORA_DE_LANCAMENTO_E_OBRIGATORIA.toString()] =
        'A hora de lançamento é obrigatória!';
    mmap[Str.O_MOTIVO_DE_LANCAMENTO_E_OBRIGATORIO.toString()] =
        'O motivo do lançamento é obrigatório!';
    mmap[Str.A_SELECAO_DE_UMA_JUSTIFICATICA_E_OBRIGATORIA.toString()] =
        'A seleção de uma justificativa é obrigatória!';
    mmap[Str.LANCAMENTO_DE_JUSTIFICATIVA.toString()] =
        'Lançamento de justificativa';
    mmap[Str.DIA_TODO.toString()] = 'Dia todo';
    mmap[Str.A_CAPTURA_DE_UMA_FOTO_E_OBRIGATORIA.toString()] =
        'A captura de uma foto é obrigatória!';
    mmap[Str.O_PREENCHIMENTO_DA_HORA_DE_INICIO_E_OBRIGATORIA.toString()] =
        'O preenchimento da hora de início é obrigatória!';
    mmap[Str.O_PREENCHIMENTO_DA_HORA_DE_FIM_E_OBRIGATORIA.toString()] =
        'O preenchimento da hora de fim é obrigatória!';
    mmap[Str.A_HORA_DE_INICIO_INFORMADA_NAO_TEM_UM_VALOR_VALIDO.toString()] =
        'A hora de início informada não tem um valor válido.';
    mmap[Str.A_HORA_DE_FIM_INFORMADA_NAO_TEM_UM_VALOR_VALIDO.toString()] =
        'A hora de fim informada não tem um valor válido.';
    mmap[Str.JUSTIFICATIVA_ENVIADA_COM_SUCESSO.toString()] =
        'Justificativa enviada com sucesso!';
    mmap[Str.CONSULTAR_PONTOS.toString()] = 'Consultar pontos';
    mmap[Str.VALIDANDO_USUARIO.toString()] = 'Validando o usuário';
    mmap[Str.GRAVANDO_REGISTRO.toString()] = 'Gravando registro';
    mmap[Str.CARREGANDO.toString()] = 'Carregando...';
    mmap[Str.POR_FAVOR_AGUARDE.toString()] = 'Por favor, aguarde...';
    mmap[Str.ESCANEANDO.toString()] = 'Escaneando...';
    mmap[Str.PROCURAR.toString()] = 'Procurar...';
    mmap[Str.REGISTRANDO_PONTO.toString()] = 'Registrando ponto';
    mmap[Str.SELECIONE_O_A.toString()] = 'Selecione o (a) ';
    mmap[Str.HORA.toString()] = 'Hora';
    mmap[Str.QUAL_A_HORA.toString()] = 'Qual a hora?';
    mmap[Str.HORA_DE_INICIO.toString()] = 'Hora de início';
    mmap[Str.HORA_DE_FIM.toString()] = 'Hora de fim';
    mmap[Str.HORA_INVALIDA.toString()] = 'Hora inválida!';
    mmap[Str.DESCONTAR_DO_BANCO_DE_HORAS.toString()] =
        'Descontar do banco de horas?';
    mmap[Str.REGISTRAR_JUSTIFICATIVA.toString()] = 'Registrar justificativa';
    mmap[Str.REGISTRAR_LANCAMENTO.toString()] = 'Registrar Lançamento';
    mmap[Str.VER_PENDENCIAS.toString()] = 'Ver pendências';
    mmap[Str.PENDENCIAS.toString()] = 'Pendências';
    mmap[Str.A_HORA_E_OBRIGATORIA.toString()] = 'A hora é obrigatória';
    mmap[Str.MOTIVO.toString()] = 'Motivo';
    mmap[Str.QUAL_O_MOTIVO.toString()] = 'Qual o motivo?';
    mmap[Str.O_MOTIVO_E_OBRIGATORIO.toString()] = 'O motivo é obrigatório!';
    mmap[Str.MATRICULA.toString()] = 'Matrícula';
    mmap[Str.DATA.toString()] = 'Data';
    mmap[Str.QUAL_A_DATA_DE_REFERENCIA.toString()] =
        'Qual a data de referência?';
    mmap[Str.SELECIONE_UMA_DATA_DE_REFERENCIA.toString()] =
        'Selecione uma data de referência.';
    mmap[Str.QUAL_A_ACAO.toString()] = 'Qual a ação?';
    mmap[Str.VER_NO_MAPA.toString()] = 'Ver no mapa';
    mmap[Str.UNIQUE_ID_E_OBRIGATORIO.toString()] = 'unique_id é obrigatório';
    mmap[Str.ESTE_USUARIO_ESTA_AFASTADO_MAS_O_PONTO_SERA_REGISTRADO
            .toString()] =
        'Este usuário está afastado, mas o ponto será registrado.';
    mmap[Str.ESTE_USUARIO_ESTA_EM_FERIAS_MAS_O_PONTO_SERA_REGISTRADO
            .toString()] =
        'Este usuário está em férias, mas o ponto será registrado.';
    mmap[Str.A_CAPTURA_DE_FACE_FOTO_E_OBRIGATORIA.toString()] =
        'A captura de face (foto) é obrigatória.';
    mmap[Str.NENHUM_ROSTO_FOI_DETECTADO_NA_CAPTURA_DE_FACE.toString()] =
        'Nenhum rosto foi identificado na captura de face.';
    mmap[Str.A_ASSINATURA_DO_REGISTRO_E_OBRIGATORIA.toString()] =
        'A assinatura do registro é obrigatória';
    mmap[Str.TENTATIVA_X1_DE_3.toString()] = 'Tentativa %s de 3.';
    mmap[Str.PONTO_REGISTRADO_COM_SUCESS0.toString()] =
        'Ponto registrado com sucesso!';
    mmap[Str.INSERIR_AUTOMATICAMENTE_X1_AO_GRAVAR_PONTO.toString()] =
        'Inserir automaticamente o %s ao gravar um ponto?';
    mmap[Str.PERMITIR_SELECAO_DE_X1_NO_REGISTRO_DE_PONTO.toString()] =
        'Permitir seleção de %s no registro de ponto?';
    mmap[Str.SEM_ITENS_ENCONTRADOS.toString()] = 'Sem itens encontrados.';
    mmap[Str.SELECIONE_AQUI.toString()] = 'Selecione aqui';
    mmap[Str.SELECIONE.toString()] = 'Selecione...';
    mmap[Str.VERIFICANDO_CONEXAO.toString()] = 'Verificando conexão';
    mmap[Str.VERIFIQUE_SUA_CONEXAO_INTERNET.toString()] =
        'Verifique a sua conexão com a internet.';
    mmap[Str.SEM_CONEXAO_COM_A_INTERNET.toString()] =
        'Sem conexão com internet!';
    mmap[Str.NENHUM_REGISTRO_DE_PONTO_ENCONTRADO_NESTA_DATA.toString()] =
        'Nenhum registro de ponto encontrado nesta data!';
    mmap[Str.BAIXANDO_ESPELHO.toString()] = 'Baixando espelho';
    mmap[Str.ESPELHO_DE_PONTO.toString()] = 'Espelho de Ponto';
    mmap[Str.VER_ESPELHO.toString()] = 'Ver espelho';
    mmap[Str.CADASTRAR_FACE.toString()] = 'Cadastrar face';
    mmap[Str.PONTO_MUITO_PROXIMO_AO_ULTIMO_PARA_ESSA_MATRICULA.toString()] =
        'Ponto muito próximo ao último registrado para esta matrícula.';
    mmap[Str.ASSINE_ABAIXO.toString()] = 'Assine abaixo:';
    mmap[Str.O_ACESSO_DESTE_DISPOSITIVO_FOI_REVOGADO.toString()] =
        'O acesso deste dispositivo foi revogado.';
    mmap[Str.ENVIANDO_INFORMACOES.toString()] = 'Enviando informações';
    mmap[Str.SINCRONIZANDO_DADOS_DA_EMPRESA.toString()] =
        'Sincronizando dados da empresa';
    mmap[Str.SINCRONIZANDO_DADOS_AUXILIARES.toString()] =
        'Sincronizando dados auxiliares';
    mmap[Str.SINCRONIZANDO_CERCOS.toString()] = 'Sincronizando cercos';
    mmap[Str.SINCRONIZANDO_PERIODOS.toString()] = 'Sincronizando periodos';
    mmap[Str.SINCRONIZANDO_HORARIOS.toString()] = 'Sincronizando horários';
    mmap[Str.SINCRONIZANDO_JUSTIFICATIVAS.toString()] =
        'Sincronizando justificativas';
    mmap[Str.SINCRONIZANDO_PENDENCIAS.toString()] = 'Sincronizando pendências';
    mmap[Str.BUSCANDO_PENDENCIAS.toString()] = 'Buscando pendências';
    mmap[Str.SUA_CONEXAO_NAO_E_ESTAVEL_TENTE_MAIS_TARDE_OU_COM_UMA_CONEXAO_MELHOR
            .toString()] =
        'Sua conexão com internet não é estável, tente novamente mais tarde, ou com uma conexão melhor.';
    mmap[Str.O_APLICATIVO_X1_ESTA_MANIPULANDO_O_SENSOR_DE_GPS_DESATIVE_O_MANIPULADOR_DE_GPS
            .toString()] =
        'Algum aplicativo está manipulando a sensor de GPS. Por favor, desative o manipulador de GPS.';
    mmap[Str.O_DISPOSITIVO_NAO_POSSUI_CAMERA_OU_A_CAMERA_NAO_ESTA_FUNCIONANDO_CORRETAMENTE
            .toString()] =
        'O dispositivo não possui câmera, ou a câmera não está funcionando corretamente';
    mmap[Str.A_CAMERA_NAO_FOI_INICIALIZADA.toString()] =
        'A camera não foi inicializada.';
    mmap[Str.O_WHATSAPP_NAO_PODE_SER_ABERTO.toString()] =
        'O Whatsapp não pode ser aberto.';

    mmap[Str.TEMA_ESCURO.toString()] = 'Habilitar tema escuro (DarkMode)';
    mmap[Str.ASSINATURA.toString()] = 'Assinatura';
    mmap[Str.ERRO_INTERNO_DO_SERVIDOR.toString()] = 'Erro interno do servidor.';
    mmap[Str.ERRO_MAX_REQUISICOES_SERVIDOR.toString()] =
        'Máximo de requisições por minuto ao servidor foi atingida.';
    mmap[Str.SINCRONIZANDO.toString()] = 'Sincronizando...';
    mmap[Str.PROCESSANDO_REGISTROS.toString()] = 'Processando registros...';
    mmap[Str.ENVIANDO_REGISTROS.toString()] = 'Enviando registros...';
    mmap[Str.VERIFICANDO_AUTORIZACAO.toString()] = 'Verificando autorização..';
    mmap[Str.POLITICA_PRIVACIDADE.toString()] = 'Politica de privacidade';
    mmap[Str.NAO_CONSEGUI_ABRIR_A_LOCALIZACAO_NO_MAPA.toString()] =
        'Não consegui abrir a localização no mapa.';
    mmap[Str.PERMISSAO_NEGADA.toString()] = 'Permissão negada';
    mmap[Str.PERMISSAO_RESTRITA.toString()] = 'Permissão restrita';
    mmap[Str.PERMISSAO_PERMANENTEMENTE_NEGADA.toString()] =
        'Permissão permanentemente negada';
    mmap[Str.PERMISSAO_PARA_A_CAMERA_NAO_ESTA_ACEITA.toString()] =
        'Permissão para a câmera não está aceita.';
    mmap[Str.PERMISSAO_PARA_A_LOCALIZACAO_NAO_ESTA_ACEITA.toString()] =
        'Permissão para a localização não está aceita.';
    mmap[Str.PERMISSAO_PARA_O_ARMAZENAMENTO_INTERNO_NAO_ESTA_ACEITA
            .toString()] =
        'Permissão para o armazenamento interno não está aceita.';
    mmap[Str.PERMISSAO_PARA_A_CAMERA_ESTA_PERMANENTEMENTE_NEGADA.toString()] =
        'Permissão para a câmera está permanentemente negada.';
    mmap[Str.PERMISSAO_PARA_A_LOCALIZACAO_ESTA_PERMANENTEMENTE_NEGADA
            .toString()] =
        'Permissão para a localização está permanentemente negada.';
    mmap[Str.PERMISSAO_PARA_O_ARMAZENAMENTO_INTERNO_ESTA_PERMANENTEMENTE_NEGADA
            .toString()] =
        'Permissão para o armazenamento interno está permanentemente negada.';
    mmap[Str.PARA_ACEITAR_A_PERMISSAO_ACESSE_AS_CONFIGURACOES.toString()] =
        'Para aceitar a permissão entre nas configurações do dispositivo.';
    mmap[Str.HABILITE_A_PERMISSAO_DIRETAMENTE_NAS_CONFIGURACOES_DO_SISTEMA
            .toString()] =
        'Habilite a permissão diretamente pelas configurações do sistema.';
    mmap[Str.ERRO_AO_EXECUTAR_REQUISICAO_X1.toString()] =
        'Erro ao efeturar a requisicação. %s.';
    mmap[Str.NENHUM_RETORNO_RECEBIDO_DO_SERVIDOR.toString()] =
        'Nenhum retorno recebido do servidor.';
    mmap[Str.A_TAG_DATA_NAO_FOI_RECEBIDA.toString()] =
        'A tag [data] não foi recebida.';
    mmap[Str.TENTE_NOVAMENTE_MAIS_TARDE.toString()] =
        'Tente novamente mais tarde.';
    mmap[Str.RETORNO_DO_SERVIDOR.toString()] = 'Retorno do servidor: ';
    mmap[Str.SERVIDOR_TEMPORARIAMENTE_INDISPONIVEL.toString()] =
        'Servidor temporariamente indisponível ';
    mmap[Str.LI_E_ACEITO_OS_TERMOS.toString()] = 'Li e aceito os termos';
    mmap[Str.ACEITE_OS_TERMOS.toString()] = 'Aceite os termos';
    mmap[Str.TERMOS_E_CONDICOES_PARA_UTILIZACAO_DO_APP.toString()] =
        'Termos e condições para utilização do app';
    mmap[Str.ACESSO_A_LOCALIZACAO.toString()] = 'Acesso a localização';
    mmap[Str.O_PONTO_RAPIDO_PRECISA_DE_ACESSO_A_LOCALIZACAO_PARA_PODER_REGISTRAR_O_PONTO
            .toString()] =
        'O Ponto Alfa precisa de acesso a localização para poder registrar o ponto!';
    mmap[Str.O_PONTO_RAPIDO_PRECISA_DE_ACESSO_A_CAMERA_PARA_PODER_REGISTRAR_O_PONTO
            .toString()] =
        'O Ponto Alfa precisa de acesso a câmera para poder registrar o ponto!';
    mmap[Str.O_PONTO_RAPIDO_PRECISA_DE_ACESSO_A_MIDEA_DO_DISPOSITIVO_PARA_PODER_REGISTRAR_O_PONTO
            .toString()] =
        'O Ponto Alfa precisa de acesso a mídia do dispositivo para poder registrar o ponto!';
    mmap[Str.CAMERA.toString()] = 'Câmera';
    mmap[Str.FALHA_AO_CADASTRAR_A_FACE.toString()] =
        'Não foi possível cadastrar a face. Certifique-se de que o rosto esteja totalmente visível, sem obstruções como óculos escuros, bonés ou máscaras.';
    mmap[Str.MIDEA_DO_DISPOSITIVO.toString()] = 'Mídia do Dispositivo';
    mmap[Str.OLA.toString()] = 'Olá';
    mmap[Str.ERRO.toString()] = 'Erro';
    mmap[Str.SUCESSO.toString()] = 'Sucesso!';
    mmap[Str.POR_FAVOR_INFORME_MATRICULA.toString()] =
        'Por favor, informe a matricula';
    mmap[Str.ATENCAO.toString()] = 'Atenção';
    mmap[Str.POR_FAVOR_SINCRONIZE_OS_DAOS_PARA_REALIZAR_O_CADASTRO_FACIAL
            .toString()] =
        'Por favor, sincronize os dados antes de realizar o registro_facial_temporario facial.';
    mmap[Str.FACE_CADASTRADA_COM_SUCESSO.toString()] =
        'Face cadastrada com sucesso, sincronize os registros para registrar o ponto';
    mmap[Str.ESTE_USUARIO_JA_TEM_UMA_FACE_CADASTRADA_E_PENDENTE_DE_SINCRONIZACAO
            .toString()] =
        'Este usuário já possui um rosto cadastrado e pendente de sincronização.';
    mmap[Str.ARQUIVO_DA_FOTO_NAO_ENCONTRADO_OU_CORROMPIDO.toString()] =
        'Foto capturada não foi encontrada ou está corrompida. Tente tirar a foto novamente. Se o problema persistir contate o suporte.';
    return {'pt_BR': mmap};
  }
}
