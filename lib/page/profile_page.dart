import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imdb/page/home_page.dart';
import 'package:imdb/providers/login_provider.dart';
import 'package:imdb/utils/shared_preferences_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfilePage extends StatefulWidget {

  @override
  _ProfilePage createState() => new _ProfilePage();

  static String routeName = "/profil_page";
}

class _ProfilePage extends State<ProfilePage>  {


  @override
  void initState() {

  }
  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {




    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xfff7f5f5),
          body: Center(
            child:SingleChildScrollView(
              child: Card(
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 24.0, right: 24.0),
                    children: <Widget>[
                      //logo,
                      //SizedBox(height: 48.0),
                      Image.asset('assets/logo.png',width: MediaQuery.of(context).size.width/4,height: MediaQuery.of(context).size.height/4,),
                      Align(
                        alignment: Alignment.center,
                        child: Text('OMDB APP',softWrap: true,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                      ),

                      SizedBox(height: 8.0,),
                      Align(
                        alignment: Alignment.center,
                        child: Text("Developer : Hermawan Prabowo",),
                      ),
                      SizedBox(height: 8.0),
                      Align(
                        alignment: Alignment.center,
                        child: Text("email : hermawankoding@gmail.com",),
                      )




                    ],
                  ),
                ),
              ),
            ),
          )

      ),
    );
  }
}