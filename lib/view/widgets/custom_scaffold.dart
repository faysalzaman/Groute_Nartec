import 'package:flutter/material.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';

class CustomScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;

  const CustomScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          title == null
              ? null
              : AppBar(
                automaticallyImplyLeading: automaticallyImplyLeading,
                title: Text(
                  title!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryBlue,
                        AppColors.primaryBlue.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
                foregroundColor: foregroundColor ?? AppColors.textLight,
                elevation: elevation ?? 0,
                actions: actions,
                scrolledUnderElevation: 0,
              ),
      body: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryBlue.withValues(alpha: 0.3),
              AppColors.white,
            ],
          ),
        ),
        child: body,
      ),
    );
  }
}
