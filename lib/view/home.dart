import 'package:buscador_produtos/shared/localization.dart';
import 'package:buscador_produtos/widgets/loader.dart';
import 'package:buscador_produtos/view/login_store.dart';
import 'package:buscador_produtos/view/products_list.dart';
import 'package:buscador_produtos/widgets/carousel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: new Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.apps),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginStore()));
              },
            ),
            body: FutureBuilder(
              future: new Localization().getInitialLocation(),
              builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.connectionState.index ==
                        ConnectionState.none.index ||
                    snapshot.data == null) {
                  return Loader();
                }

               

                final CameraPosition _kGooglePlex = CameraPosition(
                  target: LatLng(
                      snapshot.data['latitude'], snapshot.data['longitude']),
                  zoom: 16.4746,
                );

                return GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  myLocationEnabled: true,
                  markers: getMapMarkers(
                      snapshot.data['latitude'], snapshot.data['longitude']),
                  onMapCreated: (GoogleMapController controller) {},
                );
              },
            )));
  }

  Set<Marker> getMapMarkers(double latitude, double longitude) {
    List<Marker> listMarkers = List();

    listMarkers.add(Marker(
        markerId: MarkerId('1'),
        position: LatLng(latitude, longitude),
        icon: BitmapDescriptor.defaultMarker,
        onTap: openBottomSheet));

    return listMarkers.toSet();
  }

  void openBottomSheet() {
    showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return FractionallySizedBox(
              heightFactor: 0.8,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Principais Produtos',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Carousel(),
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                      child: Text('Ver todos os produtos',
                          style: TextStyle(color: Colors.white)),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProductsList()));
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Zaira Alves',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Endereço: Rua Presidente Afonso Pena'),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Telefone: (51) 99826-2899'),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              'Atendimento: 09:00 às 12:00 e das 14:00 às 19:00'),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Sábado: 09:00 às 14:00'),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ));
        });
  }
}
