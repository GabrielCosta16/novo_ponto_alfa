
import 'package:novo_ponto_alfa/infra/core/exceptions/custom_exception.dart';

class TenteNovamenteExcetion extends CustomException {
  @override
  late String mensagem;

  TenteNovamenteExcetion(this.mensagem) : super(mensagem, false);

  @override
  String toString() {
    return mensagem;
  }
}
