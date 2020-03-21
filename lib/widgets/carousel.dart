import 'dart:typed_data';

import 'package:buscador_produtos/controller/store_controller.dart';
import 'package:buscador_produtos/model/store_model.dart';
import 'package:buscador_produtos/shared/modals.dart';
import 'package:buscador_produtos/widgets/loader.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class Carousel extends StatefulWidget {
  StoreModel store;
  Modals modals;
  StoreController controller;
  bool idProductCarousel;
  Carousel(
      {this.store,
      this.modals,
      this.controller,
      this.idProductCarousel = false});

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Stack(
          children: <Widget>[
            isLoading
                ? Container(height: 200, child: Loader())
                : StreamBuilder(
                    stream: widget.controller.outImages,
                    builder: (context, AsyncSnapshot<List<String>> status) {
                      if (status.connectionState.index !=
                              ConnectionState.done.index &&
                          status.connectionState.index !=
                              ConnectionState.active.index) {
                        return widget.store.images.length > 0
                            ? _getCarousel(widget.store.images)
                            : emptyCarousel();
                      } else {
                        status.data.forEach((f) {
                          if (widget.store.images.indexOf(f) == -1) {
                            widget.store.images.add(f);
                          }
                        });

                        return _getCarousel(widget.store.images);
                      }
                    },
                  ),
            Positioned(
                bottom: 5,
                right: 5,
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () async {
                    setState(() => isLoading = true);

                    List<Uint8List> imagesFiles = new List();

                    List<Asset> images;

                    try {
                      images = await MultiImagePicker.pickImages(
                          maxImages: 10, enableCamera: true);
                    } catch (e) {}

                    await Future.forEach(images, (asset) async {
                      ByteData byteData = await asset.getByteData();

                      imagesFiles.add(byteData.buffer.asUint8List());
                    });

                    await widget.controller.setCarouselImages(imagesFiles,
                        widget.store.user.uid, widget.idProductCarousel);

                    setState(() => isLoading = false);
                  },
                  child: Icon(OMIcons.photoCamera),
                )),
          ],
        );
      },
    );
  }

  Widget _getCarousel(List<dynamic> storeImages) {
    return CarouselSlider(
      realPage: storeImages.length,
      height: 200.0,
      enlargeCenterPage: true,
      autoPlayAnimationDuration: Duration(milliseconds: 100),
      enableInfiniteScroll: false,
      viewportFraction: 0.6,
      aspectRatio: 0.5,
      items: storeImages.map((i) {
        return Stack(
          children: <Widget>[
            FadeIn(
              child: Image.network(i),
              curve: Curves.easeIn,
            ),
            Positioned(
                top: 0,
                right: 0,
                child: Container(
                    width: 30,
                    height: 30,
                    color: Colors.red[600],
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      tooltip: "Excluir",
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      ),
                      onPressed: () => widget.modals
                          .showModalConfirmImageDelete(
                              i, context, widget.controller, widget.store),
                    )))
          ],
        );
      }).toList(),
    );
  }

  Widget emptyCarousel() {
    return Container(
      color: Colors.grey[200],
      height: 200,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.photo,
            size: 78,
          ),
          Text("Adicione uma foto", textAlign: TextAlign.center),
        ],
      )),
    );
  }
}
