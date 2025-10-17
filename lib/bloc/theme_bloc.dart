import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<ToggleDarkModeEvent>((event, emit) {
      bool newDarkMode = !state.isDarkMode;
      ThemeData newThemeData =
          newDarkMode
              ? ThemeState.buildDarkTheme(state.buttonColor, state.fontType)
              : ThemeState.buildLightTheme(state.buttonColor, state.fontType);

      emit(state.copyWith(isDarkMode: newDarkMode, themeData: newThemeData));
    });

    on<ChangeFontEvent>((event, emit) {
      ThemeData newThemeData =
          state.isDarkMode
              ? ThemeState.buildDarkTheme(state.buttonColor, event.fontType)
              : ThemeState.buildLightTheme(state.buttonColor, event.fontType);

      emit(state.copyWith(fontType: event.fontType, themeData: newThemeData));
    });

    on<ChangeButtonColorEvent>((event, emit) {
      ThemeData newThemeData =
          state.isDarkMode
              ? ThemeState.buildDarkTheme(event.buttonColor, state.fontType)
              : ThemeState.buildLightTheme(event.buttonColor, state.fontType);

      emit(
        state.copyWith(buttonColor: event.buttonColor, themeData: newThemeData),
      );
    });

    on<ResetThemeEvent>((event, emit) {
      emit(ThemeState.initial());
    });
  }
}
