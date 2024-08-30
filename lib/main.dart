
import 'package:flutter/material.dart';
import 'package:nishabdvaani/Screens/tabs_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main(){
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget{
  static const platform = MethodChannel('com.example.nishabdvaani/hand_sign_language');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NishabdVaani',
      debugShowCheckedModeBanner: false,
      home: TabsScreen(),
    );
  }

}