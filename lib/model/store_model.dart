import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StoreModel extends ChangeNotifier {
  String nome;
  String email;
  String cnpj;
  String cidade;
  String endereco;
  List<dynamic> images;
  FirebaseUser user;

  StoreModel({this.user});

  void saveStoreModel(StoreModel model) {
    this.nome = model.nome;
    this.cidade = model.cidade;
    this.cnpj = model.cnpj;
    this.email = model.email;
    this.endereco = model.endereco;
    this.images = model.images;
    notifyListeners();
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": user.uid,
      "nome": nome,
      "email": email,
      "cnpj": cnpj,
      "cidade": cidade,
      "endereco": endereco,
      "imagens": images
    };
  }

  void ofMap(
      {String email,
      String nome,
      String cnpj,
      String endereco,
      String cidade,
      FirebaseUser user}) {
    this.user = user;
    this.email = email;
    this.nome = nome;
    this.cnpj = cnpj;
    this.endereco = endereco;
    this.cidade = cidade;
  }
}
