
import 'package:novo_ponto_alfa/domain/model/custom.dart';
import 'package:novo_ponto_alfa/domain/model/empresa/empresa.dart';
import 'package:novo_ponto_alfa/domain/model/horarios/horarios_dao.dart';
import 'package:novo_ponto_alfa/domain/model/user/usuario.dart';
import 'package:novo_ponto_alfa/infra/core/preferences/preferencias.dart';

import '../filial/filial.dart';

class Horario extends CustomModel {
  @override
  int? id;

  int? empresaId;
  bool? controleBancoHoras;

  Horario({this.id, this.empresaId, this.controleBancoHoras});

  factory Horario.fromJson(Map<String, dynamic> json) => Horario(
      id: json["id"],
      empresaId: json["empresa_id"],
      controleBancoHoras:
          CustomModel.tratarBoolean(json["controle_banco_horas"]));

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "empresa_id": empresaId,
        "controle_banco_horas": controleBancoHoras,
      };

  @override
  CustomModel convertJson(Map<String, dynamic> json) {
    return Horario.fromJson(json);
  }

  @override
  List<Horario> convertJsonList(List<Map<String, dynamic>> json) {
    List<Horario> retorno = [];
    for (Map<String, dynamic> item in json) {
      retorno.add(Horario.fromJson(item));
    }

    return retorno;
  }

  static Future<Horario?> obterHorario(Usuario user) async {
    HorarioDAO horariosDAO = await HorarioDAO().init();

    if (user.horarioId != null) {
      return horariosDAO.getById(Horario(), user.horarioId);
    }

    Filial? filial = await Preferences.filialLogada();
    if (filial!.horarioId != null) {
      return horariosDAO.getById(Horario(), filial.horarioId);
    }

    Empresa? empresa = await Preferences.empresaLogada();
    if (empresa!.horarioId != null) {
      return horariosDAO.getById(Horario(), empresa.horarioId);
    }

    return null;
  }
}
