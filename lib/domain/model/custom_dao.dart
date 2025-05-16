import 'package:novo_ponto_alfa/domain/model/custom.dart';
import 'package:novo_ponto_alfa/infra/core/configuracao/ambiente.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_tratada.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:novo_ponto_alfa/infra/core/requisicoes/requisitar_get.dart';
import 'package:novo_ponto_alfa/infra/core/requisicoes/requisitar_get_equals.dart';
import 'package:sqflite/sqflite.dart';

abstract class CustomDAO<T extends CustomModel> {
  Database? database;

  Future<int> create(T obj) async {
    var result = await database!.insert(table(), obj.toJson());
    return result;
  }

  Future<List<T>> get(T obj, {String orderBy = ""}) async {
    var result =
        await database!.rawQuery('SELECT * FROM ' + table() + " $orderBy");
    return obj.convertJsonList(result.toList());
  }

  Future<T?> getBy(T? obj, String where) async {
    List<Map<String, dynamic>> results =
        await database!.rawQuery("SELECT * FROM ${table()}$where");

    if (results.isNotEmpty) {
      return obj?.convertJson(results.first);
    }

    return null;
  }

  Future<List<T>> allBy(T obj, String where) async {
    List<Map<String, dynamic>> results =
        await database!.rawQuery("SELECT * FROM ${table()}$where");

    return obj.convertJsonList(results);
  }

  Future<T?> getById(T? obj, int? id) async {
    List<Map<String, dynamic>> results =
        await database!.query(table(), where: 'id = ?', whereArgs: [id]);

    if (results.isNotEmpty) {
      return obj?.convertJson(results.first);
    }

    return null;
  }

  Future<T?> getById2(int id) async {
    List<Map<String, dynamic>> results =
        await database!.query(table(), where: 'id = ?', whereArgs: [id]);

    if (results.isNotEmpty) {
      return (T as CustomModel).convertJson(results.first);
    }

    return null;
  }

  Future<int> update(T obj) async {
    if (obj.id != null) {
      var registro = await getById(obj, obj.id!);
      if (registro != null) {
        return await database!.update(table(), obj.toJson(),
            where: "id = ?", whereArgs: [obj.id]);
      }
    }

    return await create(obj);
  }

  Future<int> updateByUniqueId(T obj, String? uniqueId) async {
    if (uniqueId == null || uniqueId == '') {
      throw ExceptionTratada(Traducao.obter(Str.UNIQUE_ID_E_OBRIGATORIO));
    }

    T? registro = await getBy(obj, " where unique_id = '$uniqueId'");
    if (registro != null) {
      return await database!.update(table(), obj.toJson(),
          where: "unique_id = ?", whereArgs: [uniqueId]);
    }

    return await create(obj);
  }

  Future<int> delete(int id) async {
    return await database!.delete(table(), where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteWithWhere(String whereSql) async {
    if (whereSql == "") {
      whereSql = " 1=1 ";
    }

    return await database!.delete(table(), where: whereSql);
  }

  void syncData() {}

  Future<List<T>> importAllFromServer(T obj) async {
    var url = PathRequisicao.URL_AMBIENTE_BASE + table();

    final response = await RequisicaoGet().executar(url + "/all");

    await deleteWithWhere("");
    for (dynamic responseObj in response) {
      await update(obj.convertJson(responseObj));
    }

    return get(obj);
  }

  Future<List<T>> importAllFromServerFiltered(
      T obj, Map<String, dynamic> filtros,
      {String? urlCustom}) async {
    String url =
        urlCustom ?? PathRequisicao.URL_AMBIENTE_BASE + table() + "/all";

    final response = await RequisitarGetEquals().executar(url, filtros, "");

    await deleteWithWhere("");

    for (dynamic responseObj in response) {
      await update(obj.convertJson(responseObj));
    }

    return await get(obj);
  }

  void closeDatabase() async {
    await database!.close();
  }

  String table();
}
