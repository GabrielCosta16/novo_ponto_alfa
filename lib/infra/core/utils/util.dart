import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Util {
  static fecharTeclado(BuildContext context) {
    FocusScope.of(context).unfocus();
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static String somenteNumeros(String? value) {
    if (value == null) {
      return "";
    }

    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  static String criarUniqueId(complemento) {
    return "$complemento${DateTime.now().millisecondsSinceEpoch}";
  }

  static String gerarMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  static Future carregarCertificadoHttps() async {
    ByteData data =
        await PlatformAssetBundle().load('assets/ca/isrgrootx1.pem');
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(data.buffer.asUint8List());
  }
}

printIfDebug(var obj) {
  if (kDebugMode) {
    print(obj.toString());
  }
}
