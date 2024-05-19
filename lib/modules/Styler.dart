import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Styler {
  Color primaryColor = Color(0xFFFF4500); // OrangeRed
  Color secondaryColor = Color(0xFF00BFFF); // DeepSkyBlue
  Color backgroundColor = Color(0xFFFFFFFF); // White
  Color lightGreyBackgroundColor = Color(0xFFF5F5F5); // Light Grey
  Color textColor = Color(0xFF000000); // Black
  Color errorColor = Color(0xFFB00020); // Red
  Color accentColor = Color(0xFF00CED1); // Gold
  late ThemeData themeData;

  Styler() {
    themeData = ThemeData(
      primaryColor: primaryColor,
      hintColor: secondaryColor,
      scaffoldBackgroundColor: lightGreyBackgroundColor,
      errorColor: errorColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: accentColor,
        background: backgroundColor,
      ),
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: textColor),
        bodyLarge: TextStyle(color: textColor, fontSize: 18),
        headlineLarge: TextStyle(
            color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(
            color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      appBarTheme: AppBarTheme(
        color: primaryColor,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondaryColor,
      ),
    );
  }
//general
  void showSnackBar(String title, String message) => Get.snackbar(title, message,
      backgroundColor: themeData.primaryColor,
      colorText: themeData.colorScheme.background,
      borderRadius: 10,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      duration: Duration(seconds: 3),
      icon: Icon(
        Icons.error_outline,
        color: themeData.colorScheme.background,
      ),
      snackStyle: SnackStyle.FLOATING,
      overlayBlur: 0.2,
      overlayColor: Colors.black.withOpacity(0.3),
      barBlur: 10,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      showProgressIndicator: true);

  AlertDialog returnDialog({required String title,required Widget content, required List<Widget> actions})=>AlertDialog(
    title: Text(title),
    backgroundColor: Get.theme.dialogBackgroundColor, // Background color of the dialog
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Rounded corners
    ),

    content: content,
    actions: actions,

  );

  void showDialog({required String title,required Widget content, required List<Widget> actions}) =>Get.dialog(
      returnDialog(title: title, content: content, actions: actions));

  void showDialogUnRemoved({required String title,required Widget content, required List<Widget> actions})
  {
    Get.dialog(barrierDismissible: false,PopScope(canPop:false,child: returnDialog(title: title, content: content, actions: actions)));
  }

  InputDecoration inputFormTextFieldDecoration(String labelText) => InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(
        color: themeData.colorScheme.secondary,
        fontSize: themeData.textTheme.bodyLarge?.fontSize),
    filled: true,
    fillColor: Colors.white.withOpacity(0.8),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );

  ButtonStyle dialogButtonStyle() => ElevatedButton.styleFrom(
    backgroundColor: Get.theme.colorScheme.background,
  );
  TextStyle inputTextStyle() => TextStyle(color: textColor);

  BoxDecoration orangeBlueBackground() => BoxDecoration(
    gradient: LinearGradient(
      colors: [
        themeData.primaryColor.withOpacity(0.8),
        themeData.hintColor.withOpacity(0.8)
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  //Respondent
  BottomNavigationBar bottomNavigationBar(
      { required List<BottomNavigationBarItem> items,
        required int currentIndex,
        required void Function(int) onTap})
  => BottomNavigationBar(

    selectedItemColor: primaryColor, // Set selected item color
    unselectedItemColor: textColor, // Set unselected item color
    backgroundColor: secondaryColor, // Set background color
    currentIndex: currentIndex,
    onTap: onTap,
    items: items,
  );
  ButtonStyle editButtonStyle() => ElevatedButton.styleFrom(
    primary: accentColor, // Using accent color for visibility
    onPrimary: backgroundColor, // Text color
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  );

  InputDecoration inputDecoration(String labelText) => InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(color: primaryColor),
    filled: true,
    fillColor: Colors.white.withOpacity(0.8),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: primaryColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: primaryColor, width: 2.0),
    ),
  );

  ButtonStyle elevatedButtonStyle() => ElevatedButton.styleFrom(
    primary: primaryColor,
    onPrimary: backgroundColor,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );

  ButtonStyle textButtonStyle() => TextButton.styleFrom(
    primary: primaryColor,
    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  );

  TextStyle labelTextStyle() => TextStyle(
    color: primaryColor,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  BoxDecoration containerDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(0, 3),
      ),
    ],
  );

  BoxDecoration cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3),
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(0, 3),
      ),
    ],
  );

  TextStyle columnHeaderStyle() => TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: textColor,
  );

  InputBorder outlineInputBorder() => OutlineInputBorder(
    borderSide: BorderSide(color: textColor), // Customize border color
    borderRadius: BorderRadius.circular(8.0),
  );

  InputDecoration dropdownDecoration(String labelText) => InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(
      color: textColor,
    ),
    border: outlineInputBorder(),
    enabledBorder: outlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor), // Customize focused border color
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  InputDecoration searchFieldDecoration(String labelText) => InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(
      color: textColor,
    ),
    prefixIcon: Icon(Icons.search, color: textColor), // Customize search icon color
    border: outlineInputBorder(),
    enabledBorder: outlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor), // Customize focused border color
      borderRadius: BorderRadius.circular(8.0),
    ),
  );
}
