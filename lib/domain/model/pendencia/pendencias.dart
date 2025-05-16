
import 'package:novo_ponto_alfa/domain/model/custom.dart';

class Pendencias extends CustomModel {
  @override
  int? id;

  int? userId;
  DateTime? data;
  String? titulo;
  String? mensagem;

  Pendencias({this.id, this.userId, this.data, this.titulo, this.mensagem});

  factory Pendencias.fromJson(Map<String, dynamic> json) => Pendencias(
    id: json["id"],
    userId: json["user_id"],
    titulo: json["titulo"],
    mensagem: json["mensagem"],
    data: json["data"] == null ? null : DateTime.parse(json["data"]),
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "titulo": titulo,
    "mensagem": mensagem,
    "data": data?.toIso8601String(),
  };

  @override
  CustomModel convertJson(Map<String, dynamic> json) {
    return Pendencias.fromJson(json);
  }

  @override
  List<Pendencias> convertJsonList(List<Map<String, dynamic>> json) {
    List<Pendencias> retorno = [];
    for (Map<String, dynamic> item in json) {
      retorno.add(Pendencias.fromJson(item));
    }

    return retorno;
  }
}
