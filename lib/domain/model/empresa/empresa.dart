
import 'package:novo_ponto_alfa/domain/model/custom.dart';

class Empresa extends CustomModel {
  static int NAO_PEDIR = 1;
  static int PEDIR = 2;
  static int PEDIR_E_OBRIGAR = 3;

  @override
  int? id;
  String? nome;
  int? tolerancia;
  bool? exigirCapturaGps;
  bool? obterDataHoraPorGps;
  bool? exigirCapturaEmCerco;
  int? capturaFoto;
  int? capturaAssinatura;
  int? campoAdicional;
  String? tituloCampoAdicional;
  String? logo;
  int? horarioId;

  Empresa({
    this.id,
    this.nome,
    this.tolerancia,
    this.exigirCapturaGps,
    this.obterDataHoraPorGps,
    this.campoAdicional,
    this.capturaFoto,
    this.capturaAssinatura,
    this.exigirCapturaEmCerco,
    this.tituloCampoAdicional,
    this.horarioId,
    this.logo,
  });

  bool pedirCapturaFoto() {
    return capturaFoto == Empresa.PEDIR ||
        capturaFoto == Empresa.PEDIR_E_OBRIGAR;
  }

  bool obrigarCapturaFoto() {
    return capturaFoto == Empresa.PEDIR_E_OBRIGAR;
  }

  bool pedirCapturaAssinatura() {
    return capturaAssinatura == Empresa.PEDIR ||
        capturaAssinatura == Empresa.PEDIR_E_OBRIGAR;
  }

  bool obrigarCapturaAssinatura() {
    return capturaAssinatura == Empresa.PEDIR_E_OBRIGAR;
  }

  bool pedirCampoAdicional() {
    return campoAdicional == Empresa.PEDIR ||
        campoAdicional == Empresa.PEDIR_E_OBRIGAR;
  }

  bool obrigarCampoAdicional() {
    return campoAdicional == Empresa.PEDIR_E_OBRIGAR;
  }

  String getTituloCampoAcicional() {
    return tituloCampoAdicional ?? "Campo adicional";
  }

  factory Empresa.fromJson(Map<String, dynamic> json) => Empresa(
    id: json["id"],
    nome: json["nome"],
    tolerancia: json["tolerancia"],
    exigirCapturaGps: CustomModel.tratarBoolean(json["exigir_captura_gps"]),
    obterDataHoraPorGps: CustomModel.tratarBoolean(
      json["obter_data_hora_por_gps"],
    ),
    capturaFoto: json["captura_foto"],
    capturaAssinatura: json["captura_assinatura"],
    exigirCapturaEmCerco: CustomModel.tratarBoolean(
      json["exigir_captura_em_cerco"],
    ),
    campoAdicional: json["campo_adicional"],
    tituloCampoAdicional: json["titulo_campo_adicional"],
    horarioId: json["horario_id"],
    logo: json["logo"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "nome": nome,
    "tolerancia": tolerancia,
    "exigir_captura_gps": exigirCapturaGps,
    "obter_data_hora_por_gps": obterDataHoraPorGps,
    "captura_foto": capturaFoto,
    "captura_assinatura": capturaAssinatura,
    "exigir_captura_em_cerco": exigirCapturaEmCerco,
    "campo_adicional": campoAdicional,
    "titulo_campo_adicional": tituloCampoAdicional,
    "horario_id": horarioId,
    "logo": logo,
  };

  @override
  CustomModel convertJson(Map<String, dynamic> json) {
    return Empresa.fromJson(json);
  }

  @override
  List<Empresa> convertJsonList(List<Map<String, dynamic>> json) {
    List<Empresa> retorno = [];
    for (Map<String, dynamic> item in json) {
      retorno.add(Empresa.fromJson(item));
    }

    return retorno;
  }
}
