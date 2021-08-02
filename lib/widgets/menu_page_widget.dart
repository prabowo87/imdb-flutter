
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imdb/generated/locale_keys.g.dart';
import 'package:imdb/main.dart';
import 'package:imdb/page/favorite_page.dart';
import 'package:imdb/page/home_page.dart';
import 'package:imdb/page/profile_page.dart';
import 'package:imdb/providers/menu_provider.dart';
import 'package:imdb/utils/shared_preferences_utils.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'zoom_page.dart';
class MenuPageWidget extends StatefulWidget{
  @override
  _MenuPageWidget createState() => _MenuPageWidget();
}
class _MenuPageWidget extends State<MenuPageWidget> {
  final List<bool> isSelected=[true,false];

  Widget toggleButton(BuildContext ctx){

    ToggleButtons tb = ToggleButtons(
      color: Colors.grey,
      selectedColor: Colors.blue,
      fillColor: Colors.lightBlueAccent,
      borderColor: Colors.lightBlueAccent,
      selectedBorderColor: Colors.blue,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      children: <Widget>[
        Text("ID",style: TextStyle(color: Colors.white),),
        Text("ENG",style: TextStyle(color: Colors.white),),
      ],
      onPressed: (int index) async{


        for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
          if (buttonIndex == index) {
            setState(() {
              isSelected[buttonIndex] = true;

            });
            if (index==0){
              await context.setLocale(context.supportedLocales[0]).then((value)
              {
                setLocaleIndex(0);

              });


            }else{
              await context.setLocale(context.supportedLocales[1]).then((value)
              {
                setLocaleIndex(1).then((value) {

                });

              });


            }
            // await ctx.setLocale(locale);
          } else {
            setState(() {
              isSelected[buttonIndex] = false;
            });
          }
        }
        setState(() {
          options = [
            MenuItem(Icons.home, LocaleKeys.home.tr()),
            MenuItem(Icons.favorite, LocaleKeys.favorite.tr()),
            MenuItem(Icons.info, LocaleKeys.about.tr()),
            MenuItem(Icons.logout, LocaleKeys.signout.tr()),
            //MenuItem(toggleButton(), title)
          ];
        });
      },
      isSelected: isSelected,
    );
    return tb;
  }
   List<MenuItem> options = [
    MenuItem(Icons.home, LocaleKeys.home.tr()),
    MenuItem(Icons.favorite, LocaleKeys.favorite.tr()),
    MenuItem(Icons.info, LocaleKeys.about.tr()),
    MenuItem(Icons.logout, LocaleKeys.signout.tr()),
    //MenuItem(toggleButton(), title)
  ];

  @override
  void initState() {
    getLocaleIndex().then((value) => {
      if (value==0){
        setState(() {
            isSelected[0] = true;
            isSelected[1] = false;
         })
      }else{
        setState(() {
          isSelected[0] = false;
          isSelected[1] = true;
        })
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String imgUrl=Provider.of<MenuProvider>(context,listen: true).getImageBacdrop();

    return GestureDetector(
      onPanUpdate: (details) {
        //on swiping left
        if (details.delta.dx < -6) {
          Provider.of<MenuProvider>(context, listen: false).toggle();
        }
      },
      child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: imgUrl.isEmpty?
                      AssetImage('assets/bg.png') as ImageProvider
                      :NetworkImage(Provider.of<MenuProvider>(context,listen: true).getImageBacdrop()),
                  fit: BoxFit.cover)
          ),
          child: ClipRRect(

            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                height: double.maxFinite,
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left:24),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text(LocaleKeys.language.tr(),style: TextStyle(color: Colors.white),),
                              SizedBox(width: 16,),
                              toggleButton(context)
                            ],
                          )
                      ),
                    ),
                    SizedBox(height: 12,),
                    Divider(
                      color: Colors.white,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: options.map((item) {

                        return InkWell(
                          onTap: (){
                            if (item.title==LocaleKeys.home.tr()){
                              // Navigator.popAndPushNamed(context, MyApp.routeName);
                              Navigator.pushReplacementNamed(context, MyApp.routeName,arguments: "OMDB");
                              /*Navigator.push(
                              context,
                              MaterialPageRoute(builder: (ctx) => new BookmarkMedia()),
                            );*/
                            }else
                            if (item.title==LocaleKeys.favorite.tr()){
                              Navigator.pushNamed(context, FavoritePage.routeName);
                              /*Navigator.push(
                              context,
                              MaterialPageRoute(builder: (ctx) => new BookmarkMedia()),
                            );*/
                            }else
                            if (item.title==LocaleKeys.about.tr()){
                              Navigator.pushNamed(context, ProfilePage.routeName);
                              /*Navigator.push(
                              context,
                              MaterialPageRoute(builder: (ctx) => new BookmarkMedia()),
                            );*/
                            }else{
                              //keluar
                              setLogin(false).then((value) {
                                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                              });
                            }
                          },
                          child: ListTile(
                            leading: Icon(
                              item.icon,
                              color: Colors.blue,
                              size: 25,
                            ),
                            title: Text(
                              item.title,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                )

              ),
            ),

          )
      ),
    );
  }
}

class MenuItem {
  String title;
  IconData icon;

  MenuItem(this.icon, this.title);
}
