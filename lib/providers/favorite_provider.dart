

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imdb/generated/locale_keys.g.dart';
import 'package:imdb/localdb/db_helper.dart';
import 'package:imdb/localdb/favorite_model.dart';
import 'package:imdb/models/movie_model.dart';
import 'package:easy_localization/easy_localization.dart';

class FavoriteProvider with ChangeNotifier {

  List<FavoriteModel> _aturanList = [];
  MovieModel _bookmarkModel = new MovieModel();
  bool responseTrans = false;
  bool loading = false;
  bool loadingCenter = true;
  Widget appBarTitle = new Text(LocaleKeys.favorite.tr(),style: TextStyle(color: Colors.white),);
  Icon actionIcon = new Icon(Icons.search,color: Colors.white,);
  TextEditingController ecari = TextEditingController();
  bool hideAutocomplete=true;


  MovieModel get bookmarkModel {
    return _bookmarkModel;
  }
  setBookmarkModel(MovieModel abc) {
    this._bookmarkModel = abc;
    notifyListeners();
  }
  List<FavoriteModel> get aturanList {
    return _aturanList;
  }

  setLoading(bool loading) {
    this.loading = loading;
    notifyListeners();
  }

  setLoadingCenter(bool loading) {
    this.loadingCenter = loading;
    // notifyListeners();
  }
  setHideAutoComplete(bool kondisi){
    this.hideAutocomplete=kondisi;
    // clearItems();
    notifyListeners();
  }

  searcklik(String title,BuildContext ctx){

    if ( this.actionIcon.icon == Icons.search){
      this.actionIcon = new Icon(Icons.close);
      this.appBarTitle = new TextFormField(
        minLines: 1,
        //     initialValue: "",
        textInputAction: TextInputAction.search,
        cursorColor:Colors.white,
        controller: ecari,
        onChanged: (text){
          onCari(text,ctx);
        },
        style: new TextStyle(
          color: Colors.white,
          fontSize: 16,

        ),
        decoration: new InputDecoration(
          //prefixIcon: new Icon(Icons.search,color: Colors.white),

            hintText: LocaleKeys.search.tr(),
            hintStyle: new TextStyle(color: Colors.white)
        ),
      );
    }else {
      ecari.text="";

      this.actionIcon = new Icon(Icons.search,color: Colors.white,);
      this.appBarTitle = new Text(LocaleKeys.favorite.tr());
      this.loading=true;
      getBookmark(ctx,true,"");
    }

    notifyListeners();
  }
  void onCari (String cari,BuildContext ctx) async {
    //CALL FUNGSI fetchProduct() DARI PROVIDERS Products.dart
    this.loading=true;
    if (cari.length>2) {
      //notifyListeners();
      await getBookmark(ctx,true,cari);
    }else if (cari.length<=0) {
      await getBookmark(ctx,true,"");
    }
  }
  Future<void> getBookmark(BuildContext ctx,bool refresh,String q) async {
    if (refresh){
      _aturanList = [];
      setLoadingCenter(true);
    }
    if (ecari.text!=null && ecari.text!="")
      q=ecari.text.toString();
    else q="";
    int page=_aturanList.length;

    List<FavoriteModel> newData = [];
    var dbHelper =new DbHelper();
    newData= await dbHelper.getFavorite(q);

    //setAturanModel(responseJson);
    if (newData.length>0){

      if (refresh==false){
        _aturanList.addAll(newData);
        this.loading=false;
      }else{
        _aturanList = newData;
        this.loading=false;
      }
      this.loadingCenter=false;
      notifyListeners();
    }else{
      this.loading=false;
      this.loadingCenter=false;
      _aturanList=[];
      notifyListeners();
      return;
    }

  }

  Future<int> insertBookmark(BuildContext ctx,MovieModel movieModel) async {

    var dbHelper =new DbHelper();

    var newData = await dbHelper.insertMedia(movieModel);
    return newData;
    //Provider.of<MovieProvider>(ctx).getFavorite(imdbID)

    /*int newData= await dbHelper.insertMedia(FavoriteModel,bookmarkModel.id.toString());

    //setAturanModel(responseJson);
    if (newData>0){
      responseTrans=true;
      Toast.show("Media sudah dibookmark", ctx);
      return;
    }else{
      responseTrans=false;
      Toast.show("Media gagal dibookmark", ctx);
      notifyListeners();
      return;
    }*/

  }
  Future<void> deleteBookmark(BuildContext ctx,FavoriteModel bookmarkModel) async {

    /*var dbHelper =new DbHelper();


    int newData= await dbHelper.deleteRowMedia(bookmarkModel);

    //setAturanModel(responseJson);
    if (newData>0){
      responseTrans=true;
      getBookmark(ctx,true,ecari.text);
      //notifyListeners();
      Toast.show("Media sudah dihapus", ctx);
      return;
    }else{
      responseTrans=false;
      Toast.show("Media gagal dihapus", ctx);
      //notifyListeners();
      return;
    }*/

  }
}