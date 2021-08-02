

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:imdb/generated/locale_keys.g.dart';
import 'package:imdb/models/movie_model.dart';
import 'package:imdb/constants.dart' as Constants;
import 'package:easy_localization/easy_localization.dart';
import 'package:imdb/providers/menu_provider.dart';
import 'package:provider/provider.dart';

class MovieProvider with ChangeNotifier {

  List<MovieModel> _aturanList = [];
  MovieModel _aturanModel = new MovieModel();

  Widget appBarTitle = new Text(LocaleKeys.title.tr());
  Icon actionIcon = new Icon(Icons.search);
  bool hideAutocomplete=true;
  TextEditingController ecari = TextEditingController();

  bool loading = false;
  bool firstly = false;
  bool loadingCenter = true;
  String imageBackdrop="";
  int page=1;
  setImageBackdrop(String url){
    this.imageBackdrop=url;
    notifyListeners();
  }
  getImageBacdrop(){
    return imageBackdrop;
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
      this.appBarTitle = new Text(LocaleKeys.title.tr());
      this.loading=true;
      getMovie(ctx,true,"0");
    }

    notifyListeners();
  }
  void onCari (String cari,BuildContext ctx) async {
    //CALL FUNGSI fetchProduct() DARI PROVIDERS Products.dart
    this.loading=true;
    if (cari.length>2) {
      //notifyListeners();
      await getMovie(ctx,true,cari);
    }else if (cari.length<=0) {
      await getMovie(ctx,true,"0");
    }
  }
  MovieModel get aturanModel {
    return _aturanModel;
  }


  List<MovieModel> get aturanList {
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
  setFirstly(bool firstly) {
    this.firstly = firstly;
    notifyListeners();
  }

  setAturanModel(MovieModel abc) {
    this._aturanModel = abc;
    notifyListeners();
  }

  Future<void> getMovie(BuildContext ctx,bool refresh,String q) async {
    //setFirstly(false);
    if (refresh){
      _aturanList = [];
      setLoadingCenter(true);
      page=1;
    }else{
      setLoading(true);
    }
    // q="0";
    if (q=="0")
      q="movie";


    var url = Constants.URL+"&s="+q+'&page='+page.toString();
    var dio = new Dio();
    var  response=null;
    List<MovieModel> newData = [];
    try {
      response = await dio.get(url); //MENGGUNAKAN AWAIT UNTUK MENUNGGU PROSESNYA SEBELUM MELANJUTKAN KE CODE SELANJUTNYA
    }on DioError catch(e) {

      this.loading=false;
      this.loadingCenter=false;
      _aturanList = newData;
      notifyListeners();
      return;
    }
    //var responseJson = jsonDecode(response.data);
    Map<String, dynamic> responseJson = response.data;
    if(responseJson["Response"]=="True"){
      List<dynamic> data = responseJson["Search"];
      //setAturanModel(responseJson);
      if (data!=null){
        page+=1;
        var convertData=data.map((m) => new MovieModel.fromJson(m)).toList();
        if (convertData == null) {
          return;
        }
        if (convertData.length>0){
          if (refresh==false){
            Provider.of<MenuProvider>(ctx, listen: false)
                .setImageBackdrop(convertData[0].poster);
            //imageBackdrop=url;
            _aturanList.addAll(convertData);
            this.loading=false;
          }else{
            _aturanList = convertData;
            this.loading=false;

          }
        }else{
          if (q!="0"){
            _aturanList=[];
          }
        }

        this.loadingCenter=false;
        notifyListeners();
      }else{
        this.loading=false;
        this.loadingCenter=false;
        //_aturanList=[];
        notifyListeners();
        return;
      }
    }else{
      if (q!="0"){
        _aturanList=[];
        this.loading=false;
        this.loadingCenter=false;
        notifyListeners();
      }
    }

  }
  Future<void> getMovieDetail(BuildContext ctx,String q) async {
    //setFirstly(false);

    setLoadingCenter(true);
    var url = Constants.URL+"&i="+q+"&plot=full";
    var dio = new Dio();

    var  response=null;
    List<MovieModel> newData = [];
    try {
      response = await dio.get(url); //MENGGUNAKAN AWAIT UNTUK MENUNGGU PROSESNYA SEBELUM MELANJUTKAN KE CODE SELANJUTNYA
    }on DioError catch(e) {

      this.loading=false;
      this.loadingCenter=false;
      _aturanList = newData;
      notifyListeners();
      return;
    }
    var responseJson = MovieModel.fromJson(response.data);
    // Map<String, dynamic> responseJson = response.data;

    //setAturanModel(responseJson);
    if (responseJson!=null){
      page+=1;
      var convertData=responseJson;
      if (convertData == null) {
        return;
      }


      _aturanModel = convertData;
      this.loading=false;

      this.loadingCenter=false;
      notifyListeners();
    }else{
      this.loading=false;
      this.loadingCenter=false;
      //_aturanList=[];
      notifyListeners();
      return;
    }
  }
}