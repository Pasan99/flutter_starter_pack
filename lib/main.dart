// ignore: avoid_web_libraries_in_flutter
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/routes/router.gr.dart';
import 'package:food_deliver/src/ui/pages/registration/getting_started_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp])
      .then((_) {
    runApp(EasyLocalization(
      child: MyApp(),
      supportedLocales: [
        Locale('en', 'US'),
        Locale('si', 'US'),
        Locale('ta', 'US'),
      ],
      path: 'assets',

    ));
  });
}
/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'FAiRSPACE';

  @override
    Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        EasyLocalization.of(context).delegate,
      ],
      supportedLocales: EasyLocalization.of(context).supportedLocales,
      locale: EasyLocalization.of(context).locale,
      home: GettingStartedScreen(),
      onGenerateRoute: Router().onGenerateRoute,
      initialRoute: Routes.gettingStartedScreen,
      builder: (ctx, nativeNavigator) => ExtendedNavigator<Router>(router: Router()),
      theme: ThemeData(
          fontFamily: 'Raleway',
        bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.black.withOpacity(0)),
      ),
    );
  }

}