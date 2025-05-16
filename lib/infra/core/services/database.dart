import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? database;

  static Future<Database> getInstance() async {
    if (database != null) return database!;

    database = await DbHelper().getDatabase();

    return database!;
  }

  static Future clearAllTables() async {
    var database = await getInstance();

    await database.delete('users');
    await database.delete('aparelhos');
    await database.delete('cercos');
    await database.delete('dados_auxiliares');
    await database.delete('empresas');
    await database.delete('filiais');
    await database.delete('horarios');
    await database.delete('justificativas_falta');
    await database.delete('lancamento_justificativas');
    await database.delete('pendencias');
    await database.delete('periodos');
    await database.delete('registros_ponto');
  }

  getDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'pontodigital.db');

    return await openDatabase(dbPath,
        version: 20, onCreate: populateDb, onUpgrade: upgradeDb);
  }

  void populateDb(Database database, int version) async {
    await database.execute(createTableAparelhos);
    await database.execute(createTableFiliais);
    await database.execute(createTableUsers);
    await database.execute(createTableRegistrosPonto);
    await database.execute(createDadosAuxiliares);
    await database.execute(createEmpresas);
    await database.execute(createCercos);
    await database.execute(createJustificativasFalta);
    await database.execute(createHorarios);
    await database.execute(createLancamentoJustificativa);
    await database.execute(createPeriodos);
    await database.execute(createPendencias);
    await database.execute(createTableRegistrosFaciaisTemporarios);
  }

  void upgradeDb(Database database, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await database.execute(alterTableUsers1);
    }

    if (oldVersion < 3) {
      await database.execute(alterTableEmpresas1);
      await database.execute(alterTableRegistrosPonto1);
      await database.execute(createCercos);
    }

    if (oldVersion < 4) {
      await database.execute(
          "ALTER TABLE empresas ADD COLUMN captura_assinatura INTEGER");
      await database.execute(
          "ALTER TABLE empresas ADD COLUMN exigir_captura_em_cerco INTEGER");
      await database
          .execute("ALTER TABLE empresas ADD COLUMN campo_adicional INTEGER");
    }

    if (oldVersion < 5) {
      //
    }

    if (oldVersion < 6) {
      await database
          .execute("ALTER TABLE registros_ponto ADD COLUMN cerco_id INTEGER");
    }

    if (oldVersion < 7) {
      await database.execute(
          "ALTER TABLE registros_ponto ADD COLUMN data_hora_registro_aparelho TEXT");
      await database.execute(
          "ALTER TABLE registros_ponto ADD COLUMN data_hora_obtida_por_gps INTEGER");
      await database.execute(
          "ALTER TABLE empresas ADD COLUMN obter_data_hora_por_gps INTEGER");
    }

    if (oldVersion < 9) {
      await database.execute(
          "ALTER TABLE registros_ponto ADD COLUMN estado_pessoa_id INTEGER");
      await database
          .execute("ALTER TABLE users ADD COLUMN estado_pessoa_id INTEGER");
    }

    if (oldVersion < 10) {
      await database.execute("ALTER TABLE users ADD COLUMN horario_id INTEGER");
      await database
          .execute("ALTER TABLE empresas ADD COLUMN horario_id INTEGER");
      await database
          .execute("ALTER TABLE filiais ADD COLUMN horario_id INTEGER");
      await database.execute(createJustificativasFalta);
      await database.execute(createHorarios);
      await database.execute(createLancamentoJustificativa);
    }

    if (oldVersion < 11) {
      await database.execute(
          "ALTER TABLE registros_ponto ADD COLUMN alteracao_manual INTEGER");
      await database
          .execute("ALTER TABLE registros_ponto ADD COLUMN justificativa TEXT");
    }

    if (oldVersion < 12) {
      await database.execute(
          "ALTER TABLE justificativas_falta ADD COLUMN obrigatoriedade_foto_id INTEGER");
    }

    if (oldVersion < 13) {
      await database.execute(
          "ALTER TABLE lancamento_justificativas ADD COLUMN aparelho_id INTEGER");
    }

    if (oldVersion < 14) {
      await database.execute(createPeriodos);
    }

    if (oldVersion < 15) {
      await database.execute(createPendencias);
    }

    if (oldVersion < 17) {
      await database.execute(
          "ALTER TABLE cercos ADD COLUMN raio INTEGER NOT NULL DEFAULT 0");
    }

    if (oldVersion < 18) {
      await database.execute(
          "ALTER TABLE lancamento_justificativas ADD COLUMN hora_inicio TEXT");
      await database.execute(
          "ALTER TABLE lancamento_justificativas ADD COLUMN hora_fim TEXT");
    }

    if (oldVersion < 19) {
      await database.execute(
          "ALTER TABLE registros_ponto ADD COLUMN desconsiderado INTEGER");
    }

    if (oldVersion < 20) {
      await database.execute(
          "ALTER TABLE users ADD COLUMN config_app_lancamento_manual INTEGER DEFAULT 0");

      await database.execute(
          "ALTER TABLE users ADD COLUMN config_app_justificativa INTEGER DEFAULT 0");
    }
  }

  String alterTableUsers1 = "ALTER TABLE users ADD COLUMN ativo INTEGER";

  String alterTableEmpresas1 = ""
      "ALTER TABLE empresas ADD COLUMN captura_foto INTEGER;"
      "";

  String alterTableRegistrosPonto1 = ""
      "ALTER TABLE registros_ponto ADD COLUMN assinatura TEXT;"
      "";

  String createTableAparelhos = "CREATE TABLE aparelhos ("
      "id INTEGER PRIMARY KEY,"
      "filial_id INTEGER,"
      "unique_id TEXT,"
      "created_at TEXT,"
      "updated_at TEXT,"
      "autorizado INTEGER"
      ")";


  String createTableRegistrosFaciaisTemporarios = "CREATE TABLE registro_facial_temporario ("
      "id INTEGER PRIMARY KEY,"
      "nome TEXT,"
      "external_id TEXT,"
      "company_external_id TEXT,"
      "pathImagemFacial TEXT"
      ")";

  String createTableFiliais = "CREATE TABLE filiais ("
      "id INTEGER PRIMARY KEY,"
      "empresa_id INTEGER,"
      "nome TEXT,"
      "cnpj TEXT,"
      "horario_id INTEGER,"
      "created_at TEXT,"
      "updated_at TEXT"
      ")";

  String createTableUsers = "CREATE TABLE users ("
      "id INTEGER PRIMARY KEY,"
      "filial_id INTEGER,"
      "name TEXT,"
      "email TEXT,"
      "password TEXT,"
      "avatar TEXT,"
      "matricula TEXT,"
      "estado_pessoa_id INTEGER,"
      "config_app_lancamento_manual INTEGER DEFAULT 0,"
      "config_app_justificativa INTEGER DEFAULT 0,"
      "horario_id INTEGER,"
      "created_at TEXT,"
      "updated_at TEXT,"
      "ativo INTEGER"
      ")";

  String createTableRegistrosPonto = "CREATE TABLE registros_ponto ("
      "id INTEGER,"
      "unique_id TEXT UNIQUE,"
      "user_id INTEGER,"
      "cerco_id INTEGER,"
      "data_hora_registro TEXT,"
      "justificativa TEXT,"
      "data_hora_registro_aparelho TEXT,"
      "data_hora_obtida_por_gps INTEGER,"
      "latitude TEXT,"
      "longitude TEXT,"
      "foto TEXT,"
      "assinatura TEXT,"
      "valor_auxiliar TEXT,"
      "aparelho_id INTEGER,"
      "estado_pessoa_id INTEGER,"
      "alteracao_manual INTEGER,"
      "created_at TEXT,"
      "updated_at TEXT,"
      "desconsiderado INTEGER"
      ")";

  String createDadosAuxiliares = "CREATE TABLE dados_auxiliares ("
      "id INTEGER PRIMARY KEY,"
      "empresa_id INTEGER,"
      "chave TEXT,"
      "valor TEXT"
      ")";

  String createPeriodos = "CREATE TABLE periodos ("
      "id INTEGER PRIMARY KEY,"
      "filial_id INTEGER,"
      "nome TEXT,"
      "data_inicial TEXT,"
      "data_final TEXT,"
      "ativo INTEGER"
      ")";

  String createEmpresas = "CREATE TABLE empresas ("
      "id INTEGER PRIMARY KEY,"
      "nome TEXT,"
      "tolerancia INTEGER,"
      "titulo_campo_adicional TEXT,"
      "logo TEXT,"
      "exigir_captura_gps INTEGER,"
      "captura_foto INTEGER,"
      "captura_assinatura INTEGER,"
      "exigir_captura_em_cerco INTEGER,"
      "obter_data_hora_por_gps INTEGER,"
      "horario_id INTEGER,"
      "campo_adicional INTEGER"
      ")";

  String createCercos = "CREATE TABLE cercos ("
      "id INTEGER PRIMARY KEY,"
      "empresa_id INTEGER,"
      "nome TEXT,"
      "latitude TEXT,"
      "longitude TEXT,"
      "raio INTEGER,"
      "ativo INTEGER"
      ")";

  String createJustificativasFalta = "CREATE TABLE justificativas_falta ("
      "id INTEGER PRIMARY KEY,"
      "empresa_id INTEGER,"
      "obrigatoriedade_foto_id INTEGER,"
      "chave TEXT,"
      "valor TEXT"
      ")";

  String createHorarios = "CREATE TABLE horarios ("
      "id INTEGER PRIMARY KEY,"
      "empresa_id INTEGER,"
      "controle_banco_horas INTEGER"
      ")";

  String createLancamentoJustificativa =
      "CREATE TABLE lancamento_justificativas ("
      "id INTEGER,"
      "user_id INTEGER,"
      "aparelho_id INTEGER,"
      "data TEXT,"
      "hora_inicio TEXT,"
      "hora_fim TEXT,"
      "foto TEXT,"
      "unique_id TEXT UNIQUE,"
      "valor_auxiliar TEXT,"
      "justificativa_falta_id INTEGER,"
      "descontar_banco_horas INTEGER"
      ")";

  String createPendencias = "CREATE TABLE pendencias ("
      "id INTEGER,"
      "user_id INTEGER,"
      "data TEXT,"
      "titulo TEXT,"
      "mensagem TEXT"
      ")";
}
