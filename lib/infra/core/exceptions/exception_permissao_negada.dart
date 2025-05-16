
import 'package:novo_ponto_alfa/infra/core/exceptions/custom_exception.dart';
import 'package:novo_ponto_alfa/infra/core/exceptions/custom_exception.dart';

class PermissaoNegadaExcetion extends CustomException {
  late String titulo;
  @override
  late String mensagem;

  PermissaoNegadaExcetion(this.titulo, this.mensagem, {bool isFatal = false})
      : super(mensagem, isFatal);

  @override
  String toString() {
    return mensagem;
  }
}
