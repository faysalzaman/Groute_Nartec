// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:groute_nartec/core/constants/app_colors.dart';

// class LocationMapWidget extends StatefulWidget {
//   final double latitude;
//   final double longitude;
//   final String markerTitle;
//   final double height;
//   final bool showControls;

//   const LocationMapWidget({
//     Key? key,
//     required this.latitude,
//     required this.longitude,
//     this.markerTitle = 'Location',
//     this.height = 300,
//     this.showControls = true,
//   }) : super(key: key);

//   @override
//   State<LocationMapWidget> createState() => _LocationMapWidgetState();
// }

// class _LocationMapWidgetState extends State<LocationMapWidget> {
//   final Completer<GoogleMapController> _mapController =
//       Completer<GoogleMapController>();
//   bool isMapLoading = true;

//   @override
//   Widget build(BuildContext context) {
//     // Create a LatLng object from the provided coordinates
//     final LatLng position = LatLng(widget.latitude, widget.longitude);

//     return Container(
//       height: widget.height,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: AppColors.grey300),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(8),
//         child: Stack(
//           children: [
//             GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: position,
//                 zoom: 15.0,
//               ),
//               markers: {
//                 Marker(
//                   markerId: const MarkerId('locationMarker'),
//                   position: position,
//                   infoWindow: InfoWindow(title: widget.markerTitle),
//                   icon: BitmapDescriptor.defaultMarkerWithHue(
//                     BitmapDescriptor.hueRed,
//                   ),
//                 ),
//               },
//               mapType: MapType.normal,
//               myLocationEnabled: false,
//               myLocationButtonEnabled: false,
//               zoomControlsEnabled: widget.showControls,
//               zoomGesturesEnabled: true,
//               compassEnabled: widget.showControls,
//               onMapCreated: (GoogleMapController controller) {
//                 if (!_mapController.isCompleted) {
//                   _mapController.complete(controller);
//                 }
//                 setState(() {
//                   isMapLoading = false;
//                 });
//               },
//             ),
//             if (isMapLoading)
//               Container(
//                 color: Colors.grey[200],
//                 child: Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       CircularProgressIndicator(color: AppColors.primaryBlue),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Loading Map...',
//                         style: TextStyle(
//                           color: AppColors.textDark,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
