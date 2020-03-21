import 'package:buscador_produtos/shared/styles.dart';
import 'package:buscador_produtos/view/home.dart';
import 'package:buscador_produtos/view/products_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(Styles.getSystemUiTheme());

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Styles.getThemeData(context),
      routes: {
        '/products-list': (context) => ProductsList(),
      },
      home: Home(),
    );
  }
}
