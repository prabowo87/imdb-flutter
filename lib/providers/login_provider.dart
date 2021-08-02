import 'package:flutter/material.dart';
import 'package:imdb/constants.dart' as constants;
class LoginProvider extends ChangeNotifier{
  bool loading = false;
  bool isLogin = false;
  String response ="";
  setLoading(bool loading) {
    this.loading = loading;
    notifyListeners();
  }
  bool checkLogin(String username,String passwrod){
    setLoading(true);
    response="";
    if (username == constants.userName && passwrod == constants.password){
      isLogin = true;
      loading = false;
      response = constants.loginSuccess;
      notifyListeners();

    }else{
      isLogin=false;

      response = constants.loginFailed;
      setLoading(false);
    }
    return isLogin;
  }


}