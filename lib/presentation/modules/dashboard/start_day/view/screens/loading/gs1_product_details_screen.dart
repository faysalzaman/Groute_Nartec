import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/constants/constants.dart';
import 'package:groute_nartec/core/utils/app_loading.dart';
import 'package:groute_nartec/core/utils/app_snackbars.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/cubits/start_day_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/cubits/start_day_state.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/gs1_product.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/view/screens/loading/select_bin_location_screen.dart';
import 'package:groute_nartec/presentation/widgets/buttons/custom_elevated_button.dart';
import 'package:groute_nartec/presentation/widgets/custom_scaffold.dart';

class GS1ProductDetailsScreen extends StatefulWidget {
  final String barcode;
  final Function(GS1Product? product)? onProductSelected;

  const GS1ProductDetailsScreen({
    super.key,
    required this.barcode,
    this.onProductSelected,
  });

  @override
  State<GS1ProductDetailsScreen> createState() =>
      _GS1ProductDetailsScreenState();
}

class _GS1ProductDetailsScreenState extends State<GS1ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  void _loadProductDetails() {
    context.read<StartDayCubit>().getGS1ProductDetails(widget.barcode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StartDayCubit, StartDayState>(
      listener: (context, state) {
        if (state is GS1ProductErrorState) {
          AppSnackbars.danger(context, state.error);
        } else if (state is GS1ProductSuccessState) {
          if (widget.onProductSelected != null) {
            widget.onProductSelected!(context.read<StartDayCubit>().gs1Product);
          }
        }
      },
      builder: (context, state) {
        final product = context.read<StartDayCubit>().gs1Product;

        return CustomScaffold(
          title: 'Product Details',
          automaticallyImplyLeading: true,
          body:
              state is GS1ProductLoadingState
                  ? _buildLoadingView()
                  : product != null
                  ? _buildProductDetailsView(product)
                  : _buildErrorView(),
        );
      },
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLoading(color: AppColors.primaryBlue),
          Text(
            'Loading product details...',
            style: TextStyle(color: AppColors.textMedium, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            'Failed to load product details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check the barcode and try again',
            style: TextStyle(color: AppColors.textMedium, fontSize: 16),
          ),
          const SizedBox(height: 24),
          CustomElevatedButton(
            title: 'Try Again',
            onPressed: _loadProductDetails,
            width: 150,
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetailsView(GS1Product product) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product header with image and barcode
          _buildProductHeader(product, isDarkMode),

          const SizedBox(height: 24),

          // Product details cards
          _buildDetailCard(
            context,
            'Basic Information',
            isDarkMode,
            icon: FontAwesomeIcons.tag,
            children: [
              _buildDetailRow(
                'Product Name (EN)',
                product.productnameenglish ?? 'N/A',
              ),
              _buildDetailRow(
                'Product Name (AR)',
                product.productnamearabic ?? 'N/A',
              ),
              _buildDetailRow('Brand', product.brandName ?? 'N/A'),
              _buildDetailRow('Origin', product.origin ?? 'N/A'),
              _buildDetailRow('Type', product.productType ?? 'N/A'),
              _buildDetailRow('Unit', product.unit ?? 'N/A'),
              _buildDetailRow('Size', product.size ?? 'N/A'),
            ],
          ),

          const SizedBox(height: 16),

          _buildDetailCard(
            context,
            'Classification',
            isDarkMode,
            icon: FontAwesomeIcons.diagramProject,
            children: [
              _buildDetailRow('GPC', product.gpc ?? 'N/A'),
              _buildDetailRow('GPC Code', product.gpcCode ?? 'N/A'),
              _buildDetailRow('GPC Type', product.gpcType ?? 'N/A'),
              _buildDetailRow('HS Code', product.hSCODES ?? 'N/A'),
              _buildDetailRow('HS Description', product.hsDescription ?? 'N/A'),
              _buildDetailRow('Country of Sale', product.countrySale ?? 'N/A'),
            ],
          ),

          const SizedBox(height: 16),

          _buildDetailCard(
            context,
            'Identification',
            isDarkMode,
            icon: FontAwesomeIcons.barcode,
            children: [
              _buildDetailRow('Barcode', product.barcode ?? 'N/A'),
              _buildDetailRow('GCP/GLN ID', product.gcpGLNID ?? 'N/A'),
              _buildDetailRow('GCP Type', product.gcpType ?? 'N/A'),
              _buildDetailRow('GTIN Type', product.gtinType ?? 'N/A'),
              _buildDetailRow('MNF Code', product.mnfCode ?? 'N/A'),
              _buildDetailRow('MNF GLN', product.mnfGLN ?? 'N/A'),
              _buildDetailRow('Prov GLN', product.provGLN ?? 'N/A'),
            ],
          ),

          const SizedBox(height: 16),

          _buildDetailCard(
            context,
            'Packaging Details',
            isDarkMode,
            icon: FontAwesomeIcons.box,
            children: [
              _buildDetailRow('Packaging Type', product.packagingType ?? 'N/A'),
              _buildDetailRow('Child Product', product.childProduct ?? 'N/A'),
              _buildDetailRow('Quantity', product.quantity ?? '0'),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CustomElevatedButton(
                  height: 40,
                  title: 'Start Picking',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SelectBinLocationScreen(),
                      ),
                    );
                  },
                  backgroundColor: AppColors.success,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Product metadata - smaller text
          Text(
            'Product ID: ${product.id}',
            style: TextStyle(color: AppColors.textMedium, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            'Created: ${_formatDate(product.createdAt)}',
            style: TextStyle(color: AppColors.textMedium, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            'Updated: ${_formatDate(product.updatedAt)}',
            style: TextStyle(color: AppColors.textMedium, fontSize: 12),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProductHeader(GS1Product product, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackground : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product Image
          if (product.frontImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color:
                      isDarkMode
                          ? AppColors.darkBackground
                          : AppColors.lightBackground,
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      '$kGTrackUrl${product.frontImage!.replaceAll('\\', '/')}',
                  fit: BoxFit.contain,
                  placeholder:
                      (context, url) => Center(
                        child: SpinKitFadingCircle(
                          color: AppColors.primaryBlue,
                          size: 30.0,
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        color:
                            isDarkMode
                                ? AppColors.darkBackground
                                : AppColors.lightBackground,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 64,
                          color:
                              isDarkMode
                                  ? AppColors.textLight.withValues(alpha: 0.5)
                                  : AppColors.textMedium.withValues(alpha: 0.5),
                        ),
                      ),
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color:
                    isDarkMode
                        ? AppColors.darkBackground
                        : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 64,
                color:
                    isDarkMode
                        ? AppColors.textLight.withValues(alpha: 0.5)
                        : AppColors.textMedium.withValues(alpha: 0.5),
              ),
            ),

          const SizedBox(height: 16),

          // Product title
          Text(
            product.productnameenglish ?? 'Unknown Product',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppColors.textLight : AppColors.textDark,
            ),
          ),

          if (product.productnamearabic != null) ...[
            const SizedBox(height: 4),
            Text(
              product.productnamearabic!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color:
                    isDarkMode
                        ? AppColors.textLight.withValues(alpha: 0.8)
                        : AppColors.textDark.withValues(alpha: 0.8),
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Brand & Origin row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (product.brandName != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    product.brandName!,
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],

              if (product.origin != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    product.origin!,
                    style: TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 16),

          // Barcode section
          Row(
            children: [
              // QR Code
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: BarcodeWidget(
                  data: product.barcode ?? "",
                  barcode: Barcode.qrCode(),
                  width: 100,
                  height: 50,
                ),
              ),

              const SizedBox(width: 16),

              // Barcode details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Barcode:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color:
                            isDarkMode
                                ? AppColors.textLight
                                : AppColors.textMedium,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.barcode ?? 'N/A',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            isDarkMode
                                ? AppColors.textLight
                                : AppColors.textDark,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (product.productType != null)
                      Text(
                        product.productType!,
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              isDarkMode
                                  ? AppColors.textLight.withValues(alpha: 0.7)
                                  : AppColors.textMedium,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context,
    String title,
    bool isDarkMode, {
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackground : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color:
                  isDarkMode
                      ? AppColors.primaryDark.withValues(alpha: 0.3)
                      : AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                FaIcon(
                  icon,
                  size: 16,
                  color:
                      isDarkMode
                          ? AppColors.primaryLight
                          : AppColors.primaryBlue,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        isDarkMode
                            ? AppColors.primaryLight
                            : AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color:
                    isDarkMode
                        ? AppColors.textLight.withValues(alpha: 0.7)
                        : AppColors.textMedium,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? AppColors.textLight : AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}
