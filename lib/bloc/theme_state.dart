import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final bool isDarkMode;
  final String fontType;
  final Color buttonColor;
  final ThemeData themeData;

  const ThemeState({
    required this.isDarkMode,
    required this.fontType,
    required this.buttonColor,
    required this.themeData,
  });

  factory ThemeState.initial() {
    return ThemeState(
      isDarkMode: false,
      fontType: 'default',
      buttonColor: Colors.blue,
      themeData: buildLightTheme(Colors.blue, 'default'),
    );
  }

  ThemeState copyWith({
    bool? isDarkMode,
    String? fontType,
    Color? buttonColor,
    ThemeData? themeData,
  }) {
    return ThemeState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      fontType: fontType ?? this.fontType,
      buttonColor: buttonColor ?? this.buttonColor,
      themeData: themeData ?? this.themeData,
    );
  }

  static ThemeData buildLightTheme(Color buttonColor, String fontType) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: buttonColor,
      appBarTheme: AppBarTheme(
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: getFontStyle(fontType, Colors.white),
        ),
      ),
    );
  }

  static ThemeData buildDarkTheme(Color buttonColor, String fontType) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: buttonColor,
      scaffoldBackgroundColor: Color(0xFF1E1E1E),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF2D2D2D),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardColor: Color(0xFF2D2D2D),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: getFontStyle(fontType, Colors.white),
        ),
      ),
    );
  }

  static TextStyle getFontStyle(String fontType, Color color) {
    switch (fontType) {
      case 'large':
        return TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: color,
        );
      case 'small':
        return TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        );
      case 'default':
      default:
        return TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color,
        );
    }
  }

  @override
  List<Object> get props => [isDarkMode, fontType, buttonColor, themeData];
}
