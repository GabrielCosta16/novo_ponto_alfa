import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gryfo_lib/flutter_gryfo_lib.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:novo_ponto_alfa/domain/model/reconhecimento_facial/global_gryfo_lib.dart';
import 'package:novo_ponto_alfa/infra/core/configuracao/ambiente.dart';
import 'package:novo_ponto_alfa/infra/core/utils/util.dart';
import 'package:novo_ponto_alfa/infra/rotas/rotas.dart';
import 'package:novo_ponto_alfa/infra/theme.dart';
import 'package:novo_ponto_alfa/infra/theme_light.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:novo_ponto_alfa/infra/traducoes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Util.carregarCertificadoHttps();

  // await Firebase.initializeApp(
  //   name: 'ponto_alfa',
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  await GetStorage.init();

  if (kDebugMode && false) {
    Ambiente.useHomologacao();
  } else {
    Ambiente.useProducao();
  }

  iniciarApp();
}

void iniciarApp() {
  runApp(
    GetMaterialApp(
      theme: ThemeLight().obter(),
      darkTheme: ThemeLight().obter(),
      themeMode: MyTheme.obter(),
      defaultTransition: Transition.native,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      translations: Traducoes(),
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      locale: const Locale('pt', 'BR'),
      initialRoute: Rotas.loginPage,
      getPages: Rotas.obter(),
    ),
  );
}
