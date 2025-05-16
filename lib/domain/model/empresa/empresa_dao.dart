

import 'package:novo_ponto_alfa/domain/model/custom_dao.dart';
import 'package:novo_ponto_alfa/domain/model/empresa/empresa.dart';
import 'package:novo_ponto_alfa/domain/model/filial/filial.dart';
import 'package:novo_ponto_alfa/domain/model/filial/filial_dao.dart';
import 'package:novo_ponto_alfa/infra/core/services/database.dart';

class EmpresaDAO extends CustomDAO<Empresa> {
  Future<EmpresaDAO> init() async {
    database = await DbHelper.getInstance();
    return this;
  }

  @override
  String table() {
    return 'empresas';
  }

  Future<Empresa?> obterPorCnpj(String? cnpj) async {
    FilialDAO filiaisDAO = await FilialDAO().init();
    Filial? filial =
        await filiaisDAO.getBy(Filial(), " where cnpj = '$cnpj'");

    if (filial == null) {
      return null;
    }

    return getById(Empresa(), filial.empresaId);
  }

  Future<Empresa?> obterPorFilialId(int? filialId) async {
    FilialDAO filiaisDAO = await FilialDAO().init();
    Filial? filial = await filiaisDAO.getById(Filial(), filialId);

    if (filial == null) {
      return null;
    }

    return getById(Empresa(), filial.empresaId);
  }
}
