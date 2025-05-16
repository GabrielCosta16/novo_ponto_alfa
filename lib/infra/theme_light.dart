import 'package:flutter/material.dart';
import 'package:novo_ponto_alfa/infra/colors.dart';

class ThemeLight {
  final _primaryColor = const Color(0xff002844);
  final _primaryColorLight = const Color(0xff0c3d5e);
  final _primaryColorDark = MyColors.preto;
  final _backgroundColor = MyColors.branco;

  ThemeData obter() {
    TextTheme textTheme = montarTextTheme();

    return ThemeData.light().copyWith(
      textTheme: textTheme,
      colorScheme:
          const ColorScheme.light().copyWith(surface: _backgroundColor),
      primaryColor: _primaryColor,
      primaryColorDark: _primaryColorDark,
      primaryColorLight: _primaryColorLight,
      secondaryHeaderColor: Colors.red.shade800,
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor,
      ),
      dialogBackgroundColor: const Color(0xFF212121),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: MyColors.preto,
        circularTrackColor: MyColors.branco,
      ),
      primaryIconTheme: IconThemeData(
        color: Colors.red.shade800,
      ),
      iconTheme: IconThemeData(
        color: MyColors.preto,
      ),
      cardTheme: const CardTheme(
        elevation: 15,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          elevation: 8.0,
          textStyle: textTheme.bodyMedium!,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
      ),
      dividerTheme: DividerThemeData(
        color: _primaryColor.withOpacity(0.8),
      ),
    );
  }

  TextTheme montarTextTheme() {
    TextTheme tTheme = ThemeData.light().textTheme;

    TextTheme textTheme = tTheme.copyWith(
      displayMedium: tTheme.displayMedium?.copyWith(
        fontSize: 18,
        color: _primaryColorDark,
      ),
      displaySmall: tTheme.displaySmall?.copyWith(
        fontSize: 16,
        color: _primaryColorDark,
      ),
      displayLarge: tTheme.displayLarge?.copyWith(
        fontSize: 24,
        color: _primaryColorDark,
      ),
    );

    return textTheme.apply(fontFamily: "WorkSansSemiBold");
  }
}
