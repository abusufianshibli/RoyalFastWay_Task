import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:royal_fastway_task/models/profile_model.dart';
import 'package:http/http.dart' as http;

class ProfileInfo with ChangeNotifier{
  ProfilleModel _profilleModel =null;

  ProfilleModel get profileinfo{
    if(_profilleModel!=null){
      return _profilleModel;
    }
  }

  Future GetProfileInfo()async{
    var url="https://reqres.in/api/users/2";
    var response=await http.get(url);
    ProfilleModel profilleModel=ProfilleModel.fromJson(jsonDecode(response.body));
    _profilleModel=profilleModel;
    notifyListeners();
  }

}