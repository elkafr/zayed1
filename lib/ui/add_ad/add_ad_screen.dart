import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zayed/custom_widgets/buttons/custom_button.dart';
import 'package:zayed/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:zayed/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:zayed/custom_widgets/dialogs/confirmation_dialog.dart';
import 'package:zayed/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'package:zayed/custom_widgets/safe_area/page_container.dart';
import 'package:zayed/locale/app_localizations.dart';
import 'package:zayed/models/category.dart';
import 'package:zayed/models/city.dart';
import 'package:zayed/models/country.dart';
import 'package:zayed/networking/api_provider.dart';
import 'package:zayed/providers/auth_provider.dart';
import 'package:zayed/providers/home_provider.dart';
import 'package:zayed/providers/navigation_provider.dart';
import 'package:zayed/utils/app_colors.dart';
import 'package:zayed/utils/commons.dart';
import 'package:zayed/utils/urls.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;
import 'dart:math' as math;

class AddAdScreen extends StatefulWidget {
  @override
  _AddAdScreenState createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> with ValidationMixin {
  double _height = 0, _width = 0;
  final _formKey = GlobalKey<FormState>();
  Future<List<Country>> _countryList;
  Future<List<City>> _cityList;
  Future<List<CategoryModel>> _categoryList;
  Country _selectedCountry;
  City _selectedCity;
  CategoryModel _selectedCategory;
  bool _initialRun = true;
  HomeProvider _homeProvider;
  List<String> _genders ;

  File _imageFile;
  File _imageFile1;
  File _imageFile2;
  File _imageFile3;


  dynamic _pickImageError;
  final _picker = ImagePicker();
  AuthProvider _authProvider;
  ApiProvider _apiProvider =ApiProvider();
  bool _isLoading = false;
  String _adsTitle = '', _adsPrice = '', _adsDescription = '';
  NavigationProvider _navigationProvider;
  LocationData _locData;


  String _error;


  Future<void> _getCurrentUserLocation() async {
     _locData = await Location().getLocation();
    if(_locData != null){
      print('lat' + _locData.latitude.toString());
      print('longitude' + _locData.longitude.toString());
      Commons.showToast(context, message:
        AppLocalizations.of(context).translate('detect_location'));
        setState(() {

        });
    }
  }


  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      _imageFile = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }


  void _onImageButtonPressed1(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      _imageFile1 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }


  void _onImageButtonPressed2(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      _imageFile2 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }


  void _onImageButtonPressed3(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      _imageFile3 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _genders = [AppLocalizations.of(context).translate('male'),
      AppLocalizations.of(context).translate('female'),
      AppLocalizations.of(context).translate('undefined')];
      _homeProvider = Provider.of<HomeProvider>(context);
      _categoryList = _homeProvider.getCategoryList(categoryModel:  CategoryModel(isSelected:false ,catId: '0',catName:
      AppLocalizations.of(context).translate('total'),catImage: 'assets/images/all.png'));
      _countryList = _homeProvider.getCountryList();
      _cityList = _homeProvider.getCityList(enableCountry: true,countryId:'500');
      _initialRun = false;
    }
  }




  void _settingModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.subject),
                    title: new Text('Gallery'),
                    onTap: (){
                      _onImageButtonPressed(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: (){
                      _onImageButtonPressed(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
              ],
            ),
          );
        }
    );
  }


  void _settingModalBottomSheet1(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.subject),
                    title: new Text('Gallery'),
                    onTap: (){
                      _onImageButtonPressed1(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: (){
                      _onImageButtonPressed1(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
              ],
            ),
          );
        }
    );
  }


  void _settingModalBottomSheet2(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.subject),
                    title: new Text('Gallery'),
                    onTap: (){
                      _onImageButtonPressed2(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: (){
                      _onImageButtonPressed2(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
              ],
            ),
          );
        }
    );
  }


  void _settingModalBottomSheet3(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.subject),
                    title: new Text('Gallery'),
                    onTap: (){
                      _onImageButtonPressed3(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: (){
                      _onImageButtonPressed3(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
              ],
            ),
          );
        }
    );
  }

  Widget _buildBodyItem() {
    var genders = _genders.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
        value: item,
      );
    }).toList();
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),



            Container(
              padding: EdgeInsets.all(10),
              child: Text(_homeProvider.currentLang=='ar'?"صور الاعلان":"Ad photos"),
            ),

            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(5)),
                GestureDetector(
                    onTap: (){
                      _settingModalBottomSheet(context);
                    },
                    child: Container(
                      height: _height * 0.1,
                      width: _width*.22,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        border: Border.all(
                          color: hintColor.withOpacity(0.4),
                        ),
                        color: Colors.grey[100],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: _imageFile != null
                          ?ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child:  Image.file(
                            _imageFile,
                            // fit: BoxFit.fill,
                          ))
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/images/newadd.png'),

                        ],
                      ),
                    )),

                Padding(padding: EdgeInsets.all(5)),

                GestureDetector(
                    onTap: (){
                      _settingModalBottomSheet1(context);
                    },
                    child: Container(
                      height: _height * 0.1,
                      width: _width*.22,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        border: Border.all(
                          color: hintColor.withOpacity(0.4),
                        ),
                        color: Colors.grey[100],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: _imageFile1 != null
                          ?ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child:  Image.file(
                            _imageFile1,
                            // fit: BoxFit.fill,
                          ))
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/images/newadd.png'),

                        ],
                      ),
                    )),

                Padding(padding: EdgeInsets.all(5)),

                GestureDetector(
                    onTap: (){
                      _settingModalBottomSheet2(context);
                    },
                    child: Container(
                      height: _height * 0.1,
                      width: _width*.22,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        border: Border.all(
                          color: hintColor.withOpacity(0.4),
                        ),
                        color: Colors.grey[100],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: _imageFile2 != null
                          ?ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child:  Image.file(
                            _imageFile2,
                            // fit: BoxFit.fill,
                          ))
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/images/newadd.png'),

                        ],
                      ),
                    )),

                Padding(padding: EdgeInsets.all(5)),

                GestureDetector(
                    onTap: (){
                      _settingModalBottomSheet3(context);
                    },
                    child: Container(
                      height: _height * 0.1,
                      width: _width*.22,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        border: Border.all(
                          color: hintColor.withOpacity(0.4),
                        ),
                        color: Colors.grey[100],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: _imageFile3 != null
                          ?ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child:  Image.file(
                            _imageFile3,
                            // fit: BoxFit.fill,
                          ))
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/images/newadd.png'),


                        ],
                      ),
                    )),

              ],

            ),





            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.02),
              child: CustomTextFormField(
                hintTxt: AppLocalizations.of(context).translate('ad_title'),
                onChangedFunc: (text) {
                  _adsTitle = text;
                },
                validationFunc: validateAdTitle,
              ),
            ),
            FutureBuilder<List<CategoryModel>>(
              future: _categoryList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.hasData) {
                    var categoryList = snapshot.data.map((item) {
                      return new DropdownMenuItem<CategoryModel>(
                        child: new Text(item.catName),
                        value: item,
                      );
                    }).toList();
                    return DropDownListSelector(
                      dropDownList: categoryList,
                      hint: AppLocalizations.of(context).translate('choose_category'),
                      onChangeFunc: (newValue) {
                         FocusScope.of(context).requestFocus( FocusNode());
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                      value: _selectedCategory,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return Center(child: CircularProgressIndicator());
              },
            ),

            Container(
              margin: EdgeInsets.only(top: _height * 0.02,bottom: _height * 0.01),
              child: CustomTextFormField(
                hintTxt:  AppLocalizations.of(context).translate('ad_price'),
                onChangedFunc: (text) {
                  _adsPrice = text;
                },
                validationFunc: validateAdPrice,
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: _height * 0.01,bottom: _height * 0.01),
            ),
            FutureBuilder<List<Country>>(
              future: _countryList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.hasData) {
                    var countryList = snapshot.data.map((item) {
                      return new DropdownMenuItem<Country>(
                        child: new Text(item.countryName),
                        value: item,
                      );
                    }).toList();
                    return DropDownListSelector(
                      dropDownList: countryList,
                      hint:  AppLocalizations.of(context).translate('choose_country'),
                      onChangeFunc: (newValue) {
                        FocusScope.of(context).requestFocus( FocusNode());
                        setState(() {
                          _selectedCountry = newValue;
                          _selectedCity=null;
                          _homeProvider.setSelectedCountry(newValue);
                          _cityList = _homeProvider.getCityList(enableCountry: true,countryId:_homeProvider.selectedCountry.countryId);
                        });
                      },

                      value: _selectedCountry,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
            Container(
              margin: EdgeInsets.only(top: _height * 0.02),
            ),
            FutureBuilder<List<City>>(
              future: _cityList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.hasData) {
                    var cityList = snapshot.data.map((item) {
                      return new DropdownMenuItem<City>(
                        child: new Text(item.cityName),
                        value: item,
                      );
                    }).toList();
                    return DropDownListSelector(
                      dropDownList: cityList,
                      hint:  AppLocalizations.of(context).translate('choose_city'),
                      onChangeFunc: (newValue) {
                         FocusScope.of(context).requestFocus( FocusNode());
                        setState(() {
                          _selectedCity = newValue;
                        });
                      },
                      value: _selectedCity,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                } else    if (snapshot.hasError) {
                  DioError error = snapshot.error;
                  String message = error.message;
                  if (error.type == DioErrorType.CONNECT_TIMEOUT)
                    message = 'Connection Timeout';
                  else if (error.type ==
                      DioErrorType.RECEIVE_TIMEOUT)
                    message = 'Receive Timeout';
                  else if (error.type == DioErrorType.RESPONSE)
                    message =
                    '404 server not found ${error.response.statusCode}';
                  print(message);
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.02),
              child: CustomTextFormField(
                maxLines: 3,
                hintTxt:  AppLocalizations.of(context).translate('ad_description'),
                validationFunc: validateAdDescription,
                onChangedFunc: (text) {
                  _adsDescription = text;
                },
              ),
            ),
            Container(
                width: _locData == null ? _width * 0.5 : _width *0.55,
                child: CustomButton(
                  btnColor: Colors.white,
                  borderColor: accentColor,
                  onPressedFunction: (){
  _getCurrentUserLocation();

                  },
                  btnStyle: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                  btnLbl: _locData == null ? AppLocalizations.of(context).translate('choose_location') : AppLocalizations.of(context).translate('detect_location'),
                )),
            CustomButton(
              btnLbl: AppLocalizations.of(context).translate('publish_ad'),
              btnColor: accentColor,
              onPressedFunction: () async {
                if (_formKey.currentState.validate() &
                    checkAddAdValidation(context,
                    imgFile: _imageFile,
                        adMainCategory: _selectedCategory,
                        adCity: _selectedCity)) {
                          if(_locData != null){
                               FocusScope.of(context).requestFocus( FocusNode());
                             setState(() => _isLoading = true);

                               String fileName = (_imageFile!=null)?Path.basename(_imageFile.path):"";
                               String fileName1 = (_imageFile1!=null)?Path.basename(_imageFile1.path):"";
                               String fileName2 = (_imageFile2!=null)?Path.basename(_imageFile2.path):"";
                               String fileName3 = (_imageFile3!=null)?Path.basename(_imageFile3.path):"";

                  FormData formData = new FormData.fromMap({
                    "user_id": _authProvider.currentUser.userId,
                    "ads_title": _adsTitle,
                    "ads_details": _adsDescription,
                    "ads_cat": _selectedCategory.catId,
                    "ads_country": _selectedCountry.countryId,
                    "ads_city": _selectedCity.cityId,
                    "ads_price": _adsPrice,
                    "ads_location":'${_locData.latitude},${_locData.longitude}',
                    "imgURL[0]": (_imageFile!=null)?await MultipartFile.fromFile(_imageFile.path, filename: fileName):"",
                    "imgURL[1]": (_imageFile1!=null)?await MultipartFile.fromFile(_imageFile1.path, filename: fileName1):"",
                    "imgURL[2]": (_imageFile2!=null)?await MultipartFile.fromFile(_imageFile2.path, filename: fileName2):"",
                    "imgURL[3]": (_imageFile3!=null)?await MultipartFile.fromFile(_imageFile3.path, filename: fileName3):"",
                  });
                  final results = await _apiProvider
                      .postWithDio(Urls.ADD_AD_URL + "?api_lang=${_authProvider.currentLang}", body: formData);
                  setState(() => _isLoading = false);

                  if (results['response'] == "1") {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) {
                          return ConfirmationDialog(
                            title: AppLocalizations.of(context).translate('ad_has_published_successfully'),
                            message:
                                AppLocalizations.of(context).translate('ad_published_and_manage_my_ads'),
                          );
                        });
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pop(context);
                       Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/my_ads_screen');
                      _navigationProvider.upadateNavigationIndex(4);
                    });
                  } else {
                    Commons.showError(context, results["message"]);
                  }
                          }
                          else{
                            Commons.showToast(context, message: AppLocalizations.of(context).translate('ad_location_validation'));
                          }

                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);
    _navigationProvider = Provider.of<NavigationProvider>(context);
    return PageContainer(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          _buildBodyItem(),
          Container(
              height: 60,
              decoration: BoxDecoration(
                color: mainAppColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Consumer<AuthProvider>(
                      builder: (context,authProvider,child){
                        return authProvider.currentLang == 'ar' ? Image.asset(
                      'assets/images/back.png',
                      color: Colors.white,
                    ): Transform.rotate(
                            angle: 180 * math.pi / 180,
                            child:  Image.asset(
                      'assets/images/back.png',
                      color: Colors.white,
                    ));
                      },
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  Text(AppLocalizations.of(context).translate('add_ad'),

                      style: Theme.of(context).textTheme.headline1),
                  Spacer(
                    flex: 3,
                  ),
                ],
              )),
          _isLoading
              ? Center(
                  child: SpinKitFadingCircle(color: mainAppColor),
                )
              : Container()
        ],
      )),
    );
  }
}



