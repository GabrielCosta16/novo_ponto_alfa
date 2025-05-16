class CustomException implements Exception {
  late String mensagem;
  late bool isFatal;

  CustomException(this.mensagem, this.isFatal);

  @override
  String toString() {
    return mensagem;
  }
}
