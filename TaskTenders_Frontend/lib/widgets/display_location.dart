import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:tasktender_frontend/utils/app.theme.dart';

class DisplayLocation extends StatefulWidget {
  final LatLng selectedPoint;
  final double? height;
  final double borderRadius;

  const DisplayLocation(
      {super.key,
      required this.selectedPoint,
      this.height,
      this.borderRadius = 20});

  @override
  State<DisplayLocation> createState() => _DisplayLocationState();
}

class _DisplayLocationState extends State<DisplayLocation> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation; // Stores user’s current location
  String _pickedAddress = "Tap on the map to select a location";
  bool _loading = true; // Loading state for initial location
  bool _mapReady = false; // Ensures map is ready before calling move()

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Get user’s current location on startup
    _getAddress(); // Get address of selected point
  }

  /// **Get User's Current Location**
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    geo.LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

    // Request location permission
    permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        print("Location permissions are denied.");
        return;
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
      return;
    }

    // Get current position
    geo.Position position = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high);

    if (mounted) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        print(_currentLocation);
        _loading = false;
      });
    }

    // Move the map only if it's already built
    if (_mapReady && _currentLocation != null) {
      _mapController.move(_currentLocation!, 15.0);
    }
  }

  /// **Reverse Geocode to Get Address**
  Future<void> _getAddress() async {
    final position = widget.selectedPoint;
    final url = Uri.parse(
        "https://nominatim.openstreetmap.org/reverse?lat=${position.latitude}&lon=${position.longitude}&format=json");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (mounted) {
        setState(() {
          // _pickedAddress = data["address"]['village'] ?? "Address not found";
          _pickedAddress = data["display_name"] ?? "Address not found";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return ClipRRect(
        borderRadius:
            BorderRadius.circular(widget.borderRadius), // Set border radius
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .extension<CustomThemeExtension>()
                  ?.listItemBackground,
              borderRadius:
                  BorderRadius.all(Radius.circular(widget.borderRadius)),
            ),
            height: widget.height,
            child: _loading
                ? Center(
                    child: CircularProgressIndicator()) // Show loading spinner
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _pickedAddress,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: widget.selectedPoint,
                            initialZoom: 15.0,
                            interactionOptions: InteractionOptions(
                              flags: InteractiveFlag.all &
                                  ~InteractiveFlag.rotate, // Disable rotation
                            ),
                            onMapReady: () {
                              // Ensure map is ready before calling move()
                              if (mounted) {
                                setState(() {
                                  _mapReady = true;
                                });
                              }

                              // if (_currentLocation != null) {
                              //   _mapController.move(_currentLocation!, 15.0);
                              // }
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: isDarkMode
                                  ? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png" // Dark Theme
                                  : "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: ['a', 'b', 'c'],
                            ),
                            if (_currentLocation != null)
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: _currentLocation!,
                                    width: 80,
                                    height: 80,
                                    child: Icon(Icons.my_location,
                                        color: Colors.blue, size: 40),
                                  ),
                                ],
                              ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: widget.selectedPoint,
                                  width: 80,
                                  height: 80,
                                  child: Icon(Icons.location_pin,
                                      color: Colors.red, size: 40),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )));
  }
}
