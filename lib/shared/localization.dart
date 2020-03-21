import 'dart:async';
import 'package:geolocator/geolocator.dart';

class Localization {
  Future<Map<String, double>> getInitialLocation() async {
 
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);

      return {
        'latitude': position.latitude,
        'longitude': position.longitude
      };
    } catch (ex) {
      print(ex.toString());

      return null;
    }
  }
}
