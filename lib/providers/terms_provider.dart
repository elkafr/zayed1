import 'package:flutter/material.dart';
import 'package:zayed/networking/api_provider.dart';
import 'package:zayed/utils/urls.dart';

import 'auth_provider.dart';

class TermsProvider extends ChangeNotifier{
   ApiProvider _apiProvider = ApiProvider();
    
 String _currentLang;


  void update(AuthProvider authProvider) {
 
    _currentLang = authProvider.currentLang;
  }
  Future<String> getTerms() async {
    final response =
        await _apiProvider.get(Urls.TERMS_URL +"?api_lang=$_currentLang");
    String terms = '';
    if (response['response'] == '1') {
      terms = response['messages'];
    }
    return terms;
  }
}