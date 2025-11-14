import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:tripora/core/utils/constants.dart';

class MapScreen extends StatefulWidget {
  final List<LatLng> destinations; // first = origin, last = destination

  const MapScreen({super.key, required this.destinations});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];

  final String googleApiKey = mapApiKey;

  @override
  void initState() {
    super.initState();
    _setMarkers();
    _setPolylines();
  }

  void _setMarkers() {
    for (int i = 0; i < widget.destinations.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('marker_$i'),
          position: widget.destinations[i],
          infoWindow: InfoWindow(title: 'Destination ${i + 1}'),
        ),
      );
    }
  }

  Future<void> _setPolylines() async {
    if (widget.destinations.length < 2) return;

    polylineCoordinates.clear();

    final origin = widget.destinations.first;
    final destination = widget.destinations.last;

    // Waypoints: all intermediate destinations
    final waypoints = widget.destinations
        .sublist(1, widget.destinations.length - 1)
        .map((p) => '${p.latitude},${p.longitude}')
        .join('|');

    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '${waypoints.isNotEmpty ? '&waypoints=optimize:true|$waypoints' : ''}'
        '&key=$googleApiKey';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      final points = data['routes'][0]['overview_polyline']['points'];
      final decodedPoints = PolylinePoints.decodePolyline(points);

      polylineCoordinates = decodedPoints
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();

      setState(() {
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            color: Theme.of(context).primaryColor,
            width: 5,
            points: polylineCoordinates,
          ),
        );
      });
    } else {
      print('Directions API error: ${data['status']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.destinations.first,
          zoom: 12,
        ),
        markers: _markers,
        polylines: _polylines,
        onMapCreated: (controller) => _mapController = controller,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        rotateGesturesEnabled: true,
        tiltGesturesEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
