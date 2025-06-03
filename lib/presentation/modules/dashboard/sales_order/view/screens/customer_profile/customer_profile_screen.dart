import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_state.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/customer_profile.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';
import 'package:groute_nartec/presentation/widgets/shimmer_placeholder.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SalesCubit>().getCustomerProfile();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Customer Profiles',
      body: BlocBuilder<SalesCubit, SalesState>(
        builder: (context, state) {
          if (state is CustomerProfileLoading) {
            return _buildLoadingState();
          } else if (state is CustomerProfileError) {
            return _buildErrorState(state.error);
          } else if (state is CustomerProfileLoaded) {
            return _buildSuccessState(state.customerProfiles);
          }
          return _buildLoadingState();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          2,
          (index) => _buildCustomerCardPlaceholder(index + 1),
        ),
      ),
    );
  }

  Widget _buildCustomerCardPlaceholder(int cardNumber) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.grey200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const SizedBox(height: 50), // Placeholder height
          ),
          // Header placeholder with badges
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryBlue.withValues(alpha: 0.8),
                  AppColors.primaryBlue.withValues(alpha: 0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Top badges row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Customer number badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Customer #$cardNumber',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    // Status badge placeholder
                    ShimmerPlaceholder(
                      child: Container(
                        width: 60,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Company logo placeholder
                ShimmerPlaceholder(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Company name placeholder
                ShimmerPlaceholder(
                  child: Container(
                    height: 20,
                    width: 200,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Arabic name placeholder
                ShimmerPlaceholder(
                  child: Container(
                    height: 16,
                    width: 150,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // GLN badge placeholder
                ShimmerPlaceholder(
                  child: Container(
                    height: 24,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content placeholder
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Company Info section
                _buildSectionPlaceholder('Company Information', 4),
                const SizedBox(height: 24),

                // Contact Info section
                _buildSectionPlaceholder('Contact Information', 3),
                const SizedBox(height: 24),

                // Location Info section
                _buildSectionPlaceholder('Location Information', 2),
                const SizedBox(height: 24),

                // Additional Info section
                _buildSectionPlaceholder('Additional Information', 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionPlaceholder(String title, int itemCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with icon
        Row(
          children: [
            ShimmerPlaceholder(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Section items
        ...List.generate(
          itemCount,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label placeholder
                Expanded(
                  flex: 2,
                  child: ShimmerPlaceholder(
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.grey300,
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Value placeholder
                Expanded(
                  flex: 3,
                  child: ShimmerPlaceholder(
                    child: Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.grey300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                FontAwesomeIcons.triangleExclamation,
                size: 40,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to Load Profiles',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.textMedium),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                context.read<SalesCubit>().getCustomerProfile();
              },
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState(List<CustomerProfileModel> profiles) {
    if (profiles.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.users,
                  size: 16,
                  color: AppColors.primaryBlue,
                ),
                const SizedBox(width: 8),
                Text(
                  '${profiles.length} Customer${profiles.length > 1 ? 's' : ''} Found',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Customer cards
          ...profiles.asMap().entries.map((entry) {
            final index = entry.key;
            final profile = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == profiles.length - 1 ? 0 : 24,
              ),
              child: _buildCustomerCard(profile, index + 1),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                FontAwesomeIcons.userTie,
                size: 50,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Customers Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Customer profile information is not available at this time.\nPlease try again later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textMedium,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerCard(CustomerProfileModel profile, int cardNumber) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          _buildCustomerHeader(profile, cardNumber),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company Information
                _buildCompanyInfoSection(profile),

                // Contact Information
                if (_hasContactInfo(profile)) ...[
                  const SizedBox(height: 24),
                  _buildContactInfoSection(profile),
                ],

                // Location Information
                if (_hasLocationInfo(profile)) ...[
                  const SizedBox(height: 24),
                  _buildLocationInfoSection(profile),
                ],

                // Additional Information
                const SizedBox(height: 24),
                _buildAdditionalInfoSection(profile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerHeader(CustomerProfileModel profile, int cardNumber) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue,
            AppColors.primaryBlue.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Card number badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Customer #$cardNumber',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(profile.status).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  profile.status ?? 'Active',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Logo and company name
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child:
                profile.logo != null && profile.logo!.isNotEmpty
                    ? ClipOval(
                      child: Image.network(
                        profile.logo!,
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                        errorBuilder:
                            (context, error, stackTrace) => Icon(
                              FontAwesomeIcons.building,
                              size: 40,
                              color: AppColors.primaryBlue,
                            ),
                      ),
                    )
                    : Icon(
                      FontAwesomeIcons.building,
                      size: 40,
                      color: AppColors.primaryBlue,
                    ),
          ),
          const SizedBox(height: 16),

          Text(
            profile.companyNameEnglish ?? 'Company Name',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),

          if (profile.companyNameArabic != null) ...[
            const SizedBox(height: 4),
            Text(
              profile.companyNameArabic!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],

          if (profile.gln != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'GLN: ${profile.gln}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompanyInfoSection(CustomerProfileModel profile) {
    final items =
        <_InfoItem>[
              if (profile.customerId != null)
                _InfoItem('Customer ID', profile.customerId),
              if (profile.gs1CompanyPrefix != null)
                _InfoItem('GS1 Company Prefix', profile.gs1CompanyPrefix),
              if (profile.stackholderType != null)
                _InfoItem('Stakeholder Type', profile.stackholderType),
              if (profile.website != null)
                _InfoItem('Website', profile.website, isUrl: true),
            ]
            .where((item) => item.value != null && item.value!.isNotEmpty)
            .toList();

    if (items.isEmpty) return const SizedBox.shrink();

    return _buildInfoSection(
      title: 'Company Information',
      icon: FontAwesomeIcons.building,
      items: items,
    );
  }

  Widget _buildContactInfoSection(CustomerProfileModel profile) {
    final items =
        <_InfoItem>[
              if (profile.contactPerson != null)
                _InfoItem('Contact Person', profile.contactPerson),
              if (profile.email != null)
                _InfoItem('Email', profile.email, isEmail: true),
              if (profile.mobileNo != null)
                _InfoItem('Mobile', profile.mobileNo, isPhone: true),
              if (profile.companyLandline != null)
                _InfoItem('Landline', profile.companyLandline, isPhone: true),
              if (profile.extensions != null)
                _InfoItem('Extension', profile.extensions),
            ]
            .where((item) => item.value != null && item.value!.isNotEmpty)
            .toList();

    if (items.isEmpty) return const SizedBox.shrink();

    return _buildInfoSection(
      title: 'Contact Information',
      icon: FontAwesomeIcons.addressCard,
      items: items,
    );
  }

  Widget _buildLocationInfoSection(CustomerProfileModel profile) {
    final items =
        <_InfoItem>[
              if (profile.address != null)
                _InfoItem('Address', profile.address),
              if (profile.zipCode != null)
                _InfoItem('Zip Code', profile.zipCode),
              if (profile.latitude != null && profile.longitude != null)
                _InfoItem(
                  'Coordinates',
                  '${profile.latitude}, ${profile.longitude}',
                ),
            ]
            .where((item) => item.value != null && item.value!.isNotEmpty)
            .toList();

    if (items.isEmpty) return const SizedBox.shrink();

    return _buildInfoSection(
      title: 'Location Information',
      icon: FontAwesomeIcons.mapLocationDot,
      items: items,
    );
  }

  Widget _buildAdditionalInfoSection(CustomerProfileModel profile) {
    return _buildInfoSection(
      title: 'Additional Information',
      icon: FontAwesomeIcons.circleInfo,
      items: [
        if (profile.memberId != null) _InfoItem('Member ID', profile.memberId),
        _InfoItem('Created At', _formatDate(profile.createdAt)),
        _InfoItem('Updated At', _formatDate(profile.updatedAt)),
      ],
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required List<_InfoItem> items,
  }) {
    final validItems =
        items
            .where((item) => item.value != null && item.value!.isNotEmpty)
            .toList();

    if (validItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: AppColors.primaryBlue),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...validItems.map((item) => _buildInfoRow(item)),
      ],
    );
  }

  Widget _buildInfoRow(_InfoItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              item.label,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child:
                item.isUrl || item.isEmail || item.isPhone
                    ? GestureDetector(
                      onTap: () => _handleTap(item),
                      child: Text(
                        item.value!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                    : Text(
                      item.value!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  bool _hasContactInfo(CustomerProfileModel profile) {
    return profile.contactPerson != null ||
        profile.email != null ||
        profile.mobileNo != null ||
        profile.companyLandline != null ||
        profile.extensions != null;
  }

  bool _hasLocationInfo(CustomerProfileModel profile) {
    return profile.address != null ||
        profile.zipCode != null ||
        (profile.latitude != null && profile.longitude != null);
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  void _handleTap(_InfoItem item) async {
    try {
      Uri uri;
      if (item.isEmail) {
        uri = Uri.parse('mailto:${item.value}');
      } else if (item.isPhone) {
        uri = Uri.parse('tel:${item.value}');
      } else if (item.isUrl) {
        uri = Uri.parse(
          item.value!.startsWith('http')
              ? item.value!
              : 'https://${item.value}',
        );
      } else {
        return;
      }

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not open ${item.value}')));
      }
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';

    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}

class _InfoItem {
  final String label;
  final String? value;
  final bool isUrl;
  final bool isEmail;
  final bool isPhone;

  _InfoItem(
    this.label,
    this.value, {
    this.isUrl = false,
    this.isEmail = false,
    this.isPhone = false,
  });
}
