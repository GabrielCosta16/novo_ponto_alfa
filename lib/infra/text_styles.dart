import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novo_ponto_alfa/infra/colors.dart';

class TextStyles {
  static TextStyle styleRelogio() {
    return Get.theme.textTheme.displayLarge!.copyWith(
      fontSize: 30,
    );
  }

  static TextStyle styleTituloNormal() {
    return Get.theme.textTheme.displayMedium!.copyWith(
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle styleTituloAppBar() {
    return Get.theme.textTheme.displayMedium!
        .copyWith(fontWeight: FontWeight.bold, color: MyColors.branco);
  }

  static TextStyle styleSubTituloAppBar() {
    return Get.theme.textTheme.displayMedium!
        .copyWith(fontWeight: FontWeight.bold, color: MyColors.branco);
  }

  static TextStyle styleTituloPequeno() {
    return Get.theme.textTheme.displayMedium!.copyWith(
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle styleBody1() {
    return Get.theme.textTheme.displayMedium!;
  }

  static TextStyle styleBody1Small() {
    return Get.theme.textTheme.displayMedium!.copyWith(fontSize: 14);
  }

  static TextStyle styleTituloWidget() {
    return Get.theme.textTheme.displayMedium!;
  }

  static TextStyle styleHintWidget() {
    return Get.theme.textTheme.bodySmall!.copyWith(color: MyColors.cinzaMedium);
  }

  static TextStyle styleTituloWidgetPreto() {
    return Get.theme.textTheme.displayMedium!
        .copyWith(color: Get.theme.primaryColorDark);
  }
}
