
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
      // https://rydmike.com/flexcolorscheme/themesplayground-latest/
      return MaterialApp.router(
        theme: FlexThemeData.light(
          scheme: FlexScheme.brandBlue,
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 7,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 10,
            blendOnColors: false,
            useTextTheme: true,
            useM2StyleDividerInM3: true,
            alignedDropdown: true,
            useInputDecoratorThemeInDialogs: true,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          // To use the Playground font, add GoogleFonts package and uncomment
          // fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.brandBlue,
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 13,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 20,
            useTextTheme: true,
            useM2StyleDividerInM3: true,
            alignedDropdown: true,
            useInputDecoratorThemeInDialogs: true,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          // To use the Playground font, add GoogleFonts package and uncomment
          // fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
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
