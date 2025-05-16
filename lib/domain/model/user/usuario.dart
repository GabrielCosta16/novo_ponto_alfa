
import 'package:novo_ponto_alfa/domain/model/custom.dart';
import 'package:novo_ponto_alfa/domain/model/pendencia/pendencias.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_tratada.dart';

class Usuario extends CustomModel {
  @override
  int? id;

  String? name;
  String? email;
  String? password;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? avatar;
  String? matricula;
  int? filialId;
  int? estadoPessoaId;
  int? horarioId;
  bool? ativo;
  bool? configAppLancamentoManual;
  bool? configAppJustificativa;

  List<Pendencias> pendencias = [];

  Usuario(
      {this.id,
        this.name,
        this.email,
        this.password,
        this.createdAt,
        this.updatedAt,
        this.avatar,
        this.matricula,
        this.filialId,
        this.estadoPessoaId,
        this.horarioId,
        this.configAppLancamentoManual,
        this.configAppJustificativa,
        this.ativo});

  @override
  factory Usuario.fromJson(Map<String, dynamic> json) {
    final id = json["id"];
    final name = json["name"];
    final email = json["email"];
    final password = json["password"];
    final avatar = json["avatar"];
    final matricula = json["matricula"];
    final filialId = json["filial_id"];
    final estadoPessoaId = json["estado_pessoa_id"];
    final horarioId = json["horario_id"];
    final ativo = CustomModel.tratarBoolean(json["ativo"]);

    final configAppLancamentoManual =
    json["config_app_lancamento_manual"] == null
        ? true
        : CustomModel.tratarBoolean(json["config_app_lancamento_manual"]);
    final configAppJustificativa = json["config_app_justificativa"] == null
        ? true
        : CustomModel.tratarBoolean(json["config_app_justificativa"]);

    var createdAt = json["created_at"];
    createdAt = (createdAt == null || createdAt == "")
        ? null
        : DateTime.parse(createdAt);

    var updatedAt = json["updated_at"];
    updatedAt = (updatedAt == null || updatedAt == "")
        ? null
        : DateTime.parse(updatedAt);

    return Usuario(
      id: id,
      name: name,
      email: email,
      password: password,
      createdAt: createdAt,
      updatedAt: updatedAt,
      avatar: avatar,
      matricula: matricula,
      filialId: filialId,
      estadoPessoaId: estadoPessoaId,
      horarioId: horarioId,
      ativo: ativo,
      configAppLancamentoManual: configAppLancamentoManual,
      configAppJustificativa: configAppJustificativa,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "password": password,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "avatar": avatar,
    "matricula": matricula,
    "filial_id": filialId,
    "estado_pessoa_id": estadoPessoaId,
    "horario_id": horarioId,
    "ativo": ativo,
    "config_app_lancamento_manual": configAppLancamentoManual,
    "config_app_justificativa": configAppJustificativa,
  };

  @override
  Usuario convertJson(Map<String, dynamic> json) {
    return Usuario.fromJson(json);
  }

  @override
  List<Usuario> convertJsonList(List<Map<String, dynamic>> json) {
    List<Usuario> retorno = [];
    for (Map<String, dynamic> item in json) {
      retorno.add(Usuario.fromJson(item));
    }

    return retorno;
  }

  String obterNomeExibicao() {
    if (name == null) {
      return 'Sem nome';
    }

    if (name!.length < 15) {
      return name!;
    }

    String nome = name!;

    while (nome.contains('  ')) {
      nome = nome.replaceAll('  ', ' ');
    }

    List<String> lista = nome.split(' ');

    return '${lista.first} ${lista.last}';
  }

  String obterMatriculaComNome() {
    return '${matricula ?? ''} - ${obterNomeExibicao()}';
  }

  void validarPermissaoLancamentoManual() {
    if (configAppLancamentoManual ?? true) {
      return;
    }

    throw ExceptionTratada(
        'Voco tem permisso para fazer lanamentos manuais.');
  }

  void validarPermissaoJustificativa() {
    if (configAppJustificativa ?? true) {
      return;
    }

    throw ExceptionTratada(
        'Voco tem permisso para cadastrar justificativas.');
  }
}
