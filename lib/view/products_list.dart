import 'package:buscador_produtos/controller/store_controller.dart';
import 'package:buscador_produtos/model/store_model.dart';
import 'package:buscador_produtos/shared/modals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsList extends StatefulWidget {
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  StoreModel user;
  StoreController controller;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<StoreModel>(context);
    controller = StoreController();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 32),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          new Modals().newProduct(context, user, controller);
        },
      ),
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Produtos",
            style: TextStyle(color: Colors.black),
          ),
          floating: true,
          pinned: true,
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                child: Center(
                    child: FlatButton(
                  child: Text("PRODUTO"),
                )),
              );
            },
          ),
        )
      ]),
    );
  }
}
