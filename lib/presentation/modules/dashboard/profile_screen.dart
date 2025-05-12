import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/constants/app_preferences.dart';
import 'package:groute_nartec/core/utils/app_navigator.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/presentation/modules/auth/cubit/auth_cubit.dart';
import 'package:groute_nartec/presentation/modules/auth/cubit/auth_state.dart';
import 'package:groute_nartec/presentation/modules/auth/models/driver_model.dart';
import 'package:groute_nartec/presentation/modules/auth/view/login_screen.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';
import 'package:groute_nartec/presentation/widgets/dialogs/nfc_enable_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isNfcEnabled = false;
  String? _nfcNumber;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNfcSettings();
  }

  Future<void> _loadNfcSettings() async {
    setState(() => _isLoading = true);
    final isEnabled = await AppPreferences.getDriverIsNFCEnabled() ?? false;
    final nfcNumber = await AppPreferences.getDriverNFCNumber();

    setState(() {
      _isNfcEnabled = isEnabled;
      _nfcNumber = nfcNumber;
      _isLoading = false;
    });
  }

  Future<void> _toggleNfcEnabled(
    bool newValue,
    BuildContext context,
    AuthCubit authCubit,
  ) async {
    // If trying to enable NFC, show dialog to scan NFC
    if (newValue) {
      // if the value is already true, just return
      if (_isNfcEnabled) return;

      // Show NFC scanning dialog
      final result = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) => NFCEnableDialog(nfcValue: newValue),
      );

      // If a serial number was obtained from the dialog
      if (result != null && result.isNotEmpty) {
        setState(() => _isLoading = true);

        try {
          // Make the API call here instead of in the dialog
          await authCubit.enableNFC("enable", true, result);

          // Update local settings
          await AppPreferences.setDriverIsNFCEnabled(true);
          await AppPreferences.setDriverNFCNumber(result);

          // Update state
          setState(() {
            _isNfcEnabled = true;
            _nfcNumber = result;
            _isLoading = false;
          });
        } catch (e) {
          // In case of error, reset the switch to false
          setState(() {
            _isNfcEnabled = false;
            _isLoading = false;
          });
          // Error handling is now done via the BlocConsumer listener
        }
      }
    } else {
      // Disabling NFC
      if (!_isNfcEnabled) return; // Already disabled

      setState(() => _isLoading = true);

      try {
        // Call API to disable NFC
        await authCubit.enableNFC("disable", false, "null");

        // Update local settings
        await AppPreferences.setDriverIsNFCEnabled(false);

        // Update state
        setState(() {
          _isNfcEnabled = false;
          _nfcNumber = null;
          _isLoading = false;
        });

        if (context.mounted) {
          AppSnackbars.success(context, 'NFC login disabled successfully');
        }
      } catch (e) {
        // If error occurs during disabling, ensure the switch stays in enabled state
        setState(() {
          _isNfcEnabled = true;
          _isLoading = false;
        });
        // Error handling is done via the BlocConsumer listener
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final driver = context.read<AuthCubit>().driver;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is EnableNfcError) {
          AppSnackbars.danger(context, state.errorMessage);
        } else if (state is EnableNfcSuccess) {
          AppSnackbars.success(context, 'NFC login enabled successfully');
        }
      },
      builder: (context, state) {
        return CustomScaffold(
          title: 'Driver Profile',
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header Card
                _buildProfileHeader(context, driver, isDarkMode),
                const SizedBox(height: 20),

                // NFC Card
                _buildNfcCard(context, isDarkMode, context.read<AuthCubit>()),
                const SizedBox(height: 20),

                // Rest of the code remains the same
                // ...existing code...

                // Route Information Section
                if (driver?.route != null) ...[
                  _buildSectionTitle('Assigned Route', isDarkMode),
                  const SizedBox(height: 10),
                  _buildRouteCard(context, driver!.route!, isDarkMode),

                  const SizedBox(height: 20),

                  // Points List Section
                  if (driver.route?.points != null &&
                      driver.route!.points!.isNotEmpty) ...[
                    _buildSectionTitle('Area', isDarkMode),
                    const SizedBox(height: 10),
                    _buildPointsCard(
                      context,
                      driver.route!.points!,
                      isDarkMode,
                    ),
                  ],
                ] else
                  _buildNoRouteAssigned(context, isDarkMode),

                // Logout Button Section
                const SizedBox(height: 30),
                _buildLogoutButton(context, isDarkMode),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    Driver? driver,
    bool isDarkMode,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? AppColors.darkBackground.withValues(alpha: 0.95)
                : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: AppColors.grey300.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
        ],
        border:
            isDarkMode
                ? Border.all(
                  color: AppColors.primaryLight.withValues(alpha: 0.2),
                )
                : null,
      ),
      child: Column(
        children: [
          // Avatar and Name Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.secondary, width: 2),
                ),
                child: Center(
                  child:
                      driver?.photo != null && driver!.photo!.isNotEmpty
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.network(
                              driver.photo!,
                              width: 76,
                              height: 76,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: AppColors.primaryBlue,
                                  ),
                            ),
                          )
                          : const Icon(
                            Icons.person,
                            size: 40,
                            color: AppColors.primaryBlue,
                          ),
                ),
              ),
              const SizedBox(width: 16),

              // Name and ID
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver?.name ?? 'Driver Name',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            isDarkMode ? AppColors.white : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${driver?.idNumber ?? 'Not Available'}',
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            isDarkMode
                                ? AppColors.grey400
                                : AppColors.textMedium,
                      ),
                    ),

                    // Experience
                    if (driver?.experience != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Experience: ${driver!.experience}',
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              isDarkMode
                                  ? AppColors.grey400
                                  : AppColors.textMedium,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Driver Details Section
          Column(
            children: [
              _buildInfoRow(
                FontAwesomeIcons.envelope,
                'Email',
                driver?.email ?? 'Not Available',
                isDarkMode,
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                FontAwesomeIcons.phone,
                'Phone',
                driver?.phone ?? 'Not Available',
                isDarkMode,
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                FontAwesomeIcons.idCard,
                'License',
                driver?.license ?? 'Not Available',
                isDarkMode,
              ),
              if (driver?.isNFCEnabled == true) ...[
                const SizedBox(height: 12),
                _buildInfoRow(
                  FontAwesomeIcons.tag,
                  'NFC Number',
                  driver?.nfcNumber ?? 'Not Available',
                  isDarkMode,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    bool isDarkMode,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDarkMode ? AppColors.primaryLight : AppColors.primaryBlue,
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppColors.grey300 : AppColors.textDark,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? AppColors.white : AppColors.textMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? AppColors.white : AppColors.textDark,
      ),
    );
  }

  Widget _buildRouteCard(BuildContext context, route, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? AppColors.darkBackground.withValues(alpha: 0.95)
                : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: AppColors.grey300.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
        ],
        border:
            isDarkMode
                ? Border.all(color: AppColors.secondary.withValues(alpha: 0.2))
                : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  FontAwesomeIcons.route,
                  color: AppColors.secondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.nameEn ?? 'Unnamed Route',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            isDarkMode ? AppColors.white : AppColors.textDark,
                      ),
                    ),
                    if (route.glnNumber != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'GLN: ${route.glnNumber}',
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              isDarkMode
                                  ? AppColors.grey400
                                  : AppColors.textMedium,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${route.points?.length ?? 0} Points',
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          if (route.descriptionEn != null &&
              route.descriptionEn!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppColors.grey300 : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              route.descriptionEn!,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? AppColors.white : AppColors.textMedium,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            'Coverage Radius:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppColors.grey300 : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${route.radius ?? 'Not specified'} meters',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? AppColors.white : AppColors.textMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsCard(
    BuildContext context,
    List<Coordinate> points,
    bool isDarkMode,
  ) {
    // Debug: Print points count to verify data

    // Filter valid points first to avoid calculations with null values
    final validPoints =
        points
            .where((point) => point.latitude != null && point.longitude != null)
            .toList();

    // Calculate center of the polygon for map camera position
    double avgLat = 0;
    double avgLng = 0;
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    // Skip calculation if no valid points
    if (validPoints.isEmpty) {
      // Return early with a message if no valid points
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isDarkMode
                  ? AppColors.darkBackground.withValues(alpha: 0.95)
                  : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (!isDarkMode)
              BoxShadow(
                color: AppColors.grey300.withValues(alpha: 0.5),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
          ],
          border:
              isDarkMode
                  ? Border.all(
                    color: AppColors.primaryLight.withValues(alpha: 0.2),
                  )
                  : null,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Route Points (${points.length})',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? AppColors.white : AppColors.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Icon(
              Icons.map_outlined,
              size: 48,
              color: isDarkMode ? AppColors.grey400 : AppColors.grey500,
            ),
            const SizedBox(height: 12),
            Text(
              'No valid coordinates found for mapping',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? AppColors.grey400 : AppColors.textMedium,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Calculate bounds for better camera positioning
    for (final point in validPoints) {
      final lat = point.latitude!;
      final lng = point.longitude!;

      avgLat += lat;
      avgLng += lng;

      // Update min/max for bounds calculation
      minLat = math.min(minLat, lat);
      maxLat = math.max(maxLat, lat);
      minLng = math.min(minLng, lng);
      maxLng = math.max(maxLng, lng);
    }

    avgLat = avgLat / validPoints.length;
    avgLng = avgLng / validPoints.length;

    // Center point of the polygon
    final center = LatLng(avgLat, avgLng);

    // Calculate appropriate zoom based on the bounds
    // This helps ensure all points are visible in the viewport
    final latDiff = maxLat - minLat;
    final lngDiff = maxLng - minLng;
    final maxDiff = math.max(latDiff, lngDiff);

    // Determine zoom level based on the difference (larger diff = lower zoom)
    double zoomLevel = 14.0; // Default zoom
    if (maxDiff > 0.1) zoomLevel = 12.0;
    if (maxDiff > 0.5) zoomLevel = 10.0;
    if (maxDiff > 1.0) zoomLevel = 8.0;

    // Create a Set of polygons for the map with improved styling
    final Set<Polygon> polygons = {
      Polygon(
        polygonId: const PolygonId('route_polygon'),
        points:
            validPoints
                .map((point) => LatLng(point.latitude!, point.longitude!))
                .toList(),
        fillColor: AppColors.primaryBlue.withValues(alpha: 0.2),
        strokeColor: AppColors.primaryBlue,
        strokeWidth: 4, // Thicker border for better visibility
        geodesic:
            true, // Follow the curvature of the earth for more accurate representation
      ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? AppColors.darkBackground.withValues(alpha: 0.95)
                : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: AppColors.grey300.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
        ],
        border:
            isDarkMode
                ? Border.all(
                  color: AppColors.primaryLight.withValues(alpha: 0.2),
                )
                : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Route Map (${validPoints.length} Points)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? AppColors.white : AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Google Map with polygon visualization
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    isDarkMode
                        ? AppColors.primaryLight.withValues(alpha: 0.3)
                        : AppColors.grey300,
                width: 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: center,
                zoom: zoomLevel,
              ),
              polygons: polygons,
              zoomControlsEnabled:
                  true, // Enable zoom controls for better user interaction
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              compassEnabled: true,
              padding: const EdgeInsets.all(8),
              mapType: MapType.normal,

              // Apply dark mode styling if needed
              onMapCreated: (GoogleMapController controller) {
                // Apply map styling based on theme if needed
              },
            ),
          ),

          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: isDarkMode ? AppColors.grey400 : AppColors.grey600,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Map shows your assigned route polygon (start and end points marked)',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? AppColors.grey400 : AppColors.grey600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoRouteAssigned(BuildContext context, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? AppColors.darkBackground.withValues(alpha: 0.95)
                : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: AppColors.grey300.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
        ],
        border:
            isDarkMode
                ? Border.all(
                  color: AppColors.primaryLight.withValues(alpha: 0.2),
                )
                : null,
      ),
      child: Column(
        children: [
          Icon(
            FontAwesomeIcons.route,
            size: 48,
            color: isDarkMode ? AppColors.grey400 : AppColors.grey600,
          ),
          const SizedBox(height: 16),
          Text(
            'No Route Assigned',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppColors.white : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You currently have no route assigned to your profile.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? AppColors.grey400 : AppColors.textMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, bool isDarkMode) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutConfirmation(context, isDarkMode),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode ? AppColors.white : AppColors.error,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        icon: const Icon(Icons.logout, size: 20),
        label: const Text(
          'Logout',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor:
                isDarkMode ? AppColors.darkBackground : AppColors.white,
            title: Text(
              'Confirm Logout',
              style: TextStyle(
                color: isDarkMode ? AppColors.white : AppColors.textDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to logout from your account?',
              style: TextStyle(
                color: isDarkMode ? AppColors.grey300 : AppColors.textMedium,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: isDarkMode ? AppColors.grey400 : AppColors.grey700,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _performLogout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDarkMode ? AppColors.white : AppColors.error,
                  foregroundColor: AppColors.white,
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }

  void _performLogout(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Clear all stored data
      await AppPreferences.clearAllData();

      // Close loading dialog and navigate to login screen
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog

        AppNavigator.pushReplacement(context, LoginScreen());
      }
    } catch (e) {
      // Handle any errors during logout
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to logout: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Widget _buildNfcCard(
    BuildContext context,
    bool isDarkMode,
    AuthCubit authCubit,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? AppColors.darkBackground.withValues(alpha: 0.95)
                : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: AppColors.grey300.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
        ],
        border:
            isDarkMode
                ? Border.all(
                  color: AppColors.primaryLight.withValues(alpha: 0.2),
                )
                : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      FontAwesomeIcons.creditCard,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'NFC Card Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? AppColors.white : AppColors.textDark,
                    ),
                  ),
                ],
              ),
              _isLoading
                  ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : Switch(
                    value: _isNfcEnabled,
                    activeColor: AppColors.success,
                    onChanged:
                        (newValue) =>
                            _toggleNfcEnabled(newValue, context, authCubit),
                  ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Enable NFC card login to quickly sign in using your company ID card',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? AppColors.grey400 : AppColors.textMedium,
            ),
          ),
          if (_isNfcEnabled && _nfcNumber != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.idCard,
                  size: 14,
                  color: isDarkMode ? AppColors.grey400 : AppColors.grey600,
                ),
                const SizedBox(width: 8),
                Text(
                  'Card Number: $_nfcNumber',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? AppColors.grey300 : AppColors.textDark,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // Keep all existing methods unchanged below
  // ...
}
