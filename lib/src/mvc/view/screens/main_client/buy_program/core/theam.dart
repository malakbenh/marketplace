import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData themeData() {
    return ThemeData(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: Color.fromARGB(255, 201, 199, 199)),
        prefixIconColor: Colors.grey[400],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF8F8F8)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 1.0),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFF8F8F8)),
          borderRadius: BorderRadius.circular(20),
        ),
        fillColor: const Color(0xFFF8F8F8), // Add this line
        filled: true,
        errorStyle: const TextStyle(
            height:
                0.5), // This increases the space between the error text and the TextFormField
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 250, 57, 43), // Use the error color
            width: 1.0,
            // Use the errorBorderSize property
          ),
        ),
      ),
    );
  }
}
