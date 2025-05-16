
import 'package:novo_ponto_alfa/infra/core/exceptions/custom_exception.dart';

class ExceptionTratada extends CustomException {
  @override
  late String mensagem;

  ExceptionTratada(this.mensagem, {bool isFatal = false})
    : super(mensagem, isFatal);

  @override
  String toString() {
    return mensagem;
  }
}
