import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groute_nartec/core/constants/app_colors.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.color, this.size});

  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: SpinKitSpinningLines(
        color:
            color ??
            (isDarkTheme
                ? AppColors.darkBackground
                : AppColors.lightBackground),
        size: size ?? 24.0,
      ),
    );
  }
}
