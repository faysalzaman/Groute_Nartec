// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import '../view/screens/auth/login_screen.dart' show LoginScreen;
// import '../view/screens/dashboard/about/about_screen.dart' show AboutScreen;
// import '../view/screens/dashboard/home_screen.dart' show HomeScreen;
// import '../view/screens/dashboard/inventory/inventory_management_screen.dart';
// import '../view/screens/splash_screen.dart' show SplashScreen;
// import 'app_routes.dart';

// class AppRouter {
//   final GoRouter router;

//   AppRouter()
//     : router = GoRouter(
//         initialLocation: AppRoutes.splash,
//         routes: <RouteBase>[
//           GoRoute(
//             path: AppRoutes.splash,
//             builder: (BuildContext context, GoRouterState state) {
//               return SplashScreen();
//             },
//           ),
//           GoRoute(
//             path: AppRoutes.login,
//             builder: (BuildContext context, GoRouterState state) {
//               return LoginScreen();
//             },
//           ),
//           GoRoute(
//             path: AppRoutes.home,
//             builder: (BuildContext context, GoRouterState state) {
//               return HomeScreen();
//             },
//             routes: <RouteBase>[
//               GoRoute(
//                 path: AppRoutes.about,
//                 builder: (BuildContext context, GoRouterState state) {
//                   return AboutScreen();
//                 },
//               ),
//               GoRoute(
//                 path: AppRoutes.inventory,
//                 builder: (BuildContext context, GoRouterState state) {
//                   return InventoryManagementScreen();
//                 },
//               ),
//             ],
//           ),
//         ],
//         errorBuilder: (BuildContext context, GoRouterState state) {
//           return Scaffold(body: Center(child: Text('Error: ${state.error}')));
//         },
//       );
// }
