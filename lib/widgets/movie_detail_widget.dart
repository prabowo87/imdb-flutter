

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imdb/models/movie_model.dart';
import 'package:provider/provider.dart';


class MovieDetailWidget extends StatelessWidget{
  final MovieModel gm;

  //BUAT CONSTRUCTOR UNTUK MEMINTA DATA DARI WIDGET YANG MENGGUNAKANNYA
  MovieDetailWidget(this.gm);

  @override
  Widget build(BuildContext context) {
    //DISMISSIBLE, KETIKA ITEM PRODUKNYA DI GESER MAKA KITA AKAN MENJALANKAN ACTIONS


    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          delegate: CustomSliverAppBarDelegate(expandedHeight: 200,gm:gm),
          pinned: true,
        ),

        new SliverList(
            delegate: new SliverChildListDelegate(_buildList(50,gm))
        ),
      ],
    );
  }

}
List<Widget> _buildList(int count,MovieModel gm) {
  List<Widget> listItems = [];
  listItems.add(SizedBox(height: 75,));
  listItems.add(
      Padding(
        padding: new EdgeInsets.only(left:20.0,right: 20.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Release - "+gm.released,style: TextStyle(fontWeight: FontWeight.bold),),
                Text("Genre - "+gm.genre,style: TextStyle(fontWeight: FontWeight.bold),),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Text("Duration -",style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(width: 8,),
                    Text(gm.runtime,style: TextStyle(fontWeight: FontWeight.bold),)
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Text("Rating -",style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(width: 8,),
                    Icon(Icons.star,color: Colors.blue,size: 16,),
                    Text(gm.imdbRating+"/10"+" . "+gm.imdbVotes,style: TextStyle(fontWeight: FontWeight.bold),)
                  ],
                )
              ],
            ),
          ),
        ),
      )
  );
  listItems.add(
    Padding(
      padding: new EdgeInsets.only(left:20.0,right: 20.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(gm.plot)
            ],
          ),
        ),
      ),
    )
  );
  listItems.add(
      Padding(
        padding: new EdgeInsets.only(left:20.0,right: 20.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Director - "+gm.director,style: TextStyle(fontWeight: FontWeight.bold),),
                Text("Writer - "+gm.writer,style: TextStyle(fontWeight: FontWeight.bold),),
                Text("Actors - "+gm.actors,style: TextStyle(fontWeight: FontWeight.bold),),
                Text("Production - "+gm.production,style: TextStyle(fontWeight: FontWeight.bold),),

              ],
            ),
          ),
        ),
      )
  );

  return listItems;
}

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double? expandedHeight;
  final MovieModel? gm;

  const CustomSliverAppBarDelegate({
    @required this.expandedHeight,this.gm
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = 60;
    final top = (expandedHeight! - shrinkOffset - size / 2)-10;

    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        buildBackground(shrinkOffset),
        buildAppBar(shrinkOffset),
        Positioned(
          top: top,
          left: 20,
          right: 20,
          child: buildFloating(shrinkOffset),
        ),
      ],
    );
  }

  double appear(double shrinkOffset) => shrinkOffset / expandedHeight!;

  double disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight!;

  Widget buildAppBar(double shrinkOffset) => Opacity(
    opacity: appear(shrinkOffset),
    child: AppBar(
      title: Text(gm!.title),
      centerTitle: true,
    ),
  );

  Widget buildBackground(double shrinkOffset) => Opacity(
    opacity: disappear(shrinkOffset),
    child: CachedNetworkImage(
      imageUrl: gm!.poster,
      // placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      fit: BoxFit.cover,
      alignment: Alignment.center,

    ),
  );

  Widget buildFloating(double shrinkOffset) => Opacity(
    opacity: disappear(shrinkOffset),
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(gm!.title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 8,),
            Text(gm!.year)
          ],
        ),
      ),
    ),
  );


  @override
  double get maxExtent => expandedHeight!;

  @override
  double get minExtent => kToolbarHeight ;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
