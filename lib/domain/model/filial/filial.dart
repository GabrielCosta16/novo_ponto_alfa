
import 'package:novo_ponto_alfa/domain/model/custom.dart';

class Filial extends CustomModel {
  @override
  int? id;

  int? empresaId;
  String? nome;
  String? cnpj;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? horarioId;

  Filial({
    this.id,
    this.empresaId,
    this.nome,
    this.cnpj,
    this.createdAt,
    this.updatedAt,
    this.horarioId,
  });

  factory Filial.fromJson(Map<String, dynamic> json) => Filial(
    id: json["id"],
    empresaId: json["empresa_id"],
    nome: json["nome"],
    cnpj: json["cnpj"],
    horarioId: json["horario_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "empresa_id": empresaId,
    "nome": nome,
    "cnpj": cnpj,
    "horario_id": horarioId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

  @override
  CustomModel convertJson(Map<String, dynamic> json) {
    return Filial.fromJson(json);
  }

  @override
  List<Filial> convertJsonList(List<Map<String, dynamic>> json) {
    List<Filial> retorno = [];
    for (Map<String, dynamic> item in json) {
      retorno.add(Filial.fromJson(item));
    }

    return retorno;
  }
}
