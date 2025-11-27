import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class NearMeMap extends StatefulWidget {
  const NearMeMap({super.key});

  @override
  State<NearMeMap> createState() => _NearMeMapState();
}

class _NearMeMapState extends State<NearMeMap> {
  GoogleMapController? mapController;

  // Dummy custom locations (Replace with actual data)
  final List<Map<String, dynamic>> customLocations = [
    {"name": "Point A", "lat": 22.7433834055496, "lng": 88.4920297018341},
   
   
  ];

  Set<Marker> markers = {};
  LatLng? currentPosition;

  @override
  void initState() {
    super.initState();
    _loadMap();
  }

  Future<void> _loadMap() async {
    // Get current location
    Position position = await Geolocator.getCurrentPosition();
    currentPosition = LatLng(position.latitude, position.longitude);

    // Add custom markers
    for (var loc in customLocations) {
      markers.add(
        Marker(
          markerId: MarkerId(loc["name"]),
          position: LatLng(loc["lat"], loc["lng"]),
          infoWindow: InfoWindow(title: loc["name"]),
        ),
      );
    }

    // Add current location marker
    markers.add(
      Marker(
        markerId: const MarkerId("me"),
        position: currentPosition!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: "You are here"),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Near Me Map")),
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: currentPosition!, zoom: 15),
              markers: markers,
              onMapCreated: (controller) => mapController = controller,
            ),
    );
  }
}
