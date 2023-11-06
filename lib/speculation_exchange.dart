
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speculation_exchange/screens/launch.dart';
import 'package:speculation_exchange/screens/welcome.dart';
import 'package:speculation_exchange/system/global.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class SpeculationExchange extends StatefulWidget {
  const SpeculationExchange({super.key});

  @override
  State<SpeculationExchange> createState() => _SpeculationExchangeState();
}

class _SpeculationExchangeState extends State<SpeculationExchange> with AfterLayoutMixin {

  @override
  void afterFirstLayout(BuildContext context) async {
    //Do some initialize stuffs here...
    await initializeGlobalStuffs();

    //Test ugly things here...

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //Check if all important things has been initialized.
    if (globalStuffsHasInitialized()) {
      //https://pub.dev/documentation/flutter_riverpod/latest/flutter_riverpod/ProviderScope-class.html
      //GoRouter: https://pub.dev/documentation/go_router/latest/index.html
      return MaterialApp.router(
        theme: FlexThemeData.light(scheme: FlexScheme.aquaBlue),
        darkTheme: FlexThemeData.dark(scheme: FlexScheme.aquaBlue),
        // Use dark or light theme based on system setting.
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
      );
    } else {
      //Waiting for initialized.
      return Container();
    }
  }

  // GoRouter configuration
  final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Launch(),
      ),
      GoRoute(
        path: '/Welcome',
        pageBuilder: (context, state) {
          return _instantFadeTransitionPage(const Welcome(), state);
        },
      ),
      //Add routes here...
    ],
  );

  static Page<dynamic> _instantFadeTransitionPage(
      Widget child, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      // This could do instant transition.
      transitionDuration: const Duration(seconds: 0),
      reverseTransitionDuration: const Duration(seconds: 0),
      child: child,
      transitionsBuilder: _fadeTransitionBuilder,
    );
  }

  static Widget _fadeTransitionBuilder(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // Change the opacity of the screen using a Curve based on the the animation's value
    return FadeTransition(
      opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
      child: child,
    );
  }
}
