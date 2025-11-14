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
  GoogleMapController? _mapController;
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

  // ------------------------------------------------------------
  // MARKERS
  // ------------------------------------------------------------
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

  // ------------------------------------------------------------
  // POLYLINES (ROUTE DRAWING)
  // ------------------------------------------------------------
  Future<void> _setPolylines() async {
    if (widget.destinations.length < 2) return;

    polylineCoordinates.clear();

    final origin = widget.destinations.first;
    final destination = widget.destinations.last;

    // Waypoints: intermediate stops
    final waypoints = widget.destinations
        .sublist(1, widget.destinations.length - 1)
        .map((p) => '${p.latitude},${p.longitude}')
        .join('|');

    final url = Uri.parse(
      'https://routes.googleapis.com/directions/v2:computeRoutes',
    );

    final requestBody = {
      "origin": {
        "location": {
          "latLng": {
            "latitude": origin.latitude,
            "longitude": origin.longitude,
          },
        },
      },
      "destination": {
        "location": {
          "latLng": {
            "latitude": destination.latitude,
            "longitude": destination.longitude,
          },
        },
      },
      if (waypoints.isNotEmpty)
        "intermediates": widget.destinations
            .sublist(1, widget.destinations.length - 1)
            .map(
              (p) => {
                "location": {
                  "latLng": {"latitude": p.latitude, "longitude": p.longitude},
                },
              },
            )
            .toList(),
      "travelMode": "DRIVE",
      "polylineQuality": "HIGH_QUALITY",
    };

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": googleApiKey,
        "X-Goog-FieldMask":
            "routes.polyline.encodedPolyline,routes.distanceMeters,routes.duration",
      },
      body: jsonEncode(requestBody),
    );

    final data = jsonDecode(response.body);

    if (data["routes"] != null && data["routes"].isNotEmpty) {
      final encoded = data["routes"][0]["polyline"]["encodedPolyline"];
      final decodedPoints = PolylinePoints.decodePolyline(encoded);

      polylineCoordinates = decodedPoints
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();

      setState(() {
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: polylineCoordinates,
          ),
        );
      });

      // Fit camera to the full polyline
      _fitCameraToPolyline();
    } else {
      print("Route API error: $data");
    }
  }

  // ------------------------------------------------------------
  // CAMERA FITTING
  // ------------------------------------------------------------

  /// Fit camera to cover all markers
  void _fitCameraToMarkers() {
    if (_mapController == null || widget.destinations.isEmpty) return;

    double minLat = widget.destinations.first.latitude;
    double maxLat = widget.destinations.first.latitude;
    double minLng = widget.destinations.first.longitude;
    double maxLng = widget.destinations.first.longitude;

    for (var p in widget.destinations) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
    });
  }

  /// Fit camera to the drawn polyline
  void _fitCameraToPolyline() {
    if (_mapController == null || polylineCoordinates.isEmpty) return;

    double minLat = polylineCoordinates.first.latitude;
    double maxLat = polylineCoordinates.first.latitude;
    double minLng = polylineCoordinates.first.longitude;
    double maxLng = polylineCoordinates.first.longitude;

    for (var p in polylineCoordinates) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
    });
  }

  // ------------------------------------------------------------
  // WIDGET
  // ------------------------------------------------------------
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
        onMapCreated: (controller) {
          _mapController = controller;
          _fitCameraToMarkers(); // zoom immediately when map loads
        },
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
