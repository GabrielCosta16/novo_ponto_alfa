abstract class CustomModel {
  int? id;

  Map<String, dynamic> toJson();

  convertJson(Map<String, dynamic> json);

  convertJsonList(List<Map<String, dynamic>> json);

  static bool tratarBoolean(dynamic value) {
    if (value == 1) {
      return true;
    }
    if (value == 'true') {
      return true;
    }
    if (value == true) {
      return true;
    }
    if (value == 'S' || value == 's') {
      return true;
    }
    if (value == '1') {
      return true;
    }

    return false;
  }
}
