import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nishabdvaani/Provider/cookie_provider.dart';
import 'package:nishabdvaani/Provider/language_provider.dart';
import 'package:nishabdvaani/Provider/tokenProvider.dart';
import 'package:nishabdvaani/Screens/tabs_screen.dart';
import 'package:nishabdvaani/Screens/welcome.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main(){
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget{
  static const platform = MethodChannel('com.example.nishabdvaani/hand_sign_language');


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cookie = ref.watch(cookieProvider);
    final lang = ref.watch(languageProvider);
    final token = ref.watch(tokenProvider);
    return MaterialApp(
      title: 'NishabdVaani',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      locale: Locale(lang),
      supportedLocales: const [
        Locale('en'),
        Locale('gu'),
      ],
      debugShowCheckedModeBanner: false,
      home: (cookie!=null && token!=null) ? TabsScreen() : Welcome(),
    );
  }
}