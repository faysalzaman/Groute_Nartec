import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/models/sales_order.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class NewOrdersMapScreen extends StatefulWidget {
  // Pass the sales order location to this screen
  final LatLng salesOrderLocation;
  final SalesOrderModel salesOrder;

  const NewOrdersMapScreen({
    super.key,
    required this.salesOrderLocation,
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
  StreamSubscription<loc.LocationData>? _locationSubscription;

  // Default camera position (e.g., center of a region)
  // You might want to adjust this or remove it if you always center on locations
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962), // Example: Googleplex
    zoom: 12.0,
  );

  @override
  void initState() {
    super.initState();
    _requestPermissionAndGetLocation();
  }

  @override
  void dispose() {
    _locationSubscription
        ?.cancel(); // Important to cancel the stream subscription
    super.dispose();
  }

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
          return; // Stop if service is not enabled
        }
      }

      // 3. Get Current Location & Start Listening
      try {
        _currentLocation = await _locationService.getLocation();
        _updateMap(); // Update map with initial location

        // Listen for location changes
        _locationSubscription = _locationService.onLocationChanged.listen((
          loc.LocationData result,
        ) {
          if (mounted) {
            // Check if the widget is still mounted before updating state
            setState(() {
              _currentLocation = result;
            });
            _updateMap(); // Update map whenever location changes
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
      // Optionally offer to open settings
      // openAppSettings();
    }
  }

  void _updateMap() {
    if (_currentLocation == null || !mounted) return;

    final LatLng currentLatLng = LatLng(
      _currentLocation!.latitude!,
      _currentLocation!.longitude!,
    );

    setState(() {
      // Clear previous markers and polylines
      _markers.clear();
      _polylines.clear();

      // Add marker for current location
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: currentLatLng,
          infoWindow: const InfoWindow(title: 'My Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ), // Blue marker
        ),
      );

      // Add marker for sales order location
      _markers.add(
        Marker(
          markerId: const MarkerId('salesOrderLocation'),
          position: widget.salesOrderLocation,
          infoWindow: InfoWindow(
            title: "${widget.salesOrder.customer?.contactPerson}",
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ), // Red marker
        ),
      );

      // Add polyline between the two locations
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [currentLatLng, widget.salesOrderLocation],
          color: Colors.blueAccent,
          width: 5, // Line width
        ),
      );
    });

    // Move camera to fit both markers if controller is ready
    if (_controller.isCompleted) {
      _moveCameraToFit(currentLatLng, widget.salesOrderLocation);
    }
  }

  // Function to animate camera to show both points
  Future<void> _moveCameraToFit(LatLng pos1, LatLng pos2) async {
    try {
      final GoogleMapController controller = await _controller.future;
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

      controller.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 60.0), // 60.0 padding
      );
    } catch (e) {
      print(
        "Error moving camera: $e",
      ); // Handle error if controller is not ready etc.
    }
  }

  // Helper to show error dialogs
  void _showErrorDialog(String message) {
    if (!mounted) return; // Check if the widget is still in the tree
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
      appBar: AppBar(
        title: const Text('Order Route Map'),
        actions: [
          // Optional: Add a button to re-center or refresh location
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: 'Center Map / Refresh Location',
            onPressed: _requestPermissionAndGetLocation,
          ),
        ],
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          if (!_controller.isCompleted) {
            _controller.complete(controller);
          }
          // If location was fetched before map was ready, update now
          if (_currentLocation != null) {
            _updateMap();
          }
        },
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled:
            false, // Disable default blue dot (using custom marker)
        myLocationButtonEnabled: false, // Disable default location button
        zoomControlsEnabled: true, // Show zoom controls
      ),
    );
  }
}

// --- Example of how to navigate to this screen ---
/*
void navigateToMap(BuildContext context, LatLng orderLocation, String clientName) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NewOrdersMapScreen(
        // Replace with actual sales order coordinates from your data
        salesOrderLocation: orderLocation, // e.g., LatLng(34.0522, -118.2437)
        clientName: clientName,           // e.g., 'Client ABC Inc.'
      ),
    ),
  );
}
*/
