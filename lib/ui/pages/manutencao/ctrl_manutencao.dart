import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:novo_ponto_alfa/domain/model/periodo/periodos.dart';
import 'package:novo_ponto_alfa/domain/model/periodo/periodos_dao.dart';
import 'package:novo_ponto_alfa/domain/model/user/usuario.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/my_exception.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:novo_ponto_alfa/infra/core/preferences/preferencias.dart';
import 'package:novo_ponto_alfa/infra/core/repositories/usuario/usuario_dao.dart';

class CtrlManutencao {
  String idUsuario = "";
  bool bloquearCampoMatricula = false;
  bool validacaoMatricula = false;
  TextEditingController tecMatricula = TextEditingController();
  UsuarioDAO? usuarioDAO;
  Usuario? user;
  TextEditingController tecDataHoraSelecionada = TextEditingController();
  DateTime? dataHoraSelecionada;
  Map<String, String> periodosMap = {};

  void inicializar() async {
    try {
      usuarioDAO = await UsuarioDAO().init();

      if (dataHoraSelecionada == null) {
        dataHoraSelecionada = DateTime.now();
        tecDataHoraSelecionada.text =
            DateFormat("dd/MM/yyyy").format(dataHoraSelecionada!);
      }

      user = await Preferences.usuarioLogado();
      if (user != null) {
        tecMatricula.text = user!.matricula!;
        bloquearCampoMatricula = true;

        await carregarRegistros();
      }

      PeriodosDAO periodosDAO = await PeriodosDAO().init();
      List<Periodos> periodosDB = await periodosDAO.get(Periodos(),
          orderBy: "ORDER BY data_final DESC");
      for (Periodos periodo in periodosDB) {
        periodosMap["${periodo.id}"] =
            periodo.nome! + (periodo.ativo! ? Traducao.obter(Str.ABERTO) : '');
      }
    } catch (e) {
      MyException.exibir(e);
    }
  }

  bool validarMatricula() {
    if (tecMatricula.text.isEmpty) {
      validacaoMatricula = true;
      return false;
    }

    return true;
  }

  Future onAlterarDataHora(BuildContext context) async {
    DateTime? dataHora = await showDatePicker(
      context: context,
      initialDate:
          (dataHoraSelecionada != null) ? dataHoraSelecionada! : DateTime.now(),
      locale: Get.deviceLocale,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (dataHora != null) {
      dataHoraSelecionada = dataHora;
      tecDataHoraSelecionada.text =
          DateFormat("dd/MM/yyyy").format(dataHoraSelecionada!);
    }
  }

  Future carregarRegistros() async {
    if (!validarMatricula()) {
      return;
    }

    user = await usuarioDAO!
        .getBy(Usuario(), " where matricula = '${tecMatricula.text}'");
    if (user == null) {
      validacaoMatricula = true;
      return;
    }
    validacaoMatricula = false;
  }
}
