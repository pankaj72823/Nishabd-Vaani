import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final cookieProvider = StateNotifierProvider<CookieNotifier, String?>((ref){
  return CookieNotifier();
});


class CookieNotifier extends StateNotifier<String?>{
  CookieNotifier(): super(null){
    loadCookie();
  }

  Future<void>loadCookie() async{
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('cookies');
  }

  Future<void>saveCookie(String cookie) async{
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('cookies', cookie);
  state = cookie;
  }
  Future<void>clearCookie() async{
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('cookies');
  state = null;
  }

}
