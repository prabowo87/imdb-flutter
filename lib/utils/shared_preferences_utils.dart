
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imdb/constants.dart' as constants;

Future<bool> setLogin(bool status) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setBool(constants.isLoginPreference, status);
}
Future<bool?> getLogin() async {
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  return prefs.getBool(constants.isLoginPreference);
}

Future<bool> setLocaleIndex(int locale) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setInt(constants.localeIndexPreference, locale);
}
Future<int?> getLocaleIndex() async {
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  return prefs.getInt(constants.localeIndexPreference);
}