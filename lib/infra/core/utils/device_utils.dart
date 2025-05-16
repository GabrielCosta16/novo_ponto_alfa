import 'dart:io';

import 'package:location/location.dart';
import 'package:novo_ponto_alfa/infra/core/permissoes/permissao_localizacao.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceUtils {
  static PackageInfo? packageInfo;

  static Future<PackageInfo> loadPackageInfo({renew = false}) async {
    if (renew || packageInfo == null) {
      packageInfo = await PackageInfo.fromPlatform();
    }

    return packageInfo!;
  }

  static String versionDisplay() {
    return packageInfo?.version ?? '';
  }

  static Future validarUsoFakeGPS() async {
    if (Platform.isIOS) return;

    // bool isFakeLocation = (await Antifakegps().detectFakeLocation())!;
    //
    // if (isFakeLocation) {
    //   throw ExceptionTratada(Traducao.obter(Str
    //       .O_APLICATIVO_X1_ESTA_MANIPULANDO_O_SENSOR_DE_GPS_DESATIVE_O_MANIPULADOR_DE_GPS));
    // }
  }

  static Future<Location> requestGPS() async {
    await PermissaoLocalizacao.solicitarPermissao();

    var location = Location();
    await location.requestService();

    PermissionStatus status = await location.hasPermission();

    while (status != PermissionStatus.granted &&
        status != PermissionStatus.grantedLimited) {
      await location.requestPermission();
    }

    location.getLocation().then((data) {
      print(data);
    }, onError: (error) {
      print(error);
    });

    return location;
  }

  static Future<DateTime> getDataHoraReal(
      {LocationData? data, bool naoUsarGps = true}) async {
    return DateTime.now();
  }
}
