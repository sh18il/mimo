import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  // Define a RxBool to hold the theme state
  var isDarkMode = false.obs;

  // Method to toggle between dark and light themes
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}
