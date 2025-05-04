// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/view/screens/auth/cubit/auth_cubit.dart';
import 'package:groute_nartec/view/screens/auth/model/login_model.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/new_orders/start_journey_screen.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class NewOrdersMapScreen extends StatefulWidget {
  // Pass both locations to this screen
  final LatLng salesOrderLocation;
  final LatLng currentDeviceLocation; // Add this parameter
  final SalesOrderModel salesOrder;

  const NewOrdersMapScreen({
    super.key,
    required this.salesOrderLocation,
    required this.currentDeviceLocation, // Add this parameter
    required this.salesOrder,
  });

  @override
  State<NewOrdersMapScreen> createState() => _NewOrdersMapScreenState();
}

class _NewOrdersMapScreenState extends State<NewOrdersMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  loc.LocationData? _currentLocation;
  final loc.Location _locationService = loc.Location();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final Set<Polygon> _polygons = {}; // Added for driver's service area
  StreamSubscription<loc.LocationData>? _locationSubscription;
  final bool _isJourneyStarted = false; // Track if journey has started

  // Initial camera position will now use the currentDeviceLocation
  late CameraPosition _initialCameraPosition;

  @override
  void initState() {
    super.initState();
    // Initialize camera with current device location and a more appropriate zoom level
    _initialCameraPosition = CameraPosition(
      target: widget.currentDeviceLocation,
      zoom:
          14.0, // Decreased from 20.5 to show more area and make polygon visible
    );

    // Add initial markers without waiting for location permissions
    _addInitialMarkers();

    // Add service area polygons
    _addServiceAreaPolygons();

    // Still request permissions for continuous updates
    _requestPermissionAndGetLocation();
  }

  // New method to add service area polygons
  void _addServiceAreaPolygons() {
    final List<Coordinate> coordinate =
        context.read<AuthCubit>().driver!.route!.points!;

    // Sample polygon data for New York/New England area (similar to image)
    final List<LatLng> nyPolygonPoints =
        coordinate
            .map((coord) => LatLng(coord.latitude!, coord.longitude!))
            .toList();
    // [
    //   const LatLng(42.75, -73.80), // Northeast NY
    //   const LatLng(42.10, -74.50), // Mid-NY
    //   const LatLng(41.30, -74.70), // Southern NY
    //   const LatLng(40.60, -74.05), // NYC area
    //   const LatLng(40.90, -72.30), // Long Island
    //   const LatLng(41.30, -72.00), // Connecticut coast
    //   const LatLng(41.70, -71.40), // Rhode Island
    //   const LatLng(42.30, -71.10), // Boston area
    //   const LatLng(43.00, -71.50), // New Hampshire
    //   const LatLng(43.50, -72.50), // Vermont
    //   const LatLng(43.20, -73.40), // Back to NY
    // ];

    setState(() {
      // Add NYC/New England polygon
      _polygons.add(
        Polygon(
          polygonId: const PolygonId('nyArea'),
          points: nyPolygonPoints,
          fillColor: Colors.blue.withValues(alpha: 0.2),
          strokeColor: Colors.blue,
          strokeWidth: 2,
        ),
      );
    });
  }

  // Add a new method to set initial markers using the passed locations
  void _addInitialMarkers() {
    setState(() {
      _markers.clear();
      _polylines.clear();

      // Add marker for current device location
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: widget.currentDeviceLocation,
          infoWindow: const InfoWindow(title: 'My Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );

      // Add marker for sales order location
      _markers.add(
        Marker(
          markerId: const MarkerId('salesOrderLocation'),
          position: widget.salesOrderLocation,
          infoWindow: InfoWindow(
            title: widget.salesOrder.customer?.contactPerson ?? "Destination",
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );

      // Add polyline between the two locations
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [widget.currentDeviceLocation, widget.salesOrderLocation],
          color: Colors.blueAccent,
          width: 5,
        ),
      );
    });

    // Move camera to fit both markers once map is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.isCompleted) {
        _moveCameraToFit(
          widget.currentDeviceLocation,
          widget.salesOrderLocation,
        );
      }
    });
  }

  @override
  void dispose() {
    // Cancel location subscription
    _locationSubscription?.cancel();

    // Properly dispose of the map controller
    if (_controller.isCompleted) {
      _controller.future.then((GoogleMapController controller) {
        controller.dispose();
      });
    }

    super.dispose();
  }

  // Start the journey - begin tracking location continuously

  Future<void> _requestPermissionAndGetLocation() async {
    // 1. Request Permission
    PermissionStatus permissionStatus =
        await Permission.locationWhenInUse.request();

    if (permissionStatus.isGranted) {
      // 2. Check if Location Service is Enabled
      bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService.requestService();
        if (!serviceEnabled) {
          _showErrorDialog('Location service is disabled. Please enable it.');
          return;
        }
      }

      // 3. Get Current Location & Start Listening
      try {
        _currentLocation = await _locationService.getLocation();
        _updateMapWithCurrentLocation(); // Update with real-time location

        // Listen for location changes
        _locationSubscription = _locationService.onLocationChanged.listen((
          loc.LocationData result,
        ) {
          if (mounted) {
            setState(() {
              _currentLocation = result;
            });
            _updateMapWithCurrentLocation(); // Update with real-time location
          }
        });
      } catch (e) {
        _showErrorDialog('Failed to get location: ${e.toString()}');
      }
    } else if (permissionStatus.isDenied) {
      _showErrorDialog(
        'Location permission is denied. The map requires this permission.',
      );
    } else if (permissionStatus.isPermanentlyDenied) {
      _showErrorDialog(
        'Location permission is permanently denied. Please enable it in app settings.',
      );
    }
  }

  // Updated method to only update the current location marker
  void _updateMapWithCurrentLocation() {
    if (_currentLocation == null || !mounted) return;

    final LatLng currentLatLng = LatLng(
      // _currentLocation!.latitude!,
      // _currentLocation!.longitude!,

      // saudi lat lng
      24.7136,
      46.6753,
    );

    setState(() {
      // Remove old current location marker
      _markers.removeWhere(
        (marker) => marker.markerId.value == 'currentLocation',
      );

      // Add updated current location marker
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: currentLatLng,
          infoWindow: const InfoWindow(title: 'My Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );

      // Update polyline to use the new current location
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [currentLatLng, widget.salesOrderLocation],
          color: Colors.blueAccent,
          width: 5,
        ),
      );
    });

    // Only follow current location if journey is started
    if (_isJourneyStarted && _controller.isCompleted) {
      _moveCamera(currentLatLng);
    }
  }

  // Move camera to current location
  Future<void> _moveCamera(LatLng position) async {
    try {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(
          position,
          20.5,
        ), // Increased to 20.5 for a very close view
      );
    } catch (e) {
      print("Error moving camera: $e");
    }
  }

  // Function to animate camera to show both points
  Future<void> _moveCameraToFit(LatLng pos1, LatLng pos2) async {
    try {
      final GoogleMapController controller = await _controller.future;

      // Check if service area polygon exists and has points
      if (_polygons.isNotEmpty) {
        final Polygon serviceArea = _polygons.first;
        if (serviceArea.points.isNotEmpty) {
          // Calculate bounds that include the polygon points
          double minLat = double.infinity;
          double maxLat = -double.infinity;
          double minLng = double.infinity;
          double maxLng = -double.infinity;

          for (var point in serviceArea.points) {
            minLat = minLat > point.latitude ? point.latitude : minLat;
            maxLat = maxLat < point.latitude ? point.latitude : maxLat;
            minLng = minLng > point.longitude ? point.longitude : minLng;
            maxLng = maxLng < point.longitude ? point.longitude : maxLng;
          }

          // Include the current location and destination in the bounds
          minLat = minLat > pos1.latitude ? pos1.latitude : minLat;
          maxLat = maxLat < pos1.latitude ? pos1.latitude : maxLat;
          minLng = minLng > pos1.longitude ? pos1.longitude : minLng;
          maxLng = maxLng < pos1.longitude ? pos1.longitude : maxLng;

          minLat = minLat > pos2.latitude ? pos2.latitude : minLat;
          maxLat = maxLat < pos2.latitude ? pos2.latitude : maxLat;
          minLng = minLng > pos2.longitude ? pos2.longitude : minLng;
          maxLng = maxLng < pos2.longitude ? pos2.longitude : maxLng;

          LatLngBounds bounds = LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          );

          const double padding = 100.0;
          controller.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, padding),
          );
          return;
        }
      }

      // Fallback to original behavior if no polygon or empty polygon
      // Add padding to ensure both markers are visible
      const double padding = 80.0;

      // Calculate the bounds that include both points
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          pos1.latitude < pos2.latitude ? pos1.latitude : pos2.latitude,
          pos1.longitude < pos2.longitude ? pos1.longitude : pos2.longitude,
        ),
        northeast: LatLng(
          pos1.latitude > pos2.latitude ? pos1.latitude : pos2.latitude,
          pos1.longitude > pos2.longitude ? pos1.longitude : pos2.longitude,
        ),
      );

      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, padding));
    } catch (e) {
      print("Error moving camera: $e");
    }
  }

  // Helper to show error dialogs
  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Map Error'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Order Route Map'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.my_location),
      //       tooltip: 'Show Both Locations',
      //       onPressed: () {
      //         if (_currentLocation != null) {
      //           final LatLng currentLatLng = LatLng(
      //             _currentLocation!.latitude!,
      //             _currentLocation!.longitude!,
      //           );
      //           _moveCameraToFit(currentLatLng, widget.salesOrderLocation);
      //         } else {
      //           _moveCameraToFit(
      //             widget.currentDeviceLocation,
      //             widget.salesOrderLocation,
      //           );
      //         }
      //       },
      //     ),
      //   ],
      // ),
      body: GoogleMap(
        mapType: MapType.normal,

        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          if (!_controller.isCompleted) {
            _controller.complete(controller);
            // Once map is ready, fit both markers in view
            _moveCameraToFit(
              widget.currentDeviceLocation,
              widget.salesOrderLocation,
            );
          }
        },
        markers: _markers,
        polylines: _polylines,
        zoomGesturesEnabled: true,

        polygons: _polygons, // Add the polygons to the map
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
      ),
      floatingActionButton:
          !_isJourneyStarted
              ? FloatingActionButton.extended(
                onPressed: () {
                  AppNavigator.pushReplacement(
                    context,
                    StartJourneyScreen(
                      salesOrder: widget.salesOrder,
                      // Use the latest tracked location if available, otherwise fallback to the initial one
                      currentLocation:
                          _currentLocation != null
                              ? LatLng(
                                _currentLocation!.latitude!,
                                _currentLocation!.longitude!,
                              )
                              : widget.currentDeviceLocation,
                      destinationLocation: widget.salesOrderLocation,
                    ),
                  );
                },
                icon: const Icon(Icons.navigation),
                label: const Text('Start Journey'),
                backgroundColor: Colors.green,
              )
              : FloatingActionButton(
                onPressed: () {
                  // // When journey is active, FAB will center on current location
                  // if (_currentLocation != null) {
                  //   final LatLng currentLatLng = LatLng(
                  //     _currentLocation!.latitude!,
                  //     _currentLocation!.longitude!,
                  //   );
                  //   _moveCamera(currentLatLng);
                  // }
                },
                backgroundColor: Colors.blue,
                child: const Icon(Icons.gps_fixed),
              ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.startFloat, // Add this line
    );
  }
}
