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
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;
  final PreferredSizeWidget? appBarWidget;
  final EdgeInsetsGeometry? padding;
  final bool centerTitle;
  final Widget? leading;
  final Widget? titleWidget;
  final List<BoxShadow>? boxShadow;

  const CustomScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
    this.appBarWidget,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.centerTitle = true,
    this.leading,
    this.titleWidget,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseColor =
        backgroundColor ??
        (isDark ? AppColors.darkBackground : AppColors.lightBackground);
    final textColor =
        foregroundColor ?? (isDark ? AppColors.textLight : AppColors.textDark);

    final appBarShadow =
        boxShadow ??
        [
          if (elevation != null && elevation! > 0)
            BoxShadow(
              color: (isDark ? Colors.black : AppColors.primaryDark).withValues(
                alpha: 0.15,
              ),
              blurRadius: elevation! * 3,
              offset: const Offset(0, 1),
            ),
        ];

    return Scaffold(
      appBar:
          appBarWidget ??
          (title == null && titleWidget == null
              ? null
              : AppBar(
                automaticallyImplyLeading: automaticallyImplyLeading,
                leading: leading,
                title:
                    titleWidget ??
                    (title != null
                        ? Text(
                          title!,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            letterSpacing: 0.3,
                          ),
                        )
                        : null),
                centerTitle: centerTitle,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    color: baseColor,
                    boxShadow: appBarShadow,
                  ),
                ),
                backgroundColor: baseColor,
                foregroundColor: textColor,
                elevation: elevation ?? 0,
                scrolledUnderElevation: elevation ?? 0,
                shadowColor:
                    isDark
                        ? Colors.black
                        : AppColors.primaryDark.withValues(alpha: 0.3),
                actions: actions,
              )),
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.scaffoldBackground,
      drawer: drawer,
      endDrawer: endDrawer,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              isDark
                  ? AppColors.darkBackground
                  : baseColor.withValues(alpha: 0.02),
              isDark ? AppColors.darkBackground : AppColors.scaffoldBackground,
            ],
            stops: const [0.0, 0.3],
          ),
        ),
        padding: padding,
        child: SafeArea(bottom: bottomNavigationBar == null, child: body),
      ),
    );
  }
}
