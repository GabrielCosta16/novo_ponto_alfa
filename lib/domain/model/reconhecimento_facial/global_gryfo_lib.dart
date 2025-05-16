import 'package:flutter_gryfo_lib/flutter_gryfo_lib.dart';

class MyGlobalInstanceGryfo {
  MyGlobalInstanceGryfo._privateConstructor();

  static final MyGlobalInstanceGryfo _instance = MyGlobalInstanceGryfo._privateConstructor();

  static MyGlobalInstanceGryfo get instance => _instance;

  final FlutterGryfoLib gryfo = FlutterGryfoLib();
}
