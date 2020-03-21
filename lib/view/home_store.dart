import 'package:buscador_produtos/model/store_model.dart';
import 'package:buscador_produtos/view/detail_store.dart';
import 'package:buscador_produtos/view/products_list.dart';
import 'package:buscador_produtos/widgets/bottom_navigation.dart';
import 'package:buscador_produtos/widgets/loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class HomeStore extends StatefulWidget {
  FirebaseUser user;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  HomeStore(this.user);

  @override
  _HomeStoreState createState() => _HomeStoreState();
}

class _HomeStoreState extends State<HomeStore> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firestore.instance
          .collection("store")
          .document(widget.user.uid)
          .get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState.index == ConnectionState.none.index ||
            snapshot.connectionState.index == ConnectionState.waiting.index) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Loader(),
            ),
          );
        }

        StoreModel model = new StoreModel(user: widget.user);
        model.cidade = snapshot.data.data['cidade'];
        model.cnpj = snapshot.data.data['cnpj'];
        model.email = snapshot.data.data['email'];
        model.endereco = snapshot.data.data['endereco'];
        model.nome = snapshot.data.data['nome'];
        model.images = new List();
        if (snapshot.data.data['images'] != null) {
          (snapshot.data.data['images'] as Map).forEach((k, v) {
            model.images.add(v);
          });
        }

        return MultiProvider(
            providers: [
              ChangeNotifierProvider<StoreModel>.value(
                value: model,
              )
            ],
            child: Scaffold(
              key: widget._scaffoldKey,
              resizeToAvoidBottomPadding: true,
              bottomNavigationBar:
                  BottomNavigation(_currentIndex, _pageController),
              body: SizedBox.expand(
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: <Widget>[
                    DetailStore(false, widget.user),
                    ProductsList(),
                    Container(),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
