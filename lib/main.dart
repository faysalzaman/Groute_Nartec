import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/core/themes/app_theme.dart' show AppTheme;
import 'package:groute_nartec/view/screens/auth/cubit/auth_cubit.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/cubit/sales_cubit.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<SalesCubit>(create: (context) => SalesCubit()),
      ],
      child: MaterialApp(
        title: 'GRoute Nartec',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: SplashScreen(),
      ),
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
