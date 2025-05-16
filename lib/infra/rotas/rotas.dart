import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novo_ponto_alfa/ui/pages/home/page_home.dart';
import 'package:novo_ponto_alfa/ui/pages/login/page_login.dart';

class Rotas {
  static const loginPage = '/login';
  static const homePage = '/home';
  static const registrarFace = '/registrar-face';

  static List<GetPage> obter() {
    return [
      GetPage(name: loginPage, page: () => const PageLogin()),
      GetPage(
          name: homePage,
          page: () => PageHome(
                titulo: "",
              )),
    ];
  }

  static Future irSemRetorno(BuildContext context, var page) async {
    return await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
      (route) => false,
    );
  }

  static Future ir(BuildContext context, var page) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }
}
