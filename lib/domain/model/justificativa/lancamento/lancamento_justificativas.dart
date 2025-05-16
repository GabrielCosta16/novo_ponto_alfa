import 'dart:convert';
import 'dart:io';
import 'package:novo_ponto_alfa/domain/model/custom.dart';
import 'package:novo_ponto_alfa/infra/core/configuracao/ambiente.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_tratada.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:novo_ponto_alfa/infra/core/requisicoes/requisitar_post.dart';
import 'package:novo_ponto_alfa/infra/core/utils/util.dart';
import 'package:path_provider/path_provider.dart';

import 'lancamento_justificativas_dao.dart' show LancamentoJustificativasDAO;

class LancamentoJustificativas extends CustomModel {
  @override
  int? id;
  int? aparelhoId;
  int? userId;
  int? justificativaFaltaId;
  DateTime? data;
  String? horaInicio;
  String? horaFim;
  String? foto;
  String? uniqueId;
  String? valorAuxiliar;
  bool? descontarBancoHoras;

  LancamentoJustificativas(
      {this.id,
      this.userId,
      this.aparelhoId,
      this.justificativaFaltaId,
      this.data,
      this.horaInicio,
      this.horaFim,
      this.foto,
      this.uniqueId,
      this.valorAuxiliar,
      this.descontarBancoHoras});

  factory LancamentoJustificativas.fromJson(Map<String, dynamic> json) =>
      LancamentoJustificativas(
          id: json["id"],
          userId: json["user_id"],
          aparelhoId: json["aparelho_id"],
          justificativaFaltaId: json["justificativa_falta_id"],
          data: DateTime.parse(json["data"]),
          horaInicio: json["hora_inicio"],
          horaFim: json["hora_fim"],
          foto: json['foto'],
          valorAuxiliar: json['valor_auxiliar'],
          uniqueId: json['unique_id'],
          descontarBancoHoras:
              CustomModel.tratarBoolean(json["descontar_banco_horas"]));

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "aparelho_id": aparelhoId,
        "justificativa_falta_id": justificativaFaltaId,
        "data": data?.toIso8601String(),
        "hora_inicio": horaInicio,
        "hora_fim": horaFim,
        "foto": foto,
        "unique_id": uniqueId,
        "valor_auxiliar": valorAuxiliar,
        "descontar_banco_horas": descontarBancoHoras,
      };

  @override
  CustomModel convertJson(Map<String, dynamic> json) {
    return LancamentoJustificativas.fromJson(json);
  }

  @override
  List<LancamentoJustificativas> convertJsonList(
      List<Map<String, dynamic>> json) {
    List<LancamentoJustificativas> retorno = [];
    for (Map<String, dynamic> item in json) {
      retorno.add(LancamentoJustificativas.fromJson(item));
    }

    return retorno;
  }

  static Future<String> obterPathFoto() async {
    final String path = (await getApplicationDocumentsDirectory()).path;

    String finalPath = (await Directory('$path/imagens/justificativas/')
            .create(recursive: true))
        .path;

    return finalPath;
  }

  Future enviar() async {
    var finalPath = await LancamentoJustificativas.obterPathFoto();

    var jsonRegistro = toJson();

    File? imageFile;

    if (foto != null && foto != "") {
      imageFile = File('$finalPath$foto');

      if (!(await imageFile.exists())) {
        throw ExceptionTratada(Traducao.obter(
            Str.O_ARQUIVO_CAPTURA_DE_FACE_DO_REGISTRO_X1_NAO_FOI_ENCONTRADO,
            params: [uniqueId.toString()]));
      }

      String base64Image = base64Encode(imageFile.readAsBytesSync());
      String md5Check = Util.gerarMd5(base64Image);

      jsonRegistro.addAll({
        'fotoBase64': base64Image,
        'fotoMd5Check': md5Check,
      });
    }

    var retorno = await RequisicaoPost(rTimeout: 10)
        .executar(PathRequisicao.URL_LANCAMENTO_JUSTIFICATIVA, jsonRegistro);

    if (!retorno.containsKey('data')) {
      throw ExceptionTratada(Traducao.obter(
          Str.O_REGISTRO_X1_NAO_PODE_SER_ENVIADO,
          params: [uniqueId.toString()]));
    }

    id = retorno['id'];

    LancamentoJustificativasDAO lancamentoJustificativasDAO =
        await LancamentoJustificativasDAO().init();
    await lancamentoJustificativasDAO.updateByUniqueId(this, uniqueId);

    if (imageFile != null) {
      if (await imageFile.exists()) imageFile.delete();
    }
  }
}
