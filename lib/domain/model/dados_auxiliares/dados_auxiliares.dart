
import 'package:novo_ponto_alfa/domain/model/custom.dart';

class DadosAuxiliares extends CustomModel {
  @override
  int? id;

  int? empresaId;
  String? chave;
  String? valor;

  DadosAuxiliares({this.id, this.empresaId, this.chave, this.valor});

  factory DadosAuxiliares.fromJson(Map<String, dynamic> json) =>
      DadosAuxiliares(
        id: json["id"],
        empresaId: json["empresa_id"],
        chave: json["chave"],
        valor: json["valor"],
      );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "empresa_id": empresaId,
    "chave": chave,
    "valor": valor,
  };

  @override
  CustomModel convertJson(Map<String, dynamic> json) {
    return DadosAuxiliares.fromJson(json);
  }

  @override
  List<DadosAuxiliares> convertJsonList(List<Map<String, dynamic>> json) {
    List<DadosAuxiliares> retorno = [];
    for (Map<String, dynamic> item in json) {
      retorno.add(DadosAuxiliares.fromJson(item));
    }

    return retorno;
  }
}
