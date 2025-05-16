import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/my_exception.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:novo_ponto_alfa/infra/core/utils/util.dart';
import 'package:novo_ponto_alfa/infra/text_styles.dart';
import 'package:novo_ponto_alfa/ui/widgets/dialog/my_alert_dialog.dart';

class MyLoadingDialog {
  static AwesomeDialog? _progressDialog;

  static final _widgetIcone = const Center().obs;
  static final _tituloProgress = ''.obs;
  static final _msgProgress = ''.obs;
  static var _podeFecharOnTouch = false;
  static var _podeFecharOnBackPressed = false;

  static exibir(BuildContext context, MyDialogType dialogType,
      {String? titulo = '',
      String? mensagem = '',
      bool podeFecharOnTouch = false,
      bool podeFecharOnBackPressed = false}) {
    _tituloProgress(titulo);
    _msgProgress(mensagem);
    _podeFecharOnTouch = podeFecharOnTouch;
    _podeFecharOnBackPressed = podeFecharOnBackPressed;

    switch (dialogType) {
      case MyDialogType.LOADING:
        _configurarParaLoading();
        break;
    }

    _exibir(context);
  }

  static _configurarParaLoading() {
    _podeFecharOnTouch = false;
    _podeFecharOnBackPressed = false;
    _tituloProgress('');
    _widgetIcone(
      Center(
        child: PlatformCircularProgressIndicator(
          material: (_, __) => MaterialProgressIndicatorData(),
          cupertino: (_, __) => CupertinoProgressIndicatorData(),
        ),
      ),
    );
  }

  static exibirProgress(BuildContext context, {String titulo = 'Carregando!'}) {
    _tituloProgress(titulo);

    _msgProgress(Traducao.obter(Str.POR_FAVOR_AGUARDE));

    _exibir(context);
  }

  static _exibir(BuildContext context) {
    if (_progressDialog != null) {
      return;
    }

    Util.fecharTeclado(context);

    _configurarLoadingDialog(context);

    _progressDialog!.show();
  }

  static ocultar() {
    if (_progressDialog == null) return;

    _progressDialog = null;

    Get.back();
  }

  static ocultarComAbrirDialogErro(var e) {
    if (_progressDialog != null) {
      ocultar();
    }

    MyException.exibir(e);
  }

  static ocultarComAbrirDialogMensagem(String msg) {
    if (_progressDialog == null) return;

    ocultar();

    MyAlertDialog.exibirMensagem(msg);
  }

  static atualizarMensagem(String msg) {
    _msgProgress(msg);
  }

  static atualizarTitulo(String titulo) {
    _tituloProgress(titulo);
  }

  static _configurarLoadingDialog(BuildContext context) {
    _progressDialog = AwesomeDialog(
      context: context,
      dismissOnTouchOutside: _podeFecharOnTouch,
      dismissOnBackKeyPress: _podeFecharOnBackPressed,
      dialogType: DialogType.noHeader,
      dialogBackgroundColor: context.theme.dialogBackgroundColor,
      animType: AnimType.scale,
      width: context.width > 200 ? 200 : context.width,
      buttonsBorderRadius: const BorderRadius.all(Radius.circular(2)),
      headerAnimationLoop: false,
      body: Container(
        padding: const EdgeInsets.all(5),
        width: context.width > 200 ? 200 : context.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => _widgetIcone(),
            ),
            const SizedBox(
              height: 5,
            ),
            Obx(
              () => _tituloProgress().isNotEmpty
                  ? Text(
                      _tituloProgress(),
                      style:
                          TextStyles.styleTituloNormal().copyWith(fontSize: 16),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    )
                  : const Center(),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => _msgProgress().isNotEmpty
                        ? Text(
                            _msgProgress(),
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            style: TextStyles.styleTituloAppBar()
                                .copyWith(fontSize: 14),
                          )
                        : const Center(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum MyDialogType {
  LOADING,
}
