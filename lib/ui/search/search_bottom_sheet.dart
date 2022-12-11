import 'package:flutter/material.dart';
import 'package:zayed/custom_widgets/buttons/custom_button.dart';
import 'package:zayed/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:zayed/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:zayed/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'package:zayed/locale/app_localizations.dart';
import 'package:zayed/models/category.dart';
import 'package:zayed/models/city.dart';
import 'package:zayed/models/country.dart';
import 'package:zayed/providers/home_provider.dart';
import 'package:zayed/utils/app_colors.dart';
import 'package:provider/provider.dart';

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({Key key}) : super(key: key);
  @override
  _SearchBottomSheetState createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> with ValidationMixin
  {
  String _keySearch = '';
  Future<List<City>> _cityList;
  Future<List<CategoryModel>> _categoryList;
  Future<List<Country>> _countryList;
  City _selectedCity;
  Country _selectedCountry;
  CategoryModel _selectedCategory;
  bool _initialRun = true;
  HomeProvider _homeProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _homeProvider = Provider.of<HomeProvider>(context);
            _categoryList = _homeProvider.getCategoryList(categoryModel:  CategoryModel(isSelected:true ,catId: '0',catName: 
      AppLocalizations.of(context).translate('all'),catImage: 'assets/images/all.png'));
      _countryList = _homeProvider.getCountryList();
      _cityList = _homeProvider.getCityList(enableCountry: false);
      _initialRun = false;
    }
  }

  Widget build(BuildContext context) {


    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus( FocusNode());
            },
            child: Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: ListView(children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: mainAppColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                    ),
                    child: Text(
                     AppLocalizations.of(context).translate('search_now'),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    )),
              
                Container(
                  margin: EdgeInsets.only(top: constraints.maxHeight * 0.04),
                  child: InkWell(
                    onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                    child: CustomTextFormField(
                        hintTxt: AppLocalizations.of(context).translate('enter_search_key'),
                      
                        onChangedFunc: (String text) {
                          _keySearch = text;
                        }),
                  ),
            ),
                Container(
                    margin: EdgeInsets.symmetric(
                        vertical: constraints.maxHeight * 0.04),
                    child: FutureBuilder<List<CategoryModel>>(
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
                    )),
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
                          hint: AppLocalizations.of(context).translate('choose_country'),
                          onChangeFunc: (newValue) {
                            setState(() {
                              _selectedCountry = newValue;
                              _cityList = _homeProvider.getCityList(
                                  enableCountry: true,
                                  countryId: _selectedCountry.countryId);
                              _selectedCity = null;
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
                  margin: EdgeInsets.symmetric(
                      vertical: constraints.maxHeight * 0.04),
                  child: FutureBuilder<List<City>>(
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
                            hint: AppLocalizations.of(context).translate('choose_city'),
                            onChangeFunc: (newValue) {
                              setState(() {
                                _selectedCity = newValue;
                              });
                            },
                            value: _selectedCity,
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
                ),



                CustomButton(
                  btnLbl:  AppLocalizations.of(context).translate('search'),
                  onPressedFunction: () {
                 if (
checkSearchValidation(context, keysearch:_keySearch,
searchCategory: _selectedCategory)){
   _homeProvider.setEnableSearch(true);
                    _homeProvider.setSearchKey(_keySearch);
                    _homeProvider.updateSelectedCategory(_selectedCategory);
                    _homeProvider.setSelectedCountry(_selectedCountry);
                     _homeProvider.setSelectedCity(_selectedCity);
                     Navigator.pop(context);
                     Navigator.pushReplacementNamed(context,  '/navigation');
}
                   
                  },
                ),
              ]),
            ),
          ));
    });
  }
}
