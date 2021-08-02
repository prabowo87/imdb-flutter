import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imdb/models/movie_model.dart';
import 'package:imdb/providers/movie_provider.dart';
import 'package:imdb/widgets/movie_detail_widget.dart';
import 'package:provider/provider.dart';

class MovieDetailPage extends StatefulWidget {
  MovieDetailPage({Key? key}) : super(key: key);
  // HomePage({@required String title}) : title = title;
  static const routeName = "/move_detail_page";

  @override
  _MovieDetailPage createState() => _MovieDetailPage();
}

class _MovieDetailPage extends State<MovieDetailPage> with TickerProviderStateMixin {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =new GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData(BuildContext context,String id) async {
    await Provider.of<MovieProvider>(context, listen: false).getMovieDetail(context,id);
  }
  @override
  void initState() {


    super.initState();

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
  Widget _buildList(MovieProvider mp) {
    if (!mp.loadingCenter){
      return MovieDetailWidget(mp.aturanModel);
    }else{
      return Consumer<MovieProvider>(
          builder: (ctx, waiting, child) =>Center(
            child: waiting.loadingCenter?new Opacity(
              opacity: 1,
              child: new CircularProgressIndicator(),
            ):Column(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,children: [Center(child:Text('Data tidak ditemukan')),IconButton(
                icon: new Icon(Icons.refresh,size: 36,),
                onPressed: () {
                  setState(() {});
                },)],),
          ));
    }


  }
  @override
  Widget build(BuildContext context) {
    MovieModel? args = ModalRoute.of(context)!.settings.arguments as MovieModel?;
    _refreshData(context, args!.imdbID);
    return SafeArea(
      child: Scaffold(

        body: RefreshIndicator(
          onRefresh: () {
            return _refreshData(context, args.imdbID);
            //setState(() {return null;});
          },
          key: _refreshIndicatorKey,
          child: Consumer<MovieProvider>(
            builder: (ctx, produks, child) =>_buildList(produks),

          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}