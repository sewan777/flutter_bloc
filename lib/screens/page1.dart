import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme_bloc.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Scaffold(
          appBar: AppBar(title: const Text('Welcome'), elevation: 0),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  // Title
                  Text(
                    'Welcome to TODO App',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                 
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: themeState.buttonColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: themeState.buttonColor,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      'App by: Sewan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: themeState.buttonColor,
                      ),
                    ),
                  ),

                  SizedBox(height: 40),

                  
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Theme Settings',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),

                          // Dark Mode Toggle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Dark Mode', style: TextStyle(fontSize: 16)),
                              Switch(
                                value: themeState.isDarkMode,
                                onChanged: (_) {
                                  context.read<ThemeBloc>().add(
                                    ToggleDarkModeEvent(),
                                  );
                                },
                                activeColor: themeState.buttonColor,
                              ),
                            ],
                          ),

                          SizedBox(height: 20),

                          // Font Size Selection
                          Text('Font Size', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            children:
                                ['small', 'default', 'large']
                                    .map(
                                      (font) => ChoiceChip(
                                        label: Text(font),
                                        selected: themeState.fontType == font,
                                        selectedColor: themeState.buttonColor,
                                        onSelected: (selected) {
                                          if (selected) {
                                            context.read<ThemeBloc>().add(
                                              ChangeFontEvent(font),
                                            );
                                          }
                                        },
                                      ),
                                    )
                                    .toList(),
                          ),

                          SizedBox(height: 20),

                          // Button Color Selection
                          Text('Button Color', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 10),
                          Wrap(
                            spacing: 12,
                            children:
                                [
                                      Colors.blue,
                                      Colors.red,
                                      Colors.green,
                                      Colors.purple,
                                      Colors.orange,
                                      Colors.teal,
                                    ]
                                    .map(
                                      (color) => GestureDetector(
                                        onTap: () {
                                          context.read<ThemeBloc>().add(
                                            ChangeButtonColorEvent(color),
                                          );
                                        },
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: color,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color:
                                                  themeState.buttonColor ==
                                                          color
                                                      ? Colors.white
                                                      : Colors.transparent,
                                              width: 3,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),

                          SizedBox(height: 20),

                          // Reset Button
                          CustomButton(
                            text: 'Reset Theme',
                            onPressed: () {
                              context.read<ThemeBloc>().add(ResetThemeEvent());
                            },
                            customColor: Colors.grey,
                            icon: Icons.refresh,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 40),

                  // Navigation Button
                  CustomButton(
                    text: 'Go to TODO App',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    icon: Icons.arrow_forward,
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
