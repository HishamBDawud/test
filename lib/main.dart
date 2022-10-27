import 'dart:developer';
import 'dart:io';

import 'package:cleanapp/core/ui_constants/fonts.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/IsFirstTime/IFT_bloc.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/Password/password_bloc.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/login/login_bloc.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/profile/profile_bloc.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/timer/timer_bloc.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/verification/verify_bloc.dart';
import 'package:cleanapp/services/authintication/presentaion/pages/get_started_screen.dart';
import 'package:cleanapp/services/localization/app_localization.dart';
import 'package:cleanapp/services/localization/language_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/ui_constants/colors.dart';
import 'get_it.dart' as di;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    log(locale.languageCode);
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<LoginBloc>(),
        ),
        BlocProvider(create: (_) => di.sl<VerifyBloc>()),
        BlocProvider(create: (_) => di.sl<TimerBloc>()),
        BlocProvider(create: (_) => di.sl<ProfileBLoc>()),
        BlocProvider(create: (_) => di.sl<IFTBloc>()),
        BlocProvider(create: (_) => di.sl<PasswordBloc>())
      ],
      child: MaterialApp(
        supportedLocales: const [Locale('en', 'EN'), Locale('ar', 'AR')],
        locale: _locale,
        localizationsDelegates: [
          Applocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        theme: ThemeData(
            fontFamily: _locale == 'en' ? font_en : font_ar,
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
            )),
        home: const GetStartedScreen(),
      ),
    );
  }
}
