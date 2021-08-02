import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imdb/generated/locale_keys.g.dart';
import 'package:imdb/localdb/favorite_model.dart';
import 'package:imdb/models/movie_model.dart';
import 'package:imdb/providers/favorite_provider.dart';
import 'package:imdb/widgets/favorite_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
class FavoritePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return FavoritePageState();
  }
  static const String routeName ="/favorite_page";
}
class FavoritePageState extends State<FavoritePage> with SingleTickerProviderStateMixin{

  ScrollController _scrollController = new ScrollController();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<
      RefreshIndicatorState>();
  static Future<void> refreshData(BuildContext context, bool refresh) async {
    await Provider.of<FavoriteProvider>(context, listen: false).getBookmark(
        context, refresh, "");
    }
    @override
    void initState() {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {

          refreshData(context,false);
        }
      });
      refreshData(context, true);
      super.initState();
    }
    @override
    void dispose() {
      _scrollController.dispose();
      super.dispose();
    }

    Widget _buildProgressIndicator() {

      return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Center(
          child: Consumer<FavoriteProvider>(
              builder: (ctx, waiting, child) {
                return new Opacity(
                  opacity: waiting.loading?1:0,
                  child: new CircularProgressIndicator(),
                );

              }),
        ),
      );
    }
    Widget _buildList(int jumlah,String link,List<FavoriteModel>? product) {
      if (product!.length>0){
        return ListView.builder(

          itemCount: jumlah+1,
          physics: BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int i) {
            if (i == jumlah) {
              return _buildProgressIndicator();
            } else {
              MovieModel movieModel = MovieModel();
              movieModel.imdbID = product[i].getImdbID!;
              movieModel.title = product[i].getTitle!;
              movieModel.year = product[i].getYear!;
              movieModel.poster = product[i].getPoster!;
              movieModel.type = product[i].getType!;
              return FavoriteListWidget(gm:movieModel);


            }
          },
          controller: _scrollController,
        );
      }else{
        return Consumer<FavoriteProvider>(
            builder: (ctx, gudang, child) =>Center(
              child: gudang.loadingCenter?CircularProgressIndicator():Column(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,children: [Center(child:Text(LocaleKeys.notFoundData.tr())),IconButton(
                  icon: new Icon(Icons.refresh,size: 36,),
                  onPressed: () {
                    setState(() {});
                  },)],),
            ));
      }


    }
    @override
    Widget build(BuildContext context) {



      return new SafeArea(
        child: Scaffold(
          //create appBar
          appBar: new AppBar(
            title: Consumer<FavoriteProvider>(
                builder: (ctx, products, child) => products.appBarTitle),
            actions: <Widget>[
              IconButton(
                icon: Consumer<FavoriteProvider>(
                    builder: (ctx, products, child) =>products.actionIcon),
                onPressed: () {
                  Provider.of<FavoriteProvider>(context,listen: false).searcklik("Favorite Movie",context);

                },
              ),
            ],
            backgroundColor: Colors.blue,
            // elevation: 1.0,

          ),
          backgroundColor: Colors.white70,

          //source code lanjutan
          //buat body untuk tab viewnya
          body: Scaffold(



            body: new RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () {
                  return refreshData(context, true);
                  //setState(() {return null;});
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    /*Container(
                      margin: EdgeInsets.only(top:10.0,left: 10.0,right: 10.0),
                      padding: EdgeInsets.all(10.0),
                      color: Colors.blue,
                      child: Center(
                        child: Text('Data Media Tersimpan',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      ),
                    ),*/
                    Expanded(
                      child:
                      Consumer<FavoriteProvider>(
                        builder: (ctx, produks, child) =>_buildList(produks.aturanList.length, "",produks.aturanList),

                      ),
                    )
                  ],
                )
            ),
          ),

        ),
      );
  }
}