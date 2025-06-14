import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:novo_ponto_alfa/domain/model/registro_facial_temporario/mdl_registro_facial_temporario.dart';
import 'package:novo_ponto_alfa/domain/model/registro_facial_temporario/registro_facial_temporario_dao.dart';
import 'package:novo_ponto_alfa/infra/core/utils/util.dart';
import 'package:novo_ponto_alfa/ui/widgets/dialog/my_alert_dialog.dart';

class RepoCadastroFacial {
  Future<List<RegistroFacialTemporario>> enviarRegistroFacialGryfo(
      BuildContext context) async {
    RegistroFacialTemporarioDAO registroFacialTemporarioDAO =
        RegistroFacialTemporarioDAO();
    await registroFacialTemporarioDAO.init();
    final url = Uri.parse('https://prod.storage.gryfo.com.br/api/person/add');

    List<RegistroFacialTemporario> listaRegistrosTemporarios =
        await registroFacialTemporarioDAO.get(RegistroFacialTemporario());

    List<RegistroFacialTemporario> registrosImportados = [];

    for (RegistroFacialTemporario registro in listaRegistrosTemporarios) {
      XFile imageFile = XFile(registro.pathImagemFacial!);
      final String base64Image = base64Encode(await imageFile.readAsBytes());

      final Map<String, dynamic> body = {
        "name": registro.nome,
        "external_id": registro.external_id,
        "company_external_id": "87",
        "raw_images": [base64Image],
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c3IiOiJhbGZhLWRldmVsb3BtZW50IiwiaWF0IjoxNzQ3NDAyMTE1LCJleHAiOjE3NDgwMDY5MTV9.deZ6oDjlDWgt_LNJiK-0xc-vgQYOoAKJzwOZYz_XopU',
          'X-Client-Version': '1',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        validarRetornoAPI(response);
        registrosImportados.add(registro);
        registroFacialTemporarioDAO.deleteByExternalId(registro.external_id!);
        printIfDebug("Pessoa adicionada com sucesso.");
      } else {
        printIfDebug("Erro ao adicionar pessoa: ${response.statusCode}");
        printIfDebug("Resposta: ${response.body}");
      }
    }
    return registrosImportados;
  }

  void validarRetornoAPI(http.Response response) {
    var jsonRetorno = jsonDecode(response.body);
    var data = jsonRetorno["data"];
    if (data["code"] == 200) {
      return;
    }

    throw Exception(data["message"]);
  }
}
