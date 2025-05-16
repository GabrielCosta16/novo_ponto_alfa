import 'package:intl/intl.dart';
import 'package:novo_ponto_alfa/domain/model/custom_dao.dart';
import 'package:novo_ponto_alfa/domain/model/justificativa/lancamento/lancamento_justificativas.dart';
import 'package:novo_ponto_alfa/domain/model/user/usuario.dart';
import 'package:novo_ponto_alfa/infra/core/services/database.dart';
class LancamentoJustificativasDAO extends CustomDAO<LancamentoJustificativas> {
  Future<LancamentoJustificativasDAO> init() async {
    database = await DbHelper.getInstance();
    return this;
  }

  @override
  String table() {
    return 'lancamento_justificativas';
  }

  Future<List<LancamentoJustificativas>> obterTodosDoDiaDoUsuario(
      Usuario user, bool desc) async {
    DateTime dataHoje = DateTime.now();
    var formatter = DateFormat('yyyy-MM-ddT00:00');
    String formatted = formatter.format(dataHoje);

    return await allBy(
        LancamentoJustificativas(),
        " where data >= '$formatted' and user_id = '${user.id}' order by data " +
            (desc ? 'desc' : ''));
  }

  Future<LancamentoJustificativas?> obterUltimoDoDiaDoUsuario(
      Usuario user) async {
    var registros = await obterTodosDoDiaDoUsuario(user, false);
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
        "data < '$formatted' and (id <> '' and id is not null)");
  }

  Future<List<LancamentoJustificativas>>
      obterRegistrosAindaNaoSincronizados() async {
    return await allBy(
        LancamentoJustificativas(), " where id = '' or id is null");
  }
}
