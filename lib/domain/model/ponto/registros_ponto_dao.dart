import 'package:intl/intl.dart';
import 'package:novo_ponto_alfa/domain/model/custom_dao.dart';
import 'package:novo_ponto_alfa/domain/model/ponto/registros_ponto.dart';
import 'package:novo_ponto_alfa/domain/model/user/usuario.dart';
import 'package:novo_ponto_alfa/infra/core/services/database.dart';

class RegistrosPontoDAO extends CustomDAO<RegistrosPonto> {
  Future<RegistrosPontoDAO> init() async {
    database = await DbHelper.getInstance();
    return this;
  }

  @override
  String table() {
    return 'registros_ponto';
  }

  Future<List<RegistrosPonto>> obterTodosDoDiaDoUsuario(Usuario user, bool desc,
      {DateTime? dataHoraRegistro}) async {
    DateTime dataHoje = DateTime.now();
    if (dataHoraRegistro != null) dataHoje = dataHoraRegistro;

    var formatter = DateFormat('yyyy-MM-ddT00:00');
    String formatted = formatter.format(dataHoje);

    return await allBy(
        RegistrosPonto(),
        " where (desconsiderado = 0 or desconsiderado is null) and data_hora_registro >= '$formatted' and user_id = '${user.id}' order by data_hora_registro " +
            (desc ? 'desc' : ''));
  }

  Future<RegistrosPonto?> obterUltimoDoDiaDoUsuario(Usuario user) async {
    var registros = (await obterTodosDoDiaDoUsuario(user, false));
    if (registros.isEmpty) {
      return null;
    }
    return registros.last;
  }

  Future deletarTodosEnviadosExetoDoDia() async {
    DateTime dataHoje = DateTime.now();
    var formatter = DateFormat('yyyy-MM-ddT00:00');
    String formatted = formatter.format(dataHoje);

    await deleteWithWhere(
        "data_hora_registro < '$formatted' and (id <> '' and id is not null)");
  }

  Future<List<RegistrosPonto>> obterRegistrosAindaNaoSincronizados() async {
    return await allBy(RegistrosPonto(), " where id = '' or id is null");
  }
}
