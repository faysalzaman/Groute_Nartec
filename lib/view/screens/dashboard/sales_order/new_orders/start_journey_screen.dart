// ignore_for_file: prefer_final_fields, avoid_print, deprecated_member_use

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/new_orders/action_screen.dart';
import 'package:http/http.dart' as http;

class StartJourneyScreen extends StatefulWidget {
  const StartJourneyScreen({
    super.key,
    required this.salesOrder,
    required this.currentLocation,
    required this.destinationLocation,
  });

  final SalesOrderModel salesOrder;
  final LatLng currentLocation;
  final LatLng destinationLocation;

  @override
  State<StartJourneyScreen> createState() => _StartJourneyScreenState();
}

class _StartJourneyScreenState extends State<StartJourneyScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  Set<Marker> _markers = {};
  bool _hasArrived = false;

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
    getPolylinePoints(widget.currentLocation, widget.destinationLocation);
  }

  void _initializeMarkers() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: widget.currentLocation,
          infoWindow: const InfoWindow(title: 'My Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: widget.destinationLocation,
          infoWindow: InfoWindow(
            title: widget.salesOrder.customer?.contactPerson ?? "Destination",
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  void getPolylinePoints(LatLng origin, LatLng destination) async {
    String apiKey = 'AIzaSyBcdPY1bQKSv0C1lQq-nYb3kBcjANsY3Fk';
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&mode=driving'
        '&alternatives=false'
        '&units=metric'
        '&language=en'
        '&optimizeWaypoints=true'
        '&key=$apiKey';

    print('url: $url');

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var decoded = json.decode(response.body);
        if (decoded['routes'].isNotEmpty) {
          // Clear previous coordinates
          polylineCoordinates = [];

          // Extract each leg and step for complete detail
          List<dynamic> legs = decoded['routes'][0]['legs'];
          for (var leg in legs) {
            List<dynamic> steps = leg['steps'];
            for (var step in steps) {
              String points = step['polyline']['points'];
              List<LatLng> stepPoints = _decodePolyline(points);
              polylineCoordinates.addAll(stepPoints);
            }
          }

          // Extract the duration (in seconds) from the API response
          int durationInSeconds =
              decoded['routes'][0]['legs'][0]['duration']['value'];

          // Calculate the estimated time of arrival
          DateTime now = DateTime.now();
          DateTime eta = now.add(Duration(seconds: durationInSeconds));

          // Format the ETA
          String formattedEta =
              '${eta.hour}:${eta.minute.toString().padLeft(2, '0')}';
          print('ETA: $formattedEta');

          setState(() {
            _polylines.clear();
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                color: AppColors.primaryBlue,
                points: polylineCoordinates,
                width: 5,
                jointType: JointType.mitered,
                geodesic: true,
                endCap: Cap.roundCap,
                startCap: Cap.roundCap,
                visible: true,
                zIndex: 1,
              ),
            );
          });
        }
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
    }
    return points;
  }

  Future<void> _updateArrivalStatus() async {
    try {
      // Get current date
      final _ = DateTime.now();

      // Show loading indicator
      setState(() {
        _hasArrived = true;
      });

      // Here you would add the actual API call to update the journey status
      // For example:
      // await _salesCubit.updateJourneyStatus(
      //   widget.salesOrder.id!,
      //   {
      //     'arrivalTime': now.toIso8601String()
      //   }
      // );

      // Show success message
      if (mounted) {
        AppNavigator.pushReplacement(context, ActionScreen());
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasArrived = false;
        });
        AppSnackbars.danger(
          context,
          'Failed to update arrival status: ${e.toString()}',
        );
      }
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _setMapStyle() async {
    String style = '''
    [
      {
        "featureType": "road",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#f5f5f5"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#e0e0e0"
          }
        ]
      }
    ]
    ''';
    _mapController?.setMapStyle(style);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text('Journey'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBar:
          !_hasArrived
              ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.error,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Delivery Address',
                                style: TextStyle(
                                  color: AppColors.grey600,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.salesOrder.customer?.address ??
                                    'No address provided',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.gps_fixed,
                                color: AppColors.error,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Coordinates',
                                      style: TextStyle(
                                        color: AppColors.grey600,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${widget.destinationLocation.latitude}, ${widget.destinationLocation.longitude}',
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.error,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _hasArrived ? null : _updateArrivalStatus,
                          icon:
                              _hasArrived
                                  ? null
                                  : const Icon(
                                    Icons.check_circle_outline,
                                    size: 20,
                                  ),
                          label:
                              _hasArrived
                                  ? const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.white,
                                    ),
                                  )
                                  : const Text(
                                    'Arrived ?',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
              : null,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.currentLocation,
              zoom: 15,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) {
              _mapController = controller;
              // Apply custom map style
              _setMapStyle();
            },
            polylines: _polylines,
          ),
        ],
      ),
    );
  }
}
