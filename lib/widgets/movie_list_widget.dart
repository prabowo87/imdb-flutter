

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imdb/localdb/db_helper.dart';
import 'package:imdb/localdb/favorite_model.dart';
import 'package:imdb/models/movie_model.dart';
import 'package:imdb/page/favorite_page.dart';
import 'package:imdb/page/movie_detail_page.dart';
import 'package:imdb/providers/favorite_provider.dart';
import 'package:imdb/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class MovieListWidget extends StatefulWidget{
  MovieListWidget({Key? key,this.gm}) : super(key: key);
  // HomePage({@required String title}) : title = title;

  @override
  _MovieListWidget createState() => _MovieListWidget();
  final MovieModel? gm;
}
class _MovieListWidget extends State<MovieListWidget>{


  //BUAT CONSTRUCTOR UNTUK MEMINTA DATA DARI WIDGET YANG MENGGUNAKANNYA


  @override
  Widget build(BuildContext context) {
    //DISMISSIBLE, KETIKA ITEM PRODUKNYA DI GESER MAKA KITA AKAN MENJALANKAN ACTIONS
    var gm = widget.gm;
    Widget icons = Icon(Icons.favorite_border,color: Colors.blue,);
    DbHelper dbHelper = new DbHelper();


    Widget loadWidget(Widget icons){
      return InkWell(

          onTap: (){
            Navigator.pushNamed(context, MovieDetailPage.routeName,arguments: gm);

          },
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: Card(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: gm!.poster,
                          // placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width*0.25,
                          height: MediaQuery.of(context).size.width*0.25,//60
                        ),
                        SizedBox(width: 16,),
                        Expanded(

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[

                              Text(gm.title+" ("+gm.year+")",style: TextStyle(fontWeight: FontWeight.bold),),
                              SizedBox(height: 8,),
                              Text(gm.type),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                    onPressed: (){
                                      print(gm.toJson());
                                      print(gm.toJson().toString());
                                      Provider.of<FavoriteProvider>(context,listen: false).insertBookmark(context, gm).then((value){

                                        setState(() {

                                        });
                                      });

                                    },
                                    color: Colors.blue,
                                    icon: icons
                                ),
                              )

                            ],
                          ),
                        ),
                      ],
                    )
                )

            ),
          )
      );
    }
    return FutureBuilder<List<FavoriteModel>>(
      future: dbHelper.getFavorite(gm!.imdbID),
      builder: (BuildContext context, AsyncSnapshot<List<FavoriteModel>> res) {
          if (res.hasData && res.data!.length>0) {
            // setState(() {
              icons = Icon(Icons.favorite, color: Colors.blue,);
            // });
          }else{
            // setState(() {
              icons = Icon(Icons.favorite_border, color: Colors.blue,);
            // });
          }
          return loadWidget(icons);
      },
    );

  }

}
class ImageDialog extends StatelessWidget {
  final String url;
  ImageDialog(@required this.url);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Stack(

        children: [
          Container(
            color: Colors.black87,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CachedNetworkImage(
              imageUrl: url,
              // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.contain,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,//60
            ),
          ),
          Positioned(
            top: 16.0,
            right: 16.0,
              child: InkWell(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close,color: Colors.white,),
              )
          )
        ],
      ),
    );
  }
}