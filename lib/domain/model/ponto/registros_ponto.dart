import 'dart:convert';
import 'dart:io';
import 'package:novo_ponto_alfa/domain/model/custom.dart';
import 'package:novo_ponto_alfa/domain/model/ponto/registros_ponto_dao.dart';
import 'package:novo_ponto_alfa/infra/core/configuracao/ambiente.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_tratada.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:novo_ponto_alfa/infra/core/requisicoes/requisitar_post.dart';
import 'package:novo_ponto_alfa/infra/core/utils/util.dart';
import 'package:path_provider/path_provider.dart';
class RegistrosPonto extends CustomModel {
  @override
  int? id;

  int? userId;
  int? cercoId;
  int? estadoPessoaId;
  DateTime? dataHoraRegistro;
  DateTime? dataHoraRegistroAparelho;
  bool? dataHoraObtidaPorGPS;
  bool? alteracaoManual;
  String? unique_id;
  String? latitude;
  String? longitude;
  String? foto;
  String? assinatura;
  String? valorAuxiliar;
  String? justificativa;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? aparelhoId;
  bool? desconsiderado;

  RegistrosPonto({
    this.id,
    this.unique_id,
    this.userId,
    this.estadoPessoaId,
    this.cercoId,
    this.dataHoraRegistro,
    this.dataHoraRegistroAparelho,
    this.dataHoraObtidaPorGPS,
    this.alteracaoManual,
    this.latitude,
    this.longitude,
    this.foto,
    this.assinatura,
    this.valorAuxiliar,
    this.justificativa,
    this.createdAt,
    this.updatedAt,
    this.aparelhoId,
    this.desconsiderado,
  });

  factory RegistrosPonto.fromJson(Map<String, dynamic> json) => RegistrosPonto(
        id: json["id"],
        unique_id: json["unique_id"],
        userId: json["user_id"],
        estadoPessoaId: json['estado_pessoa_id'],
        cercoId: json["cerco_id"],
        dataHoraRegistro: DateTime.parse(json["data_hora_registro"]),
        dataHoraRegistroAparelho: json["data_hora_registro_aparelho"] == null
            ? null
            : DateTime.parse(json["data_hora_registro_aparelho"]),
        dataHoraObtidaPorGPS:
            CustomModel.tratarBoolean(json["data_hora_obtida_por_gps"]),
        alteracaoManual: CustomModel.tratarBoolean(json["alteracao_manual"]),
        latitude: json["latitude"],
        longitude: json["longitude"],
        foto: json["foto"],
        assinatura: json["assinatura"],
        valorAuxiliar: json["valor_auxiliar"],
        justificativa: json["justificativa"],
        aparelhoId: json["aparelho_id"],
        desconsiderado: CustomModel.tratarBoolean(json["desconsiderado"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "unique_id": unique_id,
        "user_id": userId,
        "estado_pessoa_id": estadoPessoaId,
        "cerco_id": cercoId,
        "data_hora_registro": dataHoraRegistro?.toIso8601String(),
        "data_hora_registro_aparelho":
            dataHoraRegistroAparelho?.toIso8601String(),
        "data_hora_obtida_por_gps": dataHoraObtidaPorGPS,
        "alteracao_manual": alteracaoManual,
        "latitude": latitude,
        "longitude": longitude,
        "foto": foto,
        "assinatura": assinatura,
        "valor_auxiliar": valorAuxiliar,
        "justificativa": justificativa,
        "aparelho_id": aparelhoId,
        "desconsiderado": desconsiderado,
      };

  @override
  RegistrosPonto convertJson(Map<String, dynamic> json) {
    return RegistrosPonto.fromJson(json);
  }

  @override
  List<RegistrosPonto> convertJsonList(List<Map<String, dynamic>> json) {
    List<RegistrosPonto> retorno = [];
    for (Map<String, dynamic> item in json) {
      retorno.add(RegistrosPonto.fromJson(item));
    }

    return retorno;
  }

  static Future<String> obterPathImagens() async {
    final String path = (await getApplicationDocumentsDirectory()).path;

    String finalPath = (await Directory('$path/imagens/registros_ponto/')
            .create(recursive: true))
        .path;

    return finalPath;
  }

  static Future<String> obterPathTemp() async {
    final String path = (await getApplicationDocumentsDirectory()).path;

    String finalPath =
        (await Directory('$path/temp/').create(recursive: true)).path;

    return finalPath;
  }

  Future enviar() async {
    var imagensPath = await RegistrosPonto.obterPathImagens();
    var jsonRegistro = toJson();

    File? imageFile;
    File? assinaturaFile;

    if (foto != null && foto!.isNotEmpty) {
      imageFile = File('$imagensPath$foto');
      bool existe = await imageFile.exists();

      if (existe) {
        final base64Image = base64Encode(imageFile.readAsBytesSync());
        final md5Check = Util.gerarMd5(base64Image);

        jsonRegistro.addAll({
          'fotoBase64': base64Image,
          'fotoMd5Check': md5Check,
        });
      } else {
        try {
          throw ExceptionTratada(Traducao.obter(
              Str.IMAGEM_DE_FACE_DE_REGISTRO_DE_PONTO_NAO_PODE_SER_ENCONTRADA_UNIQUE_ID_X1,
              params: [unique_id.toString()]));
        } catch (error) {
          //Sentry().report(error, trace);
        }
      }
    }

    if (assinatura != null && assinatura!.isNotEmpty) {
      assinaturaFile = File('$imagensPath$assinatura');
      bool existe = await assinaturaFile.exists();

      if (existe) {
        final base64Assinatura = base64Encode(assinaturaFile.readAsBytesSync());
        final md5CheckAssinatura = Util.gerarMd5(base64Assinatura);

        jsonRegistro.addAll({
          'assinaturaBase64': base64Assinatura,
          'assinaturaMd5Check': md5CheckAssinatura,
        });
      } else {
        try {
          throw ExceptionTratada(Traducao.obter(
              Str.IMAGEM_DE_ASSINATURA_DE_REGISTRO_DE_PONTO_NAO_ENCONTRADA_UNIQUE_ID_X1,
              params: [unique_id.toString()]));
        } catch (error) {
          //Sentry().report(error, trace);
        }
      }
    }

    var retorno = await RequisicaoPost(rTimeout: 10)
        .executar(PathRequisicao.URL_REGISTRAR_PONTO, jsonRegistro);

    if (!retorno.containsKey('data')) {
      throw ExceptionTratada(Traducao.obter(
          Str.O_REGISTRO_X1_NAO_PODE_SER_ENVIADO,
          params: [unique_id.toString()]));
    }

    id = retorno['data']['id'];

    RegistrosPontoDAO registrosPontoDAO = await RegistrosPontoDAO().init();
    await registrosPontoDAO.updateByUniqueId(this, unique_id);

    // Exclui o arquivo de assinatura do disco, se ele existir
    if (assinaturaFile != null) {
      if (assinaturaFile.existsSync()) {
        assinaturaFile.deleteSync();
      }
    }

    // Exclui o arquivo de identificação/face do disco, se ele existir
    if (imageFile != null) {
      if (imageFile.existsSync()) {
        imageFile.deleteSync();
      }
    }
  }
}
