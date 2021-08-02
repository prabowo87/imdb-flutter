import 'package:flutter/cupertino.dart';
import 'package:imdb/main.dart';
import 'package:imdb/page/favorite_page.dart';
import 'package:imdb/page/home_page.dart';
import 'package:imdb/page/login_page.dart';
import 'package:imdb/page/movie_detail_page.dart';
import 'package:imdb/page/profile_page.dart';
import 'package:imdb/page/splash_page.dart';
import 'package:imdb/widgets/zoom_page.dart';

Map<String, WidgetBuilder> appRoutes = {
  SplashPage.routeName : (context) => SplashPage(),
  LoginPage.routeName : (context) => LoginPage(),
  ZoomPage.routeName : (context) => ZoomPage(),
  MyApp.routeName : (context) => MyApp(),
  HomePage.routeName : (context) => HomePage(),
  MovieDetailPage.routeName : (context) => MovieDetailPage(),
  FavoritePage.routeName : (context) => FavoritePage(),
  ProfilePage.routeName : (context) => ProfilePage(),
};