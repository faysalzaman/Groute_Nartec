import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';
import 'package:groute_nartec/view/widgets/custom_scaffold.dart';
import 'package:groute_nartec/view/widgets/menu_card.dart';
import 'package:groute_nartec/view/widgets/rectangle_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "About",
      automaticallyImplyLeading: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Top header with about icon
            RectangleCard(
              title: "App Information",
              icon: FontAwesomeIcons.circleInfo,
              color: AppColors.warning,
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
