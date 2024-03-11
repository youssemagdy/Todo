import 'package:flutter/material.dart';
import 'package:todo_app_1/style/app_colors.dart';

class AppTheme{
  static ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      backgroundColor: AppColors.primaryLightColor
    ),
    scaffoldBackgroundColor: AppColors.backgrundColor,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      unselectedItemColor: AppColors.unSelectedIconColor,
      selectedItemColor: AppColors.primaryLightColor,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryLightColor,
      primary: AppColors.primaryLightColor,
    ),
    useMaterial3: false,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryLightColor,
    ),
    textTheme: const TextTheme(
      titleSmall: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: AppColors.timeColor,
      ),
      titleMedium: TextStyle(
        color: AppColors.primaryLightColor,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
      labelMedium: TextStyle(
        color: AppColors.textColor,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
  static ThemeData dartTheme = ThemeData();
}