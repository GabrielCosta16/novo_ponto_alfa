
import 'package:novo_ponto_alfa/infra/core/exceptions/custom_exception.dart';

class ConexaoInternetExcetion extends CustomException {
  @override
  late String mensagem;

  ConexaoInternetExcetion(this.mensagem)
      : super(mensagem, false);

  @override
  String toString() {
    return mensagem;
  }
}
