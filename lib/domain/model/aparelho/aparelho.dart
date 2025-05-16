import 'package:novo_ponto_alfa/domain/model/custom.dart';
import 'package:novo_ponto_alfa/domain/model/filial/filial.dart';
import 'package:novo_ponto_alfa/domain/model/filial/filial_dao.dart';

class Aparelho extends CustomModel {
  @override
  int? id;

  int? filialId;
  String? uniqueId;
  dynamic createdAt;
  dynamic updatedAt;
  bool? autorizado;

  Filial? filial;

  Future<Filial> getFilial() async {
    if (filial != null) return filial!;

    filial = await FilialDAO().getById(Filial(), filialId);
    return filial!;
  }

  Aparelho({
    this.id,
    this.filialId,
    this.uniqueId,
    this.createdAt,
    this.updatedAt,
    this.autorizado,
  });

  factory Aparelho.fromJson(Map<String, dynamic> json) => Aparelho(
        id: json["id"],
        filialId: json["filial_id"],
        uniqueId: json["unique_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        autorizado: CustomModel.tratarBoolean(json["autorizado"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "filial_id": filialId,
        "unique_id": uniqueId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "autorizado": autorizado,
      };

  @override
  convertJson(Map<String, dynamic> json) {
    return Aparelho.fromJson(json);
  }

  @override
  List<Aparelho> convertJsonList(List<Map<String, dynamic>> json) {
    List<Aparelho> retorno = [];
    for (Map<String, dynamic> item in json) {
      retorno.add(Aparelho.fromJson(item));
    }

    return retorno;
  }
}
