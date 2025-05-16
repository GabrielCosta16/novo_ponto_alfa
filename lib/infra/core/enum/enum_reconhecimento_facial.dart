import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum SecureStorage {
  tokenRF;

  Future<String> obter() async {
    final secureStorage = FlutterSecureStorage();
    switch (this) {
      case SecureStorage.tokenRF:
        return await secureStorage.read(key: "tokenRF") ?? "";
      default:
        return "";
    }
  }

  Future salvar({required String valorSalvo}) async {
    final secureStorage = FlutterSecureStorage();
    switch (this) {
      case SecureStorage.tokenRF:
        await secureStorage.write(
            key: SecureStorage.tokenRF.name, value: valorSalvo);
    }
  }

  Future invalidar() async {
    final secureStorage = FlutterSecureStorage();
    switch (this) {
      case SecureStorage.tokenRF:
        await secureStorage.delete(key: SecureStorage.tokenRF.name);
    }
  }
}
