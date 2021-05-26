import 'package:comeon_flutter/directionModel.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DirectionsRepository {
  var _baseUrlGoogle = r'maps.googleapis.com';
  var _baseUrlMapBox = r'api.mapbox.com';

  final String _charactersPathGoogle = '/maps/api/directions/json';
  final String _charactersPathMapBox = '/directions/v5/mapbox/walking/';

  
  final Map<String, String> _queryParametersMapBox = <String, String>{
    'geometries':'geojson',
    'access_token':'pk.eyJ1IjoibG1paiIsImEiOiJjanhmenpudXgwNnhqM3RsOThsengxdHRxIn0.porCqvlzirmaXQRvHnI3eA',
  };


  Future<Directions> getDirectionsGoogle({
    @required LatLng origin,
    @required LatLng destination,
  }) async {

    final Map<String, String> _queryParametersGoogle = <String, String>{
    
    'origin':'${origin.latitude},${origin.longitude}',
    'destination':'${destination.latitude},${destination.longitude}',
    'key':'AIzaSyAGl2XEctD9htT6mFKXOjuejE-BLo1Q5uM',
  };

    final response = await http.get(Uri.https(_baseUrlMapBox, _charactersPathGoogle, _queryParametersGoogle));

    // Check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMapBox(json.decode(response.body));
    }
    return null;
  }


  Future<Directions> getDirectionsMapBox({
    @required LatLng origin,
    @required LatLng destination,
  }) async {
    
    var parameters =  "${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}";
    final response = await http.get(Uri.https(_baseUrlMapBox, _charactersPathMapBox + parameters, _queryParametersMapBox));

    // Check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMapBox(json.decode(response.body));
    }
    return null;
  }
}