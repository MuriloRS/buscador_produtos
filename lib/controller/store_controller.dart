import 'dart:typed_data';

import 'package:buscador_produtos/model/store_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:rxdart/subjects.dart';

enum StoreStatus { success, error, loading }

class StoreController {
  final List<Uint8List> files = new List();
  final _imagesController = BehaviorSubject<List<String>>();
  final _stateController = BehaviorSubject<StoreStatus>();

  Stream<List<String>> get outImages => _imagesController.stream;
  Stream<StoreStatus> get outState => _stateController.stream;

  Sink<List<String>> get inImages => _imagesController.sink;
  Sink<StoreStatus> get inState => _stateController.sink;

  @protected
  @mustCallSuper
  void dispose() {
    _imagesController.close();
    _stateController.close();
  }

  static final StoreController _singleton = StoreController._internal();

  factory StoreController() {
    return _singleton;
  }

  StoreController._internal();

  Future<DocumentSnapshot> getStoreImages(uid) async {
    return await Firestore.instance.collection("store").document(uid).get();
  }

  Future<void> setCarouselImages(
      dynamic files, String uid, bool idProductCarousel) async {
    files.forEach((f) {
      this.files.add(f);
    });

    if (idProductCarousel) {
      await this.saveStorePhotos(uid);
    }
  }

  Future<dynamic> saveStoreDetail({@required StoreModel storeModel}) async {
    try {
      await Firestore.instance
          .collection('store')
          .document(storeModel.user.uid)
          .updateData(storeModel.toMap());

      return StoreStatus.success;
    } catch (e) {
      return e;
    }
  }

  //Percorre as fotos e salva no banco de dados, no Firestore e FirebaseStorage
  //Cria um nome único que é uma string aleatória que é usada para distinguir a fotos
  Future<void> saveStorePhotos(String uid) async {
    Map<String, dynamic> _imagesUrl = new Map();
    List<String> listImages = new List();

    await Future.forEach(this.files, (f) async {
      String idPhoto = randomString(10, from: 65, to: 90);

      StorageReference ref =
          FirebaseStorage.instance.ref().child(uid + "/store/" + idPhoto);
      StorageUploadTask uploadTask = ref.putData(f);

      String downloadUrl =
          await (await uploadTask.onComplete).ref.getDownloadURL();

      listImages.add(downloadUrl);
      _imagesUrl.putIfAbsent(idPhoto, () => downloadUrl);
    });

    _imagesController.add(listImages);

    await Firestore.instance
        .collection("store")
        .document(uid)
        .setData({"images": _imagesUrl}, merge: true);
  }

  Future<void> deleteImageStore(String urlPhoto, StoreModel store) async {
    int index = 0;
    int indexPhotoDeleted;
    var newListImages = new List<String>.from(store.images);

    DocumentSnapshot snapshot = await Firestore.instance
        .collection("store")
        .document(store.user.uid)
        .get();

    Map newMapImages = snapshot.data['images'];
    String keyPhotoDeleted = "";

    (snapshot.data['images']).forEach((k, v) {
      if (v == urlPhoto) {
        keyPhotoDeleted = k;
      }
    });

    newMapImages.remove(keyPhotoDeleted);

    store.images.forEach((i) {
      if (i == urlPhoto) {
        indexPhotoDeleted = index;
      }
      index++;
    });

    newListImages.removeAt(indexPhotoDeleted);

    store.images = newListImages;

    await FirebaseStorage.instance
        .ref()
        .child(store.user.uid + "/store/" + keyPhotoDeleted)
        .delete();

    await Firestore.instance
        .collection("store")
        .document(store.user.uid)
        .updateData(
      {"images": newMapImages},
    );

    _imagesController.add(newListImages);
  }

  Future<bool> saveNewProduct(
      String uid, String name, double price, String desc) async {
    Map<String, dynamic> _imagesUrl = new Map();
    List<String> listImages = new List();

    await Future.forEach(this.files, (f) async {
      String idPhoto = randomString(10, from: 65, to: 90);

      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child(uid + "/store/" + name + "/" + idPhoto);
      StorageUploadTask uploadTask = ref.putData(f);

      String downloadUrl =
          await (await uploadTask.onComplete).ref.getDownloadURL();

      listImages.add(downloadUrl);
      _imagesUrl.putIfAbsent(idPhoto, () => downloadUrl);
    });

    await Firestore.instance
        .collection("store")
        .document(uid)
        .collection("products")
        .add({
      "name": name,
      "price": price,
      "description": desc,
      "images": _imagesUrl
    });
  }
}
