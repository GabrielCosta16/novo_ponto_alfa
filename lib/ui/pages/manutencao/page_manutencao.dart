import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:novo_ponto_alfa/ui/pages/custom/page_custom.dart';
import 'package:novo_ponto_alfa/ui/pages/home/ctrl_page_home.dart';
import 'package:novo_ponto_alfa/ui/pages/manutencao/ctrl_manutencao.dart';
import 'package:novo_ponto_alfa/ui/widgets/botao.dart';
import 'package:novo_ponto_alfa/ui/widgets/dialog/my_alert_dialog.dart';

class PageManutencao extends StatefulWidget {
  Function(String) onClickCadastrarFace;
  PageController pageController;

  PageManutencao(
      {required this.onClickCadastrarFace, required this.pageController, super.key});

  @override
  State<PageManutencao> createState() => _PageManutencaoState();
}

class _PageManutencaoState extends State<PageManutencao> {
  CtrlManutencao controller = CtrlManutencao();
  CtrlPageHome controllerHome = CtrlPageHome();

  @override
  Widget build(BuildContext context) {
    return PageCustom(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Traducao.obter(Str.MANUTENCAO),
                    style: context.textTheme.titleLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        _construirWidgetBloqueiaMatricula(),
                        _construirWidgetDataReferencia(),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      _construirWidgetQualAcao(),
                      const SizedBox(
                        height: 16,
                      ),
                      _construirWidgetListaAcoes(),
                    ],
                  ),
                  Botao(
                      titulo: "Voltar",
                      onClick: () {
                        widget.pageController.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      })
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _construirWidgetQualAcao() {
    return Text(
      Traducao.obter(Str.QUAL_A_ACAO),
    );
  }

  Widget _construirWidgetDataReferencia() {
    return TextField(
      controller: controller.tecDataHoraSelecionada,
      onTap: () async {
        await controller.onAlterarDataHora(context);
      },
      readOnly: true,
      keyboardType: TextInputType.datetime,
      style: context.textTheme.titleMedium,
      decoration: InputDecoration(
        labelText: Traducao.obter(Str.QUAL_A_DATA_DE_REFERENCIA),
        labelStyle: context.textTheme.titleMedium,
        hintText: Traducao.obter(Str.DATA),
        icon: Icon(Icons.date_range_outlined),
        hintStyle: context.textTheme.titleSmall,
      ),
    );
  }

  Widget _construirWidgetBloqueiaMatricula() {
    return controller.bloquearCampoMatricula
        ? const Text('')
        : Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller.tecMatricula,
                  // onChanged: (text) =>
                  //     controller.onSearchDebouncer.debounce(() async {
                  //   await controller.carregarRegistros();
                  //   atualizarTela();
                  // })
                  enabled: !controller.bloquearCampoMatricula,
                  keyboardType: TextInputType.number,
                  style: context.textTheme.titleMedium,
                  decoration: InputDecoration(
                    labelText: Traducao.obter(Str.MATRICULA),
                    labelStyle: context.textTheme.titleSmall,
                    errorText: controller.validacaoMatricula
                        ? Traducao.obter(Str.A_MATRICULA_INFORMADA_E_INVALIDA)
                        : null,
                    icon: Icon(Icons.person),
                    hintText: Traducao.obter(Str.MATRICULA),
                    hintStyle: context.textTheme.titleSmall,
                  ),
                ),
                flex: 5,
              ),
            ],
          );
  }

  Widget _construirWidgetListaAcoes() {
    return SizedBox(
      height: 300,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          const Divider(height: 1),
          _construirLinhaOpcao(
            Traducao.obter(Str.CONSULTAR_PONTOS),
            () async {
              // await controller.onCLickConsultarPontos();
            },
          ),
          const Divider(height: 1),
          _construirLinhaOpcao(
            Traducao.obter(Str.LANCAMENTO_MANUAL),
            () async {
              // await controller.onClickLancamentoManual();
            },
          ),
          const Divider(height: 1),
          _construirLinhaOpcao(
            Traducao.obter(Str.LANCAMENTO_DE_JUSTIFICATIVA),
            () async {
              // await controller.onClickLancamentoJustificativa();
            },
          ),
          const Divider(height: 1),
          _construirLinhaOpcao(
            Traducao.obter(Str.VER_ESPELHO),
            () async {
              // await controller.onClickVerEspelho();
            },
          ),
          const Divider(height: 1),
          _construirLinhaOpcao(
            Traducao.obter(Str.CADASTRAR_FACE),
            () async {
              try {
                if (controller.tecMatricula.text.isEmpty) {
                  throw Exception("Matricula nao informada");
                  return;
                }
                await widget.onClickCadastrarFace(controller.tecMatricula.text);

                controller.tecMatricula.clear();
              } catch (e) {
                MyAlertDialog.exibirOk("", e.toString(), () {
                  Navigator.of(context).pop();
                });
              }
            },
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  ListTile _construirLinhaOpcao(String titulo, Function onClick) {
    return ListTile(
      onTap: () async {
        onClick.call();
      },
      title: Text(
        titulo,
        style: context.textTheme.titleMedium,
      ),
      trailing: Icon(Icons.arrow_forward_ios_outlined),
    );
  }
}
