import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imdb/main.dart';
import 'package:imdb/page/home_page.dart';
import 'package:imdb/providers/login_provider.dart';
import 'package:imdb/utils/shared_preferences_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBase extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(

            primarySwatch: Colors.blue,

            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: LoginPage(),





    );
  }

}
class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => new _LoginPageState();

  static String routeName = "/login_page";
}

class _LoginPageState extends State<LoginPage>  with WidgetsBindingObserver{
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final focusEmail = FocusNode();
  final focusPass = FocusNode();
  String _response = '';
  bool _apiCall = false;

  String token = '';
  final focus = FocusNode();




  Widget progressWidget(LoginProvider provider) {
    if (provider.loading){
      // jika masih proses kirim API8
      return AlertDialog(

        content: new Column(
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Please wait")
          ],
        ),
      );
    }else{
      if (provider.isLogin){
        //Navigator.pushNamed(context, HomePage.routeName,arguments: "OMDB");
      //  Navigator.push(context, new MaterialPageRoute(
        //    builder: (context) => new HomePage(title: "OMDB",))
        //);
        setLogin(true).then((value) => {
        Navigator.pushReplacementNamed(context, MyApp.routeName,arguments: "OMDB")
        });
        //routeTimer(context);

      }else{
        _response=provider.response;
      }
      return Center(
        child: Text(_response),
      );
    }
    // jika sudah selesai kirim API



  }

  routeTimer(BuildContext context) async{
    return Timer(Duration(seconds: 2), (){
      Navigator.pushReplacementNamed(context, MyApp.routeName,arguments: "OMDB");
      /*Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => HomePage(title: "OMDB",)));*/
    });


  }
  @override
  void initState() {

  }
  @override
  void dispose() {

    super.dispose();
  }
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {

    }
  }
  @override
  Widget build(BuildContext context) {

  final username=new Card(
    elevation: 1,
    shadowColor: Colors.blueGrey,
    child: Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
        Icon(Icons.verified_user,color: Colors.blue,size: 16,),
        SizedBox(width: 12,),
          Flexible(
            child: TextFormField(
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              autofocus: true,
              style: TextStyle(color: Colors.black54,),
              decoration: InputDecoration(
                hintText: "User Name",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),

              ),
              focusNode: focusEmail,
              controller: _email,
              onFieldSubmitted: (v){
                FocusScope.of(context).requestFocus(focusPass);
              },
            ),
          ),
        ],
      ),
    )
  );

  final pass=new Card(
      elevation: 1,
      shadowColor: Colors.blueGrey,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.vpn_key,color: Colors.blue,size: 16,),
            SizedBox(width: 12,),
            Flexible(
              child: TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                autofocus: true,
                obscureText: true,
                style: TextStyle(color: Colors.black54,),
                decoration: InputDecoration(
                  hintText: "Password",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),

                ),
                controller: _pass,
                focusNode: focusPass,
                onFieldSubmitted: (v){
                  FocusScope.of(context).requestFocus(focus);
                },
              ),
            ),
          ],
        ),
      )
  );



    final loginButton = Card(
      color: Colors.blue,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(3.0),
      ),
      elevation: 3,
      shadowColor: Colors.blueGrey,
      child: MaterialButton(

        height: 45,
        // color: Colors.blue,
        focusNode: focus,
        onPressed:(){
          if (_email.text.trim().isNotEmpty && _pass.text.trim().isNotEmpty) {

            Provider.of<LoginProvider>(context,listen: false).checkLogin(_email.text, _pass.text);

          }else{
            Fluttertoast.showToast(msg:"Please fill in all fields");
          }
        },

        padding: const EdgeInsets.all(8.0),

        child: new Text(
          "Login",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );


    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xfff7f5f5),
          body: Center(
            child:SingleChildScrollView(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  //logo,
                  //SizedBox(height: 48.0),
                  Image.asset('assets/logo.png',width: MediaQuery.of(context).size.width/4,height: MediaQuery.of(context).size.height/4,),
                  Align(
                    alignment: Alignment.center,
                    child: Text('OMDB LOGIN',softWrap: true,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                  ),

                  SizedBox(height: 16.0,),
                  username,
                  SizedBox(height: 8.0),
                  pass,
                  SizedBox(height: 24.0),

                  loginButton,
                Consumer<LoginProvider>(
                  builder: (ctx, produks, child) =>
                      progressWidget(produks),


                ),

                ],
              ),
            ),
          )

      ),
    );
  }
}