import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_loading.dart';
import 'package:groute_nartec/presentation/modules/auth/cubit/auth_cubit.dart';
import 'package:groute_nartec/presentation/modules/auth/cubit/auth_state.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/cubits/start_day/start_day_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/cubits/start_day/start_day_state.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/view/widgets/location_map_widget.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';
import 'package:intl/intl.dart';

class VehicleInformationScreen extends StatefulWidget {
  const VehicleInformationScreen({super.key});

  @override
  State<VehicleInformationScreen> createState() =>
      _VehicleInformationScreenState();
}

class _VehicleInformationScreenState extends State<VehicleInformationScreen> {
  bool isMapLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<StartDayCubit>().getVehicleCheckHistory();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StartDayCubit, StartDayState>(
      listener: (context, state) {},
      builder: (context, state) {
        return CustomScaffold(
          title: "Vehicle Information",
          automaticallyImplyLeading: true,
          body: Container(
            color: AppColors.lightBackground,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    'Vehicle Details',
                    FontAwesomeIcons.truck,
                  ),
                  _buildInfoCard(context),
                  const SizedBox(height: 16),

                  // Vehicle Check History Section
                  state is VehicleCheckHistoryError
                      ? const SizedBox()
                      : _buildSectionHeader(
                        'Last Vehicle Check',
                        FontAwesomeIcons.clipboardCheck,
                      ),
                  state is VehicleCheckHistoryError
                      ? const SizedBox()
                      : _buildVehicleCheckHistorySection(context, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: const EdgeInsets.only(top: 16, left: 5, right: 5),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          FaIcon(icon, size: 18, color: AppColors.white),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle Photo
              Center(
                child: Column(
                  children: [
                    _buildVehiclePhoto(context),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      'Vehicle Name',
                      context.read<AuthCubit>().driver?.vehicle?.name ?? "N/A",
                      icon: FontAwesomeIcons.truck,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoRow(
                      'Plate Number',
                      context.read<AuthCubit>().driver?.vehicle?.plateNumber ??
                          "N/A",
                      icon: FontAwesomeIcons.idCard,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      'ID Number',
                      context.read<AuthCubit>().driver?.vehicle?.idNumber ??
                          "N/A",
                      icon: FontAwesomeIcons.hashtag,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoRow(
                      'Description',
                      context.read<AuthCubit>().driver?.vehicle?.description ??
                          "N/A",
                      icon: FontAwesomeIcons.noteSticky,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVehiclePhoto(BuildContext context) {
    final vehiclePhotoUrl = context.read<AuthCubit>().driver?.vehicle?.photo;

    return Column(
      children: [
        Text(
          'Vehicle Photo',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textMedium,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child:
              vehiclePhotoUrl != null && vehiclePhotoUrl.isNotEmpty
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: vehiclePhotoUrl,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Center(child: AppLoading()),
                      errorWidget:
                          (context, url, error) => const Icon(
                            FontAwesomeIcons.truck,
                            size: 36,
                            color: AppColors.grey500,
                          ),
                    ),
                  )
                  : _buildPlaceholderVehicle(),
        ),
      ],
    );
  }

  Widget _buildPlaceholderVehicle() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.truck, size: 36, color: AppColors.grey500),
          const SizedBox(height: 8),
          Text(
            'No photo available',
            style: TextStyle(fontSize: 12, color: AppColors.grey500),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              FaIcon(icon, size: 14, color: AppColors.primaryBlue),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey300, width: 1),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 14, color: AppColors.textDark),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleCheckHistorySection(
    BuildContext context,
    StartDayState state,
  ) {
    if (state is VehicleCheckHistoryLoading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: AppLoading()),
      );
    } else if (state is VehicleCheckHistorySuccess &&
        state.vehicleCheckHistory.lastVehicleCheck != null) {
      final checkHistory = state.vehicleCheckHistory.lastVehicleCheck!;

      String formattedDate = 'N/A';
      try {
        final dateTime = DateTime.parse(checkHistory.createdAt ?? '');
        formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
      } catch (e) {
        formattedDate = checkHistory.createdAt ?? 'N/A';
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date information
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primaryBlue.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.calendar,
                    size: 14,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Last checked: $formattedDate',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Vehicle conditions
            Row(
              children: [
                Expanded(
                  child: _buildCheckInfoItem(
                    'Tyres Condition',
                    checkHistory.tyresCondition ?? 'N/A',
                    FontAwesomeIcons.carSide,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCheckInfoItem(
                    'AC Condition',
                    checkHistory.aCCondition ?? 'N/A',
                    FontAwesomeIcons.snowflake,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildCheckInfoItem(
                    'Petrol Level',
                    checkHistory.petrolLevel ?? 'N/A',
                    FontAwesomeIcons.gasPump,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCheckInfoItem(
                    'Engine Condition',
                    checkHistory.engineCondition ?? 'N/A',
                    FontAwesomeIcons.carBattery,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildCheckInfoItem(
                    'Odometer Reading',
                    checkHistory.odoMeterReading ?? 'N/A',
                    FontAwesomeIcons.gaugeHigh,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCheckInfoItem(
                    'Remarks',
                    checkHistory.remarks.toString().trim(),
                    FontAwesomeIcons.comment,
                  ),
                ),
              ],
            ),

            // Map display
            if (checkHistory.latitude != null &&
                checkHistory.longitude != null) ...[
              const SizedBox(height: 20),
              Text(
                'Location Map',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 10),
              _buildLocationMap(
                checkHistory.latitude!,
                checkHistory.longitude!,
              ),
            ],

            // Photos section
            if (checkHistory.photos != null &&
                checkHistory.photos!.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'Vehicle Check Photos',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 10),
              _buildPhotoGallery(checkHistory.photos!),
            ],
          ],
        ),
      );
    } else if (state is VehicleCheckHistoryError) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.red[400], size: 48),
            const SizedBox(height: 16),
            Text(
              'Failed to load check history',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.red[400]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                context.read<StartDayCubit>().getVehicleCheckHistory();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.white,
                backgroundColor: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
      );
    } else {
      // Initial state or other states
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'No recent vehicle check found',
            style: TextStyle(color: AppColors.textMedium),
          ),
        ),
      );
    }
  }

  Widget _buildCheckInfoItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(icon, size: 12, color: AppColors.primaryBlue),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMedium,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGallery(List<String> photos) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.grey300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: photos[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(child: AppLoading()),
                errorWidget:
                    (context, url, error) => Center(
                      child: FaIcon(
                        FontAwesomeIcons.circleExclamation,
                        color: AppColors.grey500,
                      ),
                    ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLocationMap(double latitude, double longitude) {
    return LocationMapWidget(
      latitude: latitude,
      longitude: longitude,
      markerTitle: 'Vehicle Check Location',
      height: 300,
      showControls: true,
    );
  }
}
