import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ToggleDarkModeEvent extends ThemeEvent {}

class ChangeFontEvent extends ThemeEvent {
  final String fontType; 

  ChangeFontEvent(this.fontType);

  @override
  List<Object> get props => [fontType];
}

class ChangeButtonColorEvent extends ThemeEvent {
  final Color buttonColor;

  ChangeButtonColorEvent(this.buttonColor);

  @override
  List<Object> get props => [buttonColor];
}

class ResetThemeEvent extends ThemeEvent {}
