import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  Color color;
  double size;

  Loader({this.color=Colors.grey, this.size=36});
  
  @override
  Widget build(BuildContext context) {
    if(color == Colors.grey){
      color = Theme.of(context).primaryColor;
    }

    return Center(
        child: SpinKitCircle(
          size: this.size,
      color: color,
    ));
  }
}
