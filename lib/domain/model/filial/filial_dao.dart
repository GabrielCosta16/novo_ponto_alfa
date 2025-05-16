import 'package:novo_ponto_alfa/domain/model/custom_dao.dart';
import 'package:novo_ponto_alfa/domain/model/custom_dao.dart';
import 'package:novo_ponto_alfa/domain/model/empresa/empresa.dart';
import 'package:novo_ponto_alfa/domain/model/filial/filial.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_tratada.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:novo_ponto_alfa/infra/core/requisicoes/requisitar_uri_ambiente.dart';
import 'package:novo_ponto_alfa/infra/core/services/database.dart';

import '../empresa/empresa_dao.dart';

class FilialDAO extends CustomDAO<Filial> {
  Future<FilialDAO> init() async {
    database = await DbHelper.getInstance();
    return this;
  }

  @override
  String table() {
    return 'filiais';
  }

  Future<Filial> obterPorCnpj(String? cnpj) async {
    try {
      await RequisicaoUriAmbiente().executar(cnpj);

      await importAllFromServerFiltered(Filial(), {'cnpj': cnpj});

      Filial? filial = await getBy(Filial(), " where cnpj = '$cnpj'");

      if (filial == null) {
        throw ExceptionTratada(Traducao.obter(Str.O_CNPJ_INFORMADO_E_INVALIDO));
      }

      EmpresaDAO empresasDAO = await EmpresaDAO().init();
      await empresasDAO
          .importAllFromServerFiltered(Empresa(), {'id': filial.empresaId});
    } catch (e) {
      print(e);
      // TODO - testar request
    }

    Filial? filial = await getBy(Filial(), " where cnpj = '$cnpj'");

    if (filial != null) return filial;

    throw ExceptionTratada(Traducao.obter(Str
        .OS_DADOS_DE_ACESSO_INFORMADOS_NAO_ENCONTRADOS_NA_BASE_DE_DADOS_OFFLINE));
  }

  Future<Filial?> obterPorCnpjBase(String? cnpj) async {
    return await getBy(Filial(), " where cnpj = '$cnpj'");
  }
}
