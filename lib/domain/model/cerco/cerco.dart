import 'dart:math';
import 'package:location/location.dart';
import 'package:novo_ponto_alfa/domain/model/cerco/cercos_dao.dart';
import 'package:novo_ponto_alfa/domain/model/custom.dart';
import 'package:novo_ponto_alfa/domain/model/empresa/empresa.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/exception_tratada.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/strings.dart';
import 'package:novo_ponto_alfa/infra/core/internacionalizacao/traducao.dart';
import 'package:novo_ponto_alfa/infra/core/permissoes/permissao_localizacao.dart';
import 'package:novo_ponto_alfa/infra/core/preferences/preferencias.dart';

class Cerco extends CustomModel {
  @override
  int? id;

  int? empresaId;
  String? nome;
  String? latitude;
  String? longitude;
  int? raio;
  bool? ativo;

  Cerco({
    this.id,
    this.empresaId,
    this.nome,
    this.latitude,
    this.longitude,
    this.raio,
    this.ativo,
  });

  factory Cerco.fromJson(Map<String, dynamic> json) => Cerco(
      id: json["id"],
      empresaId: json["empresa_id"],
      nome: json["nome"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      raio: json["raio"],
      ativo: CustomModel.tratarBoolean(json["ativo"]));

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "empresa_id": empresaId,
        "nome": nome,
        "latitude": latitude,
        "longitude": longitude,
        "raio": raio,
        "ativo": ativo
      };

  @override
  CustomModel convertJson(Map<String, dynamic> json) {
    return Cerco.fromJson(json);
  }

  @override
  List<Cerco> convertJsonList(List<Map<String, dynamic>> json) {
    List<Cerco> retorno = [];
    for (Map<String, dynamic> item in json) {
      retorno.add(Cerco.fromJson(item));
    }

    return retorno;
  }

  static Future<int?> verificarCercoSeNecessario() async {
    Empresa? empresa = await Preferences.empresaLogada();

    if (empresa == null) {
      return null;
    }

    if (!empresa.exigirCapturaEmCerco!) {
      return null;
    }

    await PermissaoLocalizacao.solicitarPermissao();

    var location = Location();
    LocationData? userLocation = await location.getLocation();

    if (userLocation.latitude == 0 ||
        userLocation.longitude == 0) {
      throw ExceptionTratada(
          Traducao.obter(Str.A_LOCALIZACAO_ATUAL_NAO_PODE_SER_OBTIDA));
    }

    var latitude = userLocation.latitude.toString();
    var longitude = userLocation.longitude.toString();

    CercosDAO cercosDAO = await CercosDAO().init();
    List<Cerco> cercos = await cercosDAO.get(Cerco());

    Cerco? cercoParaRetornar;
    double menorDistancia = 99999999999.00;

    for (Cerco cerco in cercos) {
      double latitudeAtual = double.parse(latitude);
      double longitudeAtual = double.parse(longitude);

      double latitudeCerco = double.parse(cerco.latitude!);
      double longitudeCerco = double.parse(cerco.longitude!);

      final harvesine = GreatCircleDistance(
          latitude1: latitudeAtual,
          latitude2: latitudeCerco,
          longitude1: longitudeAtual,
          longitude2: longitudeCerco);

      double distancia = harvesine.distance();

      if (distancia < menorDistancia && distancia <= cerco.raio!) {
        menorDistancia = distancia;
        cercoParaRetornar = cerco;
      }
    }

    if (cercoParaRetornar == null) {
      throw ExceptionTratada(
          Traducao.obter(Str.VOCE_NAO_ESTA_DENTRO_DE_NENHUM_CERCO_DE_TRABALHO));
    }

    return cercoParaRetornar.id!;
  }
}

class GreatCircleDistance {
  final double R = 6371000; // radius of Earth, in meters
  double latitude1, longitude1;
  double latitude2, longitude2;

  GreatCircleDistance(
      {required this.latitude1,
      required this.latitude2,
      required this.longitude1,
      required this.longitude2});

  double distance() {
    double phi1 = latitude1 * pi / 180;
    double phi2 = latitude2 * pi / 180;
    var deltaPhi = (latitude2 - latitude1) * pi / 180;
    var deltaLambda = (longitude2 - longitude1) * pi / 180;

    var a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }
}
