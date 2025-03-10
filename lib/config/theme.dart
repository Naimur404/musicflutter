import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Primary color palette
const Color primaryColor = Color(0xFF6C63FF);
const Color primaryLightColor = Color(0xFF9D97FF);
const Color primaryDarkColor = Color(0xFF4A3FCB);

// Secondary color palette
const Color secondaryColor = Color(0xFFFF6584);
const Color secondaryLightColor = Color(0xFFFF9BB3);
const Color secondaryDarkColor = Color(0xFFD8325F);

// Background colors
const Color backgroundColor = Color(0xFF121212);
const Color surfaceColor = Color(0xFF1E1E1E);
const Color cardColor = Color(0xFF252525);

// Text colors
const Color primaryTextColor = Color(0xFFFFFFFF);
const Color secondaryTextColor = Color(0xFFB3B3B3);
const Color disabledTextColor = Color(0xFF757575);

// App theme
final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: backgroundColor,
  cardColor: cardColor,
  colorScheme: const ColorScheme.dark(
    primary: primaryColor,
    primaryContainer: primaryDarkColor,
    secondary: secondaryColor,
    secondaryContainer: secondaryDarkColor,
    surface: surfaceColor,
    background: backgroundColor,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(
    const TextTheme(
      displayLarge: TextStyle(
        color: primaryTextColor,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: primaryTextColor,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: primaryTextColor,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: primaryTextColor,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: primaryTextColor,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: primaryTextColor,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: primaryTextColor,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        color: secondaryTextColor,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: primaryTextColor,
      ),
      bodyMedium: TextStyle(
        color: secondaryTextColor,
      ),
      bodySmall: TextStyle(
        color: disabledTextColor,
      ),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: backgroundColor,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: primaryTextColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: primaryTextColor,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: backgroundColor,
    selectedItemColor: primaryColor,
    unselectedItemColor: secondaryTextColor,
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    showUnselectedLabels: true,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: backgroundColor,
    indicatorColor: primaryColor.withOpacity(0.2),
    labelTextStyle: MaterialStateProperty.all(
      const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: primaryColor,
    inactiveTrackColor: primaryColor.withOpacity(0.3),
    thumbColor: primaryColor,
    trackHeight: 4.0,
    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
    overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: primaryTextColor,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
  ),
  cardTheme: CardTheme(
    color: cardColor,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: surfaceColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: const TextStyle(color: secondaryTextColor),
    prefixIconColor: secondaryTextColor,
    suffixIconColor: secondaryTextColor,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: surfaceColor,
    contentTextStyle: const TextStyle(color: primaryTextColor),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: primaryColor,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return primaryColor;
      }
      return null;
    }),
    trackColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return primaryColor.withOpacity(0.5);
      }
      return null;
    }),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: surfaceColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
  ),
);