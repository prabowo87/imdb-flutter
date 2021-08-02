import 'package:flutter/material.dart';
import 'package:imdb/generated/locale_keys.g.dart';
import 'package:imdb/models/movie_model.dart';
import 'package:imdb/providers/movie_provider.dart';
import 'package:imdb/widgets/movie_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  // HomePage({@required String title}) : title = title;
  static const routeName = "/home_page";

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =new GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData(BuildContext context,bool refresh) async {
    await Provider.of<MovieProvider>(context, listen: false).getMovie(context,refresh,"0");
  }
  @override
  void initState() {

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {

        _refreshData(context,false);
      }
    });
    _refreshData(context, true);
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
        child: Consumer<MovieProvider>(
            builder: (ctx, waiting, child) {
              return new Opacity(
                opacity: waiting.loading?1:0,
                child: new CircularProgressIndicator(),
              );

            }),
      ),
    );
  }
  Widget _buildList(int jumlah,String link,List<MovieModel> product) {
    if (product.length>0){
      return ListView.builder(

        itemCount: jumlah+1,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int i) {
          if (i == jumlah) {
            return _buildProgressIndicator();
          } else {
            return MovieListWidget(gm:product[i]);


          }
        },
        controller: _scrollController,
      );
    }else{
      return Consumer<MovieProvider>(
          builder: (ctx, waiting, child) =>Center(
            child: waiting.loadingCenter?new Opacity(
              opacity: 1,
              child: new CircularProgressIndicator(),
            ):Column(mainAxisAlignment: MainAxisAlignment.center,
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


    return RefreshIndicator(
      onRefresh: () {
        return _refreshData(context, true);
        //setState(() {return null;});
      },
      key: _refreshIndicatorKey,
      child: Consumer<MovieProvider>(
        builder: (ctx, produks, child) =>_buildList(produks.aturanList.length, "",produks.aturanList),

      ),
    );
  }
}