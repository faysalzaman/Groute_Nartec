// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/utils/app_loading.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/presentation/modules/auth/cubit/auth_cubit.dart';
import 'package:groute_nartec/presentation/modules/auth/cubit/auth_state.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/cubit/start_day_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/cubit/start_day_state.dart';
import 'package:groute_nartec/presentation/widgets/buttons/custom_elevated_button.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';
import 'package:image_picker/image_picker.dart';

class VehicleCheckScreen extends StatefulWidget {
  const VehicleCheckScreen({super.key});

  @override
  State<VehicleCheckScreen> createState() => _VehicleCheckScreenState();
}

class _VehicleCheckScreenState extends State<VehicleCheckScreen> {
  final ImagePicker _picker = ImagePicker();
  List<File> _vehicleImages = [];

  // Vehicle condition options
  final List<String> _conditionOptions = [
    'Excellent',
    'Good',
    'Fair',
    'Poor',
    'Critical',
  ];

  // Default values for dropdowns
  String _tyresCondition = 'Good';
  String _acCondition = 'Good';
  String _engineCondition = 'Excellent';
  String _petrolLevel = '100';
  String _odometerReading = '3000';
  String _remarks = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomScaffold(
      title: "Vehicle Daily Check",
      automaticallyImplyLeading: true,
      body: BlocConsumer<StartDayCubit, StartDayState>(
        listener: (context, state) {
          if (state is VehicleCheckSuccessState) {
            Navigator.pop(context);
            AppSnackbars.success(
              context,
              "Vehicle check submitted successfully.",
            );
          }
          if (state is VehicleCheckErrorState) {
            AppSnackbars.danger(
              context,
              state.error.replaceAll("Exception: ", ""),
            );
          }
        },
        builder: (context, state) {
          return Container(
            color: AppColors.lightBackground,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    'Basic Information',
                    FontAwesomeIcons.car,
                  ),
                  _buildInfoCard(context),
                  const SizedBox(height: 16),
                  _buildSectionHeader(
                    'Vehicle Condition',
                    FontAwesomeIcons.wrench,
                  ),
                  _buildConditionCard(),
                  const SizedBox(height: 16),
                  _buildSectionHeader('Vehicle Image', FontAwesomeIcons.image),
                  _buildImageSection(),
                  const SizedBox(height: 24),
                  _buildSubmitButton(context, state),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
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

  final String name = "";

  Widget _buildInfoCard(BuildContext ctx) {
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
                    _buildVehiclePhoto(ctx),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      'Vehicle Name',
                      ctx.read<AuthCubit>().driver?.vehicle?.name ?? "N/A",
                      required: true,
                      icon: FontAwesomeIcons.truck,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoRow(
                      'Plate Number',
                      ctx.read<AuthCubit>().driver?.vehicle?.plateNumber ??
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
                      ctx.read<AuthCubit>().driver?.vehicle?.idNumber ?? "N/A",
                      icon: FontAwesomeIcons.hashtag,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoRow(
                      'Description',
                      ctx.read<AuthCubit>().driver?.vehicle?.description ??
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
          height: 120,
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
            'No photo',
            style: TextStyle(fontSize: 12, color: AppColors.grey500),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool required = false,
    IconData? icon,
  }) {
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
            if (required)
              Text(
                ' *',
                style: TextStyle(fontSize: 10, color: AppColors.error),
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
            style: TextStyle(fontSize: 10, color: AppColors.textDark),
          ),
        ),
      ],
    );
  }

  Widget _buildConditionCard() {
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
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  'Tyres Condition',
                  _tyresCondition,
                  _conditionOptions,
                  (value) {
                    setState(() {
                      _tyresCondition = value!;
                    });
                  },
                  icon: FontAwesomeIcons.carSide,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  'AC Condition',
                  _acCondition,
                  _conditionOptions,
                  (value) {
                    setState(() {
                      _acCondition = value!;
                    });
                  },
                  icon: FontAwesomeIcons.snowflake,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  'Engine Condition',
                  _engineCondition,
                  _conditionOptions,
                  (value) {
                    setState(() {
                      _engineCondition = value!;
                    });
                  },
                  icon: FontAwesomeIcons.gauge,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildPetrolInput()),
            ],
          ),
          const SizedBox(height: 16),
          _buildOdometerInput(),
          const SizedBox(height: 16),
          _buildRemarksInput(),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> options,
    Function(String?) onChanged, {
    IconData? icon,
  }) {
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
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey300, width: 1),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: Container(),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: AppColors.primaryBlue,
            ),
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textDark,
            ), // Reduced from 16 to 14
            itemHeight: 48, // Added to reduce item height
            items:
                options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                      ), // Explicitly set dropdown item text size
                    ),
                  );
                }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildOdometerInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(
              FontAwesomeIcons.gaugeHigh,
              size: 14,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(width: 8),
            Text(
              'Odometer Reading',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey300, width: 1),
          ),
          child: TextField(
            controller: TextEditingController(text: _odometerReading),
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 16, color: AppColors.textDark),
            onChanged: (value) {
              _odometerReading = value;
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              suffixText: 'km',
              suffixStyle: TextStyle(color: AppColors.textMedium, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPetrolInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(
              FontAwesomeIcons.gasPump,
              size: 14,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(width: 8),
            Text(
              'Petrol Level',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey300, width: 1),
          ),
          child: TextField(
            controller: TextEditingController(text: _petrolLevel),
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 16, color: AppColors.textDark),
            onChanged: (value) {
              _petrolLevel = value;
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              suffixText: '%',
              suffixStyle: TextStyle(color: AppColors.textMedium, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRemarksInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(
              FontAwesomeIcons.noteSticky,
              size: 14,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(width: 8),
            Text(
              'Remarks or Comments',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey300, width: 1),
          ),
          child: TextField(
            controller: TextEditingController(text: _remarks),
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            style: TextStyle(fontSize: 16, color: AppColors.textDark),
            onChanged: (value) {
              _remarks = value;
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter any additional comments here...',
              hintStyle: TextStyle(color: AppColors.grey400, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
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
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.camera,
                size: 14,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(width: 8),
              Text(
                'Vehicle Images',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMedium,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${_vehicleImages.length})',
                style: TextStyle(fontSize: 12, color: AppColors.textMedium),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _vehicleImages.isEmpty
              ? _buildEmptyImagesPlaceholder()
              : _buildImageGrid(),
          const SizedBox(height: 16),
          _vehicleImages.length < 13
              ? GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withValues(alpha: 0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.camera,
                        size: 16,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Take Vehicle Photo',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildEmptyImagesPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.cameraRetro,
              size: 48,
              color: AppColors.grey500,
            ),
            const SizedBox(height: 12),
            Text(
              'No images selected',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Take up to 4 photos of the vehicle',
              style: TextStyle(fontSize: 12, color: AppColors.grey500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _vehicleImages.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.grey300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _vehicleImages[index],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _vehicleImages.removeAt(index);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context, StartDayState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomElevatedButton(
        title: 'Submit Vehicle Check',
        buttonState:
            state is VehicleCheckLoadingState
                ? ButtonState.loading
                : ButtonState.idle,
        onPressed: () async {
          if (_vehicleImages.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please take a photo of the vehicle.'),
              ),
            );
            return;
          }
          if (_odometerReading.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter the odometer reading.'),
              ),
            );
            return;
          }
          if (state is VehicleCheckLoadingState) {
            return;
          }
          await context.read<StartDayCubit>().checkVehicle(
            _vehicleImages,
            context.read<AuthCubit>().driver?.vehicle?.id ?? "",
            _tyresCondition,
            _acCondition,
            _engineCondition,
            _petrolLevel,
            _odometerReading,
          );
        },
        leadingIcon: FontAwesomeIcons.check,
        height: 50,
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _vehicleImages.add(File(image.path));
      });
    }
  }
}
