import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  int _currentIndex;
  PageController _pageController;

  BottomNavigation(this._currentIndex, this._pageController);
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      fixedColor: Theme.of(context).primaryColor,
      onTap: (index) => setState(() {
        widget._currentIndex = index;
        widget._pageController.animateToPage(index,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
      }),
      currentIndex:
          widget._currentIndex, // this will be set when a new tab is tapped
      items: [
        BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          title: new Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: new Icon(Icons.format_list_bulleted),
          title: new Text('Produtos'),
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('Conta'))
      ],
    );
  }
}
