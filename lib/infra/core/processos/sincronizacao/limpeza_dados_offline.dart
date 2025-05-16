import 'dart:io';

import 'package:novo_ponto_alfa/domain/model/ponto/registros_ponto.dart';
import 'package:novo_ponto_alfa/domain/model/ponto/registros_ponto_dao.dart';
import 'package:path/path.dart' as path;

class LimpezaDadosOffline {
  List<RegistrosPonto>? pontosOffline;
  String? diretorioImagens;

  Future executar() async {
    await _carregarPontosOffline();
    await _carregarDiretorioImagens();

    _excluirImagens();
  }

  Future _carregarPontosOffline() async {
    RegistrosPontoDAO dao = await RegistrosPontoDAO().init();
    pontosOffline = await dao.obterRegistrosAindaNaoSincronizados();
  }

  Future _carregarDiretorioImagens() async {
    diretorioImagens = await RegistrosPonto.obterPathImagens();
  }

  void _excluirImagens() {
    Directory(diretorioImagens!)
        .list(recursive: true, followLinks: false)
        .listen((FileSystemEntity arquivo) {
      String nomeArquivo = path.basename(arquivo.path);
      bool isNecessario = false;

      if (pontosOffline!.length > 1) {
        for (RegistrosPonto pontoOffline in pontosOffline!) {
          if (isNecessario) {
            continue;
          }

          if (pontoOffline.foto != null && pontoOffline.foto != "") {
            if (pontoOffline.foto == nomeArquivo) {
              isNecessario = true;
            }
          }

          if (pontoOffline.assinatura != null &&
              pontoOffline.assinatura != "") {
            if (pontoOffline.assinatura == nomeArquivo) {
              isNecessario = true;
            }
          }
        }
      } else {
        // Se todos os pontos foram sincronizados nenhuma imagem é necessária
      }

      if (!isNecessario) {
        arquivo.deleteSync();
      }
    });
  }
}
