import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imdb/page/home_page.dart';
import 'package:imdb/providers/menu_provider.dart';
import 'package:imdb/utils/fonts.dart';
import 'package:imdb/widgets/zoom_page.dart';

import '../main.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget{
  SplashPage({Key? key, this.status}) : super(key: key);
  @override
  SplashPageState createState() => SplashPageState();
  final bool? status;
  static String routeName = '/splash_page';
  
}
class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    /*MyApp.menuProvider = new MenuProvider(
      vsync: this,
    )..addListener(() => setState(() {}));*/
    super.initState();
    splashTimer(context);

  }

  splashTimer(BuildContext context) async {
    return Timer(Duration(seconds: 5), () {
      if (widget.status!=null && widget.status!){
        // Navigator.pop(context);
        Navigator.pushReplacementNamed(context, MyApp.routeName,arguments: "OMDB");
      }else{
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      }

    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return SafeArea(
      child: Scaffold(

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 130,
                height: 130,
                margin: EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/logo.png"),
                  ),
                ),
              ),
              Text(
                "OMDB",
                style: extraWhiteFont.copyWith(fontSize: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}