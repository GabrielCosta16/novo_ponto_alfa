import 'package:novo_ponto_alfa/domain/model/custom.dart';

class RegistroFacialTemporario extends CustomModel {
  String? nome;
  String? external_id;
  String? company_external_id;
  String? pathImagemFacial;

  RegistroFacialTemporario(
      {this.nome,
      this.external_id,
      this.company_external_id,
      this.pathImagemFacial});

  factory RegistroFacialTemporario.fromJson(Map<String, dynamic> json) =>
      RegistroFacialTemporario(
          nome: json["nome"],
          external_id: json["external_id"],
          company_external_id: json["company_external_id"],
          pathImagemFacial: json["pathImagemFacial"]);

  @override
  convertJson(Map<String, dynamic> json) {
    RegistroFacialTemporario.fromJson(json);
  }

  @override
  convertJsonList(List<Map<String, dynamic>> json) {
    List<RegistroFacialTemporario> retorno = [];
    for (Map<String, dynamic> item in json) {
      retorno.add(RegistroFacialTemporario.fromJson(item));
    }

    return retorno;
  }

  @override
  Map<String, dynamic> toJson() => {
        "nome": nome,
        "external_id": external_id,
        "company_external_id": company_external_id,
        "pathImagemFacial": pathImagemFacial,
      };
}
