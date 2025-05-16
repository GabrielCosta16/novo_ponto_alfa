import 'package:flutter/material.dart';
import 'package:novo_ponto_alfa/infra/colors.dart';
class ThemeDark {
  final _primaryColor = const Color(0xFF171717);
  final _primaryColorLight = Colors.grey.shade300;
  final _primaryColorDark = MyColors.preto;
  final _backgroundColor = const Color(0xFF1b1b1b);
  final _vermelho = const Color(0xFFa80000).withOpacity(0.8);

  ThemeData obter() {
    TextTheme textTheme = montarTextTheme();

    return ThemeData.dark().copyWith(
      textTheme: textTheme,
      colorScheme:
          const ColorScheme.light().copyWith(surface: _backgroundColor),
      primaryColor: _primaryColor,
      primaryColorDark: _primaryColorDark,
      primaryColorLight: _primaryColorLight,
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor,
      ),
      dialogBackgroundColor: const Color(0xFF212121),
      secondaryHeaderColor: _vermelho,
      iconTheme: IconThemeData(
        color: _primaryColorLight,
      ),
      primaryIconTheme: IconThemeData(
        color: MyColors.branco,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: MyColors.preto,
        circularTrackColor: MyColors.branco,
      ),
      cardColor: _primaryColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _vermelho,
          elevation: 8.0,
          textStyle: textTheme.displayMedium!,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
      ),
      dividerTheme: DividerThemeData(
        color: _primaryColorLight.withOpacity(0.8),
      ),
    );
  }

  TextTheme montarTextTheme() {
    TextTheme tTheme = ThemeData.dark().textTheme;

    TextTheme textTheme = tTheme.copyWith(
      displayMedium: tTheme.displayMedium?.copyWith(
        fontSize: 18,
        color: _primaryColorLight,
      ),
      displaySmall: tTheme.displayMedium?.copyWith(
        fontSize: 16,
        color: _primaryColorLight,
      ),
      displayLarge: tTheme.displayMedium?.copyWith(
        fontSize: 24,
        color: _primaryColorLight,
      ),
    );
    return textTheme.apply(fontFamily: "WorkSansSemiBold");
  }
}
