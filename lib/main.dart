import 'package:flutter/material.dart';
import 'package:groute_nartec/core/themes/app_theme.dart' show AppTheme;
import 'package:groute_nartec/view/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return buildMaterialApp();
  }

  buildMaterialApp() {
    return MaterialApp(
      title: 'GRoute Nartec',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: SplashScreen(),
    );
  }

  // buildMaterialAppWithRouter() {
  //   final appRouter = AppRouter();
  //   return MaterialApp.router(
  //     title: 'GRoute Nartec',
  //     debugShowCheckedModeBanner: false,
  //     theme: AppTheme.light,
  //     darkTheme: AppTheme.dark,
  //     themeMode: ThemeMode.system,
  //     routerConfig: appRouter.router,
  //   );
  // }
}
