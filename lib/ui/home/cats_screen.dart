import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zayed/custom_widgets/ad_item/ad_item.dart';
import 'package:zayed/custom_widgets/no_data/no_data.dart';
import 'package:zayed/custom_widgets/safe_area/page_container.dart';
import 'package:zayed/locale/app_localizations.dart';

import 'package:zayed/models/ad.dart';
import 'package:zayed/models/category.dart';
import 'package:zayed/providers/home_provider.dart';
import 'package:zayed/providers/navigation_provider.dart';
import 'package:zayed/ui/ad_details/ad_details_screen.dart';
import 'package:zayed/ui/home/widgets/category_item.dart';
import 'package:zayed/ui/home/widgets/map_widget.dart';
import 'package:zayed/ui/search/search_bottom_sheet.dart';
import 'package:zayed/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:zayed/utils/error.dart';
import 'package:zayed/providers/navigation_provider.dart';
import 'package:zayed/providers/auth_provider.dart';

class CatsScreen extends StatefulWidget {
  final String iddd;
  final int iddd1;
  CatsScreen({this.iddd,this.iddd1});
  @override
  State<StatefulWidget> createState() {
    return new _CatsScreenState(iddd: this.iddd,iddd1: this.iddd1);
  }
}


class _CatsScreenState extends State<CatsScreen> with TickerProviderStateMixin {
  double _height = 0, _width = 0;
  NavigationProvider _navigationProvider;
  Future<List<CategoryModel>> _categoryList;
  bool _initialRun = true;
  HomeProvider _homeProvider;
  AnimationController _animationController;
  AuthProvider _authProvider;

  final String iddd;
  final int iddd1;
  _CatsScreenState({this.iddd,this.iddd1});

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
   print(iddd);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _homeProvider = Provider.of<HomeProvider>(context);
      _homeProvider.updateChangesOnCategoriesList(iddd1);
      //_homeProvider.updateSelectedCategory(iddd1);
      _categoryList = _homeProvider.getCategoryList(categoryModel:  CategoryModel(isSelected:false ,catId:iddd,catName:
      AppLocalizations.of(context).translate('all'),catImage: 'assets/images/all.png'));
      _initialRun = false;


    }


  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildBodyItem() {
    return ListView(
      children: <Widget>[
        Container(
            height: _height * 0.18,
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(5,15,10,0),
            child: FutureBuilder<List<CategoryModel>>(
                future: _categoryList,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Center(
                        child: SpinKitFadingCircle(color: mainAppColor),
                      );
                    case ConnectionState.active:
                      return Text('');
                    case ConnectionState.waiting:
                      return Center(
                        child: SpinKitFadingCircle(color: mainAppColor),
                      );
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Error(
                          //  errorMessage: snapshot.error.toString(),
                          errorMessage: "حدث خطأ ما ",
                        );
                      } else {
                        if (snapshot.data.length > 0) {
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Consumer<HomeProvider>(

                                    builder: (context, homeProvider, child) {
                                      return InkWell(
                                        onTap: () => homeProvider
                                            .updateChangesOnCategoriesList(index),
                                        child: Container(
                                          width: _width * 0.20,
                                          child: CategoryItem(
                                            category: snapshot.data[index],
                                          ),
                                        ),
                                      );

                                    });
                              });
                        } else {
                          return NoData(message: 'لاتوجد نتائج');
                        }
                      }
                  }
                  return Center(
                    child: SpinKitFadingCircle(color: mainAppColor),
                  );
                })),
        Container(height: 0,),
       Padding(padding: _authProvider.currentLang == 'ar' ?EdgeInsets.only(right: 25):EdgeInsets.only(left: 25),child:  _authProvider.currentLang == 'ar' ? Text("إعلانات القسم",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),) :Text("Category Ads",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold)),)
        ,Container(height: 20,),
        Container(
            height: _height * 0.68,
            width: _width,
            child:
            Consumer<HomeProvider>(builder: (context, homeProvider, child) {
              return FutureBuilder<List<Ad>>(
                  future: homeProvider.enableSearch
                      ? Provider.of<HomeProvider>(context, listen: true)
                      .getAdsSearchList()
                      : Provider.of<HomeProvider>(context, listen: true)
                      .getAdsList(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Center(
                          child: SpinKitFadingCircle(color: mainAppColor),
                        );
                      case ConnectionState.active:
                        return Text('');
                      case ConnectionState.waiting:
                        return Center(
                          child: SpinKitFadingCircle(color: mainAppColor),
                        );
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Error(
                            //  errorMessage: snapshot.error.toString(),
                            errorMessage: "حدث خطأ ما ",
                          );
                        } else {
                          if (snapshot.data.length > 0) {
                            return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  var count = snapshot.data.length;
                                  var animation =
                                  Tween(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: Interval(
                                          (1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                  );
                                  _animationController.forward();
                                  return Container(
                                      height: 145,
                                      width: _width,
                                      child: InkWell(
                                          onTap: () {
                                            _homeProvider.setCurrentAds(snapshot
                                                .data[index].adsId);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AdDetailsScreen(
                                                          ad: snapshot
                                                              .data[index],
                                                        )));
                                          },
                                          child: AdItem(
                                            animationController:
                                            _animationController,
                                            animation: animation,
                                            ad: snapshot.data[index],
                                          )));
                                });
                          } else {
                            return NoData(message: 'لاتوجد نتائج');
                          }
                        }
                    }
                    return Center(
                      child: SpinKitFadingCircle(color: mainAppColor),
                    );
                  });
            }))

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _navigationProvider = Provider.of<NavigationProvider>(context);
    _authProvider = Provider.of<AuthProvider>(context);

    final appBar = AppBar(
      backgroundColor: mainAppColor,
      centerTitle: true,
      title: _authProvider.currentLang == 'ar' ? Text("الأقسام",style: TextStyle(fontSize: 20),) :Text("Categories",style: TextStyle(fontSize: 20)),


    );
    _height =  MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _navigationProvider = Provider.of<NavigationProvider>(context);

    return PageContainer(
      child: Scaffold(
        appBar: appBar,
        body: _buildBodyItem(),
      ),
    );
  }
}
