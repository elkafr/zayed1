import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zayed/models/ad.dart';
import 'package:zayed/ui/home/widgets/category_item1.dart';
import 'package:zayed/utils/app_colors.dart';
import 'package:zayed/utils/app_colors.dart';
import 'package:zayed/utils/urls.dart';
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
import 'package:zayed/ui/home/widgets/slider_images.dart';
import 'package:zayed/ui/home/cats_screen.dart';
import 'package:zayed/networking/api_provider.dart';
import 'package:zayed/providers/auth_provider.dart';
import 'package:zayed/utils/urls.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  double _height = 0, _width = 0;
  NavigationProvider _navigationProvider;
 Future<List<CategoryModel>> _categoryList;
  bool _initialRun = true;
  HomeProvider _homeProvider;
  AnimationController _animationController;
  AuthProvider _authProvider;
  Future<List<Ad>> _sacrificesList;
  ApiProvider _apiProvider = ApiProvider();
  String xx='';


  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }
    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _homeProvider = Provider.of<HomeProvider>(context);
      _categoryList = _homeProvider.getCategoryList(categoryModel:  CategoryModel(isSelected:false));
      _initialRun = false;
    }
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  Future<List<Ad>> _getSearchResults(String title) async {
    Map<String, dynamic> results =
    await _apiProvider.get(Urls.SEARCH_URL +'title=$title');
    List<Ad> adList = List<Ad>();
    if (results['response'] == '1') {
      Iterable iterable = results['results'];
      adList = iterable.map((model) => Ad.fromJson(model)).toList();
    } else {
      print('error');
    }
    return adList;
  }

  Widget _buildBodyItem() {

    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;

    final orientation = MediaQuery.of(context).orientation;
    return ListView(
      children: <Widget>[
        Container(height: 20,),
        SliderImages(),

        Container(
            height: 45,
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
            child: TextFormField(
                cursorColor: hintColor,
                maxLines: 1,
                onChanged: (text) {
                  _sacrificesList =   _getSearchResults(text);
                  setState(() {
                    xx=text;
                  });
                },
                style: TextStyle(
                    color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: accentColor),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                  suffixIcon: Image.asset(
                    'assets/images/search.png',
                    color: hintColor,
                  ),
                  hintText: _authProvider.currentLang == 'ar' ? "بحث":"Search",
                  errorStyle: TextStyle(fontSize: 12.0),
                  hintStyle: TextStyle(
                      color: hintColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ))),

    Container(

      child: SingleChildScrollView(

        child: Column(

          children: <Widget>[
            (xx=='')?Container(
                height: _height-350,
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(5,10,10,0),
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
                              return GridView.builder(
                                itemCount: snapshot.data.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: (orientation == Orientation.portrait) ? 3 : 3),
                                itemBuilder: (BuildContext context, int index) {
                                  return Consumer<HomeProvider>(
                                      builder: (context, homeProvider, child) {
                                        return InkWell(
                                          onTap: (){

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => CatsScreen(iddd:snapshot.data[index].catId,iddd1:index))
                                            );
                                          },
                                          child: Container(
                                            width: _width * 0.33,
                                            child: CategoryItem1(
                                              category: snapshot.data[index],
                                            ),
                                          ),
                                        );
                                      });
                                },
                              );
                            } else {
                              return NoData(message: 'لاتوجد نتائج');
                            }
                          }
                      }
                      return Center(
                        child: SpinKitFadingCircle(color: mainAppColor),
                      );
                    })):Container(
                height: _height-350,
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
        ),
      ),
    ),





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
      title: _authProvider.currentLang == 'ar' ? Text("سوق زايد",style: TextStyle(fontSize: 17),) :Text("Zayed Market",style: TextStyle(fontSize: 17)),
      actions: <Widget>[
        GestureDetector(
            onTap: () {
              showModalBottomSheet<dynamic>(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  context: context,
                  builder: (builder) {
                    return Container(
                        width: _width,
                        height: _height * 0.9,
                        child: SearchBottomSheet());
                  });
            },
            child: Image.asset('assets/images/flag-round.png')),


      ],
    );
    _height = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
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
