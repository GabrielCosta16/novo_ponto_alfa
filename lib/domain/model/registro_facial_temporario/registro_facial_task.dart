import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:novo_ponto_alfa/domain/model/reconhecimento_facial/autenticacao_gryfo.dart';
import 'package:novo_ponto_alfa/domain/model/reconhecimento_facial/global_gryfo_lib.dart';
import 'package:novo_ponto_alfa/domain/model/reconhecimento_facial/pesos_gryfo.dart';
import 'package:novo_ponto_alfa/domain/model/reconhecimento_facial/sincronizacao_gryfo.dart';
import 'package:novo_ponto_alfa/domain/model/registro_facial_temporario/mdl_registro_facial_temporario.dart';
import 'package:novo_ponto_alfa/domain/model/registro_facial_temporario/registro_facial_temporario_dao.dart';
import 'package:novo_ponto_alfa/domain/model/registro_facial_temporario/uc_enviar_registros_faciais_gryfo.dart';
import 'package:novo_ponto_alfa/domain/model/user/usuario.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:novo_ponto_alfa/infra/core/repositories/usuario/usuario_dao.dart';
import 'package:novo_ponto_alfa/infra/core/requisicoes/checar_conexao_internet.dart';
import 'package:novo_ponto_alfa/ui/widgets/dialog/my_alert_dialog.dart';
import 'package:novo_ponto_alfa/ui/widgets/dialog/my_loading_dialog.dart';
import 'package:path_provider/path_provider.dart';

class RegistroFacialTask {
  String matriculaUsuario;

  RegistroFacialTask(this.matriculaUsuario);

  final AutenticacaoGryfo _autenticacaoFacial = AutenticacaoGryfo();
  final PesosGryfo _pesosFacial = PesosGryfo();
  final SincronizacaoGryfo _sincronizarGryfo = SincronizacaoGryfo();

  Future cadastrarFaceGryfo(BuildContext context) async {
    try {
      _validarAutenticacaoGryfo();

      _validarPesosGryfo();

      _validarSincronizarGryfo();

      await _iniciarCadastroFacial(context);
    } catch (e) {
      rethrow;
    }
  }

  void _validarCadastroFacial(Map<dynamic, dynamic> value) {
    if (value["code"] == 113) {
      throw Exception(
        Traducao.obter(Str
            .ESTE_USUARIO_JA_TEM_UMA_FACE_CADASTRADA_E_PENDENTE_DE_SINCRONIZACAO),
      );
    }

    if (value["code"] == 114) {
      throw Exception("A imagem esta com qualidade baixa, tente novamente");
    }

    if (value["code"] == 125) {
      throw Exception(
          "Ja existe um usuario com este rosto cadastrado:\n Matricula: ${value['external_id']}");
    }

    if (value["code"] == 109) {
      throw Exception("IA não encontrada, por favor sincronize novamente");
    }

    if (value["success"] == false) {
      throw Exception(
        Traducao.obter(Str.FALHA_AO_CADASTRAR_A_FACE),
      );
    }
  }

  Future<Map<dynamic, dynamic>> _iniciarCadastroFacial(
      BuildContext context) async {
    try {
      final ImagePicker imagePicker = ImagePicker();

      final XFile? foto =
          await imagePicker.pickImage(source: ImageSource.camera);

      if (foto == null) {
        throw Exception('Nenhuma imagem foi capturada');
      }

      MyLoadingDialog.exibir(context, MyDialogType.LOADING);

      MyLoadingDialog.atualizarMensagem("Identificiando face..");

      final bytes = await foto.readAsBytes();

      final String base64Image = base64Encode(bytes);

      final Map<String, dynamic> data = {
        'base64': base64Image,
      };

      MyLoadingDialog.atualizarMensagem("Cadastrando face..");

      UsuarioDAO usuarioDAO = await UsuarioDAO().init();

      String idUsuario = await usuarioDAO.obterIdUsuario(matriculaUsuario);

      var retorno = await MyGlobalInstanceGryfo.instance.gryfo.tempRegisterData(
        idUsuario,
        data['base64'],
        true,
      );

      MyLoadingDialog.atualizarMensagem("Validando face..");

      _validarCadastroFacial(retorno);

      String pathImagemFacial = await _obterPathImagemFacial(idUsuario, foto);

      Usuario? usuario = await usuarioDAO.getBy(
          Usuario(), " where matricula = '$matriculaUsuario'");

      RegistroFacialTemporario registroFacialTemporario =
          RegistroFacialTemporario(
              company_external_id: usuario!.filialId.toString(),
              external_id: usuario.id.toString(),
              nome: usuario.name,
              pathImagemFacial: pathImagemFacial);

      RegistroFacialTemporarioDAO registroFacialTemporarioDAO =
          RegistroFacialTemporarioDAO();

      await registroFacialTemporarioDAO.init();

      var idRegistroTemporario =
          await registroFacialTemporarioDAO.create(registroFacialTemporario);

      print(idRegistroTemporario);

      bool temInternet = await ConexaoInternet.temConexao();

      if (temInternet) {
        List<RegistroFacialTemporario> listaRegistrosImportados =
            await UcEnviarRegistrosFaciaisGryfo().executar(context);
        if (listaRegistrosImportados.isNotEmpty) {
          MyLoadingDialog.atualizarMensagem("Sucesso!");

          await Future.delayed(const Duration(seconds: 1));

          MyLoadingDialog.ocultar();

          String nomesFormatados =
              listaRegistrosImportados.map((r) => '- ${r.nome}').join('\n');
          MyAlertDialog.exibirMensagem(
              "Os seguintes usuários foram importados com sucesso:\n$nomesFormatados",
              titulo: "Sucesso!", executarApos: () {
            Navigator.of(context).pop();
          });
        }
      }

      if (temInternet == false) {
        MyLoadingDialog.ocultar();
        MyAlertDialog.exibirOk("Falha",
            """Você não tem conexão com a internet, por favor conecte-se e sincronize os registros.
            Fique tranquilo o registro facial será enviado quando realizar uma nova sincronização.
            """, () {
          Navigator.of(context).pop();
        });
      }

      return retorno;
    } catch (e) {
      MyLoadingDialog.ocultar();
      MyAlertDialog.exibirOk("ERRO", e.toString(), () {
        Navigator.of(context).pop();
      });
      rethrow;
    }
  }

  Future<String> _obterPathImagemFacial(String idUsuario, XFile xfile) async {
    final File imagemOriginal = File(xfile.path);

    final dir = await getApplicationDocumentsDirectory();
    final String pastaUsuario = '${dir.path}/$idUsuario';

    final Directory dirUsuario = Directory(pastaUsuario);
    if (!(await dirUsuario.exists())) {
      await dirUsuario.create(recursive: true);
    }

    final String caminhoNovo = '$pastaUsuario/face_$idUsuario.jpg';

    final novaImagem = await imagemOriginal.copy(caminhoNovo);

    print('Imagem salva em: ${novaImagem.path}');

    return novaImagem.path;
  }

  void _validarAutenticacaoGryfo() async {
    if (_autenticacaoFacial.isPrecisaAutenticar()) {
      throw Exception("Sincronizacao necessaria");
    }
  }

  void _validarPesosGryfo() async {
    if (_pesosFacial.isPrecisaBaixarPesos()) {
      throw Exception("Sincronizacao necessaria");
    }
  }

  void _validarSincronizarGryfo() async {
    if (_sincronizarGryfo.isPrecisaSincronizarGryfo()) {
      throw Exception("Sincronizacao necessaria");
    }
  }
}
