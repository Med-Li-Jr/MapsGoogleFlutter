import 'dart:collection';

import 'package:comeon_flutter/ApiModel.dart';
import 'package:comeon_flutter/DirectionsRepository.dart';
import 'package:comeon_flutter/directionModel.dart';
import 'package:comeon_flutter/HttpApiCall.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GMap extends StatefulWidget {
  GMap({Key key}) : super(key: key);

  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  Set<Marker> _markers = HashSet<Marker>();
  

  GoogleMapController _mapController;
  // BitmapDescriptor _markerIcon;
  static const _initialCameraPosition = CameraPosition(
    target:  LatLng(35.7651314, 10.805294),
    zoom: 15,
  );
  Position pos;
  Marker _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: _initialCameraPosition.target
  );
  Marker _destination;
  Directions _info;

@override
  void dispose() {
    // TODO: implement dispose
    _mapController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    initPositionMobile();
  }

  void initPositionMobile() async {
     pos = await Geolocator.getCurrentPosition(forceAndroidLocationManager: true);
      await Future.delayed(Duration(milliseconds: 5000));

     _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 15)));
      
      
      await Future.delayed(Duration(milliseconds: 3000));
setState(() => _origin = 
            Marker(
              markerId: const MarkerId('origin1'),
              infoWindow: const InfoWindow(title: 'origin'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              position: LatLng(pos.latitude, pos.longitude),
            ));
      // await Location.instance.getLocation().then((value) =>{
      //       _origin = null,
      //       setState(() => _origin = Marker(
      //         markerId: const MarkerId('origin1'),
      //         infoWindow: const InfoWindow(title: 'origin'),
      //         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      //         position: LatLng(value.latitude, value.longitude),
      //       ))
      // });
  }
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map')),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _initialCameraPosition,
            markers: {
              if (_origin != null) _origin,
              if (_destination != null) _destination
            },
            // polygons: _polygons,
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: _info.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
            onTap: _addMarker,
            // circles: _circles,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          
          
          
          if (_info != null)
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Text(
                  '${_info.totalDistance}, ${_info.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          
          
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
            child: Text("Coding with Curry"),
          ),
          TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  
                },
                child: Text('TextButton'),
              ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.map),
        onPressed: () {
          getDataFromApi();  
        },
      ),
    );
  }
  void getDataFromApi() async{
    
  int numberOfSecond = 0;
    while (true) {
      await Future.delayed(Duration(milliseconds: 3000));
      try{
        await HttpApiCall().getApiData().then((res) async {          
          numberOfSecond++;
          print(res);
          ApiModel modelsApi = (ApiModel.fromJson(res)); 
          print(" long : " + modelsApi.longitude.toString() + " // lat : " + modelsApi.latitude.toString());
          print(modelsApi);
          _destination = null;
          _addMarker(LatLng(double.parse(modelsApi.latitude), double.parse(modelsApi.longitude)));
          //return res;
        });
      }
      catch (e){
        print(e);
      }
      if( numberOfSecond > 7)
        break;

    }
  }
  
  
  void _addMarker(LatLng pos) async {
    if(_destination != null){
      setState(() {
        _destination = null;
        _info = null;
      });
    }
    else{
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });
      final directions = await DirectionsRepository()
          .getDirectionsMapBox(origin: _origin.position, destination: pos);
      setState(() => _info = directions);
    }
    }
}