import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF8D40FF);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color appbar = Colors.black;
  static const Color background = Colors.black;
  static const Color error = Color(0xFFB00020);

  static Color unselectedItemColor = Colors.white.withOpacity(0.5);
  static const Color primaryBackground = Colors.transparent;
  static const Color selectedBottomItemColor = Colors.white;
  static const Color selectedItemColor = Colors.white;
  static const Color backgroundFilterTextField = Color(0xff262626);
  static Color focusedBorderTextField = Colors.white.withOpacity(0.3);

  static const Color textPrimary = Colors.white;
  static Color textSecondary = Colors.white.withOpacity(0.5);
  static Color filterTextField = Colors.white.withOpacity(0.5);

  static const Color iconPrimary = Colors.white;
  static Color iconSecondary = Colors.white.withOpacity(0.5);
}

class AppTextStyles {
  static const TextStyle headline = TextStyle(
    fontSize: 30,
    fontFamily: "Helvetica",
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.41,
    height: 1,
  );

  static const TextStyle headline1 = TextStyle(
    fontSize: 18,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: -0.41,
    height: 1.22,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 22,
    fontFamily: "Helvetica",
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.41,
    height: 0.9,
  );

  static const TextStyle buttonTextField = TextStyle(
    fontSize: 16,
    fontFamily: "Helvetica",
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyText1 = TextStyle(
    fontSize: 14,
    fontFamily: "Helvetica",
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: -0.41,
    height: 1.22,
  );

  static TextStyle bodyText2 = TextStyle(
      fontSize: 12,
      fontFamily: "Helvetica",
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      letterSpacing: -0.41,
      // height: 1.22,
      height: 1);

  static TextStyle timePlayer = TextStyle(
    fontSize: 12,
    fontFamily: "Helvetica",
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: -0.41,
    height: 1.83,
  );

  static TextStyle bodyPrice1 = TextStyle(
    fontSize: 16,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: -0.41,
    height: 1.22,
  );
  static const TextStyle bodyPrice2 = TextStyle(
    fontSize: 12,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
    letterSpacing: -0.41,
  );

  static const TextStyle bodyAppbar = TextStyle(
    fontSize: 18,
    fontFamily: "Helvetica",
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.41,
    height: 0.72,
  );

  static TextStyle filterTextField = TextStyle(
    fontSize: 18,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w400,
    color: AppColors.filterTextField,
    letterSpacing: -0.41,
    height: 0.63,
  );
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.headline1,
      bodyLarge: AppTextStyles.bodyText1,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      elevation: 0,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.primary,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: Color(0xFF121212),
      error: AppColors.error,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.headline1.copyWith(color: Colors.white),
      bodyLarge: AppTextStyles.bodyText1.copyWith(color: Colors.white),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.all(
          Colors.white,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      elevation: 0,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.primary,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
