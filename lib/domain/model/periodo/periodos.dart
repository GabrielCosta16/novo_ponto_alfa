

import 'package:novo_ponto_alfa/domain/model/custom.dart';
import 'package:novo_ponto_alfa/domain/model/filial/filial.dart';
import 'package:novo_ponto_alfa/domain/model/filial/filial_dao.dart';

class Periodos extends CustomModel {
  @override
  int? id;

  int? filialId;
  String? nome;
  DateTime? dataInicial;
  DateTime? dataFinal;
  bool? ativo;

  Filial? filial;

  Future<Filial> getFilial() async {
    if (filial != null) {
      return filial!;
    }

    filial = await FilialDAO().getById(Filial(), filialId);
    return filial!;
  }

  Periodos({
    this.id,
    this.filialId,
    this.nome,
    this.dataInicial,
    this.dataFinal,
    this.ativo,
  });

  factory Periodos.fromJson(Map<String, dynamic> json) => Periodos(
        id: json["id"],
        filialId: json["filial_id"],
        nome: json["nome"],
        dataInicial: DateTime.parse(json["data_inicial"]),
        dataFinal: DateTime.parse(json["data_final"]),
        ativo: CustomModel.tratarBoolean(json["ativo"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "filial_id": filialId,
        "nome": nome,
        "data_inicial": dataInicial?.toIso8601String(),
        "data_final": dataFinal?.toIso8601String(),
        "ativo": ativo,
      };

  @override
  convertJson(Map<String, dynamic> json) {
    return Periodos.fromJson(json);
  }

  @override
  List<Periodos> convertJsonList(List<Map<String, dynamic>> json) {
    List<Periodos> retorno = [];
    for (Map<String, dynamic> item in json) {
      retorno.add(Periodos.fromJson(item));
    }

    return retorno;
  }
}
