import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum SnackbarType { success, error, info, warning }

class Styles {
  BuildContext context;
  TextStyle primaryButtonStyle;
  TextStyle outlineButtonStyle;
  TextStyle styleSnackbarText;
  Styles(this.context) {
    primaryButtonStyle = TextStyle(
        fontWeight: FontWeight.w600, color: Colors.white, fontSize: 20);
    outlineButtonStyle = TextStyle(
        fontWeight: FontWeight.w500,
        color: Theme.of(context).primaryColor,
        fontSize: 22);
    styleSnackbarText = TextStyle(
        fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16);
  }

  Color getSnackbarColor({@required SnackbarType type}) {
    switch (type) {
      case SnackbarType.success:
        return Colors.green;
        break;
      case SnackbarType.error:
        return Colors.red;
        break;
      case SnackbarType.info:
        return Colors.blue;
        break;
      case SnackbarType.warning:
        return Colors.yellow[600];
        break;
      default:
        return Colors.grey;
    }
  }

  static getThemeData(context) {
    return ThemeData(
      fontFamily: 'Oswald',
      //primaryColor: Color.fromRGBO(242, 26, 37, 1),
      primaryColor: Color.fromRGBO(82, 25, 125, 1),
     // primaryColor:Colors.indigo,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static getSystemUiTheme() {
    return SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarDividerColor: Colors.white,
      systemNavigationBarColor: Colors.white,
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    );
  }

  static getTextFieldBorder() {
    OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 5.0),
    );
  }
}
