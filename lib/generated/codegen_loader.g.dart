// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> id_ID = {
  "title": "OMDB",
  "language": "Pilih Bahasa",
  "home": "Beranda",
  "favorite": "Favorit",
  "about": "Tentang Kami",
  "signout": "Keluar",
  "search": "cari",
  "notFoundData": "Data tidak ditemukan"
};
static const Map<String,dynamic> en_US = {
  "title": "OMDB",
  "language": "Choose Language",
  "home": "Home",
  "favorite": "Favorite",
  "about": "About Us",
  "signout": "Signout",
  "search": "Search",
  "notFoundData": "Data not found"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"id_ID": id_ID, "en_US": en_US};
}
