
import 'package:novo_ponto_alfa/domain/model/custom.dart';

class JustificativasFalta extends CustomModel {
  @override
  int? id;

  int? empresaId;
  int? obrigatoriedadeFotoId;
  String? chave;
  String? valor;

  JustificativasFalta(
      {this.id,
      this.empresaId,
      this.chave,
      this.valor,
      this.obrigatoriedadeFotoId});

  factory JustificativasFalta.fromJson(Map<String, dynamic> json) =>
      JustificativasFalta(
          id: json["id"],
          empresaId: json["empresa_id"],
          chave: json["chave"],
          valor: json["valor"],
          obrigatoriedadeFotoId: json["obrigatoriedade_foto_id"]);

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "empresa_id": empresaId,
        "chave": chave,
        "valor": valor,
        "obrigatoriedade_foto_id": obrigatoriedadeFotoId
      };

  @override
  CustomModel convertJson(Map<String, dynamic> json) {
    return JustificativasFalta.fromJson(json);
  }

  @override
  List<JustificativasFalta> convertJsonList(List<Map<String, dynamic>> json) {
    List<JustificativasFalta> retorno = [];
    for (Map<String, dynamic> item in json) {
      retorno.add(JustificativasFalta.fromJson(item));
    }

    return retorno;
  }
}
