import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/core/themes/custom_scaffold.dart';
import 'package:groute_nartec/view/widgets/menu_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomScaffold(
      title: "About",
      automaticallyImplyLeading: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top header with about icon
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? AppColors.darkBackground
                        : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey400.withValues(alpha: 0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.circleInfo,
                      color: AppColors.warning,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'App Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Main menu options
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  MenuCard(
                    icon: FontAwesomeIcons.mobileScreen,
                    title: 'Application Version',
                    description: 'Current version and build information',
                    color: AppColors.primaryBlue,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.download,
                    title: 'New Updates',
                    description: 'Check for available updates',
                    color: AppColors.success,
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: FontAwesomeIcons.certificate,
                    title: 'New Release',
                    description: 'Latest features and improvements',
                    color: AppColors.error,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            // Bottom spacing
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
