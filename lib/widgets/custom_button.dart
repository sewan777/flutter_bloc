import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme_bloc.dart';
import '../bloc/theme_state.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? customColor;
  final TextStyle? customTextStyle;
  final IconData? icon;
  final MainAxisAlignment iconAlignment;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.customColor,
    this.customTextStyle,
    this.icon,
    this.iconAlignment = MainAxisAlignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        Color buttonColor = customColor ?? themeState.buttonColor;
        TextStyle textStyle =
            customTextStyle ??
            ThemeState.getFontStyle(themeState.fontType, Colors.white);

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
          ),
          onPressed: onPressed,
          child:
              icon != null
                  ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: iconAlignment,
                    children: [
                      Icon(icon),
                      SizedBox(width: 8),
                      Text(text, style: textStyle),
                    ],
                  )
                  : Text(text, style: textStyle),
        );
      },
    );
  }
}
