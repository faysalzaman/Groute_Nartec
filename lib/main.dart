import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/core/themes/app_theme.dart' show AppTheme;
import 'package:groute_nartec/presentation/modules/auth/cubit/auth_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/inventory/cubit/inventory_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/inventory/cubit/request_stock/request_stock_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/cubits/sales_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/cubits/loading/loading_cubit.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/cubits/start_day/start_day_cubit.dart';
import 'package:groute_nartec/presentation/modules/splash_screen.dart';

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
        BlocProvider<StartDayCubit>(create: (context) => StartDayCubit()),
        BlocProvider<LoadingCubit>(create: (context) => LoadingCubit()),
        BlocProvider<InventoryCubit>(create: (context) => InventoryCubit()),
        BlocProvider<RequestStockCubit>(
          create: (context) => RequestStockCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'GRoutePro',
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
