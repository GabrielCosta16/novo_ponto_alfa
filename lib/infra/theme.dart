import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novo_ponto_alfa/infra/core/preferences/preferencias.dart';
class MyTheme {
  static ThemeMode obter() {
    int index =
        Preferences.obter(Preference.THEME_MODE, padrao: ThemeMode.light.index);

    return index == ThemeMode.dark.index ? ThemeMode.dark : ThemeMode.light;
  }

  static alterarTema() {
    var themeMode = Get.isDarkMode ? ThemeMode.light : ThemeMode.dark;

    Get.changeThemeMode(themeMode);

    Preferences.salvar(Preference.THEME_MODE, themeMode.index);
  }
}
