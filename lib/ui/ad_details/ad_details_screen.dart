import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zayed/utils/app_colors.dart';
import 'package:zayed/custom_widgets/safe_area/page_container.dart';
import 'package:zayed/locale/app_localizations.dart';
import 'package:zayed/models/ad.dart';
import 'package:zayed/models/ad_details.dart';
import 'package:zayed/networking/api_provider.dart';
import 'package:zayed/providers/ad_details_provider.dart';
import 'package:zayed/providers/auth_provider.dart';
import 'package:zayed/providers/favourite_provider.dart';
import 'package:zayed/ui/chat/chat_screen.dart';
import 'package:zayed/ui/section_ads/section_ads_screen.dart';
import 'package:zayed/utils/app_colors.dart';
import 'package:zayed/utils/commons.dart';
import 'package:zayed/utils/urls.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zayed/utils/error.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:zayed/ui/ad_details/widgets/slider_images.dart';


class AdDetailsScreen extends StatefulWidget {
  final Ad ad;


  const AdDetailsScreen({Key key, this.ad}) : super(key: key);
  @override
  _AdDetailsScreenState createState() =>
      _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  double _height = 0, _width = 0;
  ApiProvider _apiProvider = ApiProvider();
  AuthProvider _authProvider ;
    BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
      super.initState();
      setCustomMapPin();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/pin.png',);
  }
 
  Widget _buildRow(
      {@required String imgPath,
      @required String title,
      @required String value}) {
    return Row(
      children: <Widget>[
        Image.asset(
          imgPath,
          color: Color(0xffC5C5C5),
          height: 15,
          width: 15,
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              title,
              style: TextStyle(color: Colors.black, fontSize: 14),
            )),
        Spacer(),
        Text(
          value,
          style: TextStyle(color: Color(0xff5FB019), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildBodyItem() {
    return   FutureBuilder<AdDetails>(
                  future: Provider.of<AdDetailsProvider>(context,
                          listen: false)
                      .getAdDetails(widget.ad.adsId) ,
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
                            errorMessage: AppLocalizations.of(context).translate('error'),
                          );
                        } else {
                           var initalLocation = snapshot.data.adsLocation.
     split(','); 
    LatLng pinPosition = LatLng(double.parse(initalLocation[0]), double.parse(initalLocation[1]));
    
    // these are the minimum required values to set 
    // the camera position 
    CameraPosition initialLocation = CameraPosition(
        zoom: 15,
        bearing: 30,
        target: pinPosition
    );

                     
                 return        ListView(
      children: <Widget>[
        SizedBox(
          height: 60,
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: _width * 0.04 ,vertical: _height*0.02),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),

          child: SliderImages(),
        ),
        Container(
          height:190,
          margin: EdgeInsets.symmetric(horizontal: _width * 0.04),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(
              color: hintColor.withOpacity(0.4),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(
                        right: _authProvider.currentLang == 'ar' ? _width * 0.04 : 0,
                        left:  _authProvider.currentLang != 'ar' ? _width * 0.04 : 0,
                       top: _height * 0.02,
                      ),
                      width: _width * 0.7,
                      height: _height * 0.07,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          border:
                              Border.all(width: 1.5, color: Color(0xffDBDBDB))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: Image.asset(
                              'assets/images/price.png',color: Color(0xff2E2E2E),
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                  color: Color(0xff2E2E2E)),
                              children: <TextSpan>[
                                new TextSpan(text: snapshot.data.adsPrice),
                                new TextSpan(text: ' '),
                                new TextSpan(
                                    text:  AppLocalizations.of(context).translate('sr'),
                                    style: new TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Cairo',
                                        color: Color(0xff2E2E2E))),
                              ],
                            ),
                          )
                        ],
                      )),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(
                         right: _authProvider.currentLang != 'ar' ? 5 : 0,
                        left:  _authProvider.currentLang == 'ar' ? 5 : 0,
                      top: _height * 0.02,
                    ),
                    height: _height * 0.07,
                    width: _width * 0.12,
                    decoration: BoxDecoration(
                        color: Color(0xffF35D14),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        border: Border.all(width: 1.5,color: Color(0xffF35D14),)),
                    child: _authProvider.currentUser == null
                                          ? GestureDetector(
                                              onTap: () => Navigator.pushNamed(
                                                  context, '/login_screen'),
                                              child: Center(
                                                  child: Icon(
                                                Icons.favorite_border,
                                                size: 38,
                                                color: Colors.white,
                                              )),
                                            )
                                          : Consumer<FavouriteProvider>(builder:
                                              (context, favouriteProvider,
                                                  child) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  if (favouriteProvider
                                                      .favouriteAdsList
                                                      .containsKey(snapshot.data.adsId)) {
                                                    favouriteProvider
                                                        .removeFromFavouriteAdsList(
                                                           snapshot.data.adsId);
                                                    await _apiProvider.get(Urls
                                                            .REMOVE_AD_from_FAV_URL +
                                                        "ads_id=${snapshot.data.adsId}&user_id=${_authProvider.currentUser.userId}");
                                                  } else {
                                                    favouriteProvider
                                                        .addToFavouriteAdsList(
                                                          snapshot.data.adsId,
                                                            1);
                                                    await _apiProvider.post(
                                                        Urls.ADD_AD_TO_FAV_URL,
                                                        body: {
                                                          "user_id":
                                                              _authProvider
                                                                  .currentUser
                                                                  .userId,
                                                          "ads_id": snapshot.data.adsId
                                                        });
                                                  }
                                                },
                                                child: Center(
                                                  child: favouriteProvider
                                                          .favouriteAdsList
                                                          .containsKey(
                                                            snapshot.data.adsId)
                                                      ? SpinKitPumpingHeart(
                                                          color: accentColor,
                                                          size: 25,
                                                        )
                                                      : Icon(
                                                          Icons.favorite_border,
                                                          size: 25,
                                                          color: Colors.white,
                                                        ),
                                                ),
                                              );
                                            })
                   
                 
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
  
              Container(
                  margin: EdgeInsets.symmetric(horizontal: _width * 0.04),
                  child: _buildRow(
                      imgPath: 'assets/images/edit.png',
                      title: AppLocalizations.of(context).translate('ad_no'),
                      value: snapshot.data.adsId)),
              Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: _width * 0.04, vertical: _height * 0.001),
                  child: _buildRow(
                      imgPath: 'assets/images/time.png',
                      title: AppLocalizations.of(context).translate('ad_time'),
                      value:  snapshot.data.adsDate)),
              Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: _width * 0.04, vertical: _height * 0.001),
                  child: _buildRow(
                      imgPath: 'assets/images/city.png',
                      title:AppLocalizations.of(context).translate('city'),
                      value: snapshot.data.adsCityName)),
              Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: _width * 0.04, vertical: _height * 0.001),
                  child: _buildRow(
                      imgPath: 'assets/images/view.png',
                      title: AppLocalizations.of(context).translate('watches_no'),
                      value: snapshot.data.adsVisits))
            ],
          ),
        ),
        Container(
          height: _height * 0.1,
          margin: EdgeInsets.symmetric(
              horizontal: _width * 0.04, vertical: _height * 0.01),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(
              color: hintColor.withOpacity(0.4),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: _width * 0.025),
                child: CircleAvatar(
                   backgroundColor: Colors.grey,
                  radius: _height * 0.035,
                  backgroundImage: NetworkImage(snapshot.data.adsUserPhoto),
                ),
              ),
              Text(
               snapshot.data.adsUserName,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
              Spacer(),
              GestureDetector(
                onTap: (){
                  launch(
                                      "tel://${snapshot.data.adsUserPhone}");
                },
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: _width * 0.025),
                    child: Image.asset('assets/images/callnow.png')),
              )
            ],
          ),
        ),
        InkWell(
            onTap: (){
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SectionAdsScreen(
                                  catId: snapshot.data.adsCat,
                                  adCatName:snapshot.data.adsCatName
                                  
                                )));
                   },
          child: Container(
            height: _height * 0.1,
            margin: EdgeInsets.symmetric(
                horizontal: _width * 0.04, vertical: _height * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(
                color: hintColor.withOpacity(0.4),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: _width * 0.025),
                  child: Image.network(snapshot.data.adsCatImage,cacheWidth: 25,cacheHeight: 25,),
                ),
                Text(
                  snapshot.data.adsCatName,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
                Spacer(),
                Text(
                  
                  AppLocalizations.of(context).translate('section_ads'),
                  style: TextStyle(color: Color(0xffC5C5C5), fontSize: 12),
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: _width * 0.025),
                    child:Consumer<AuthProvider>(
                      builder: (context,authProvider,child){
                        return authProvider.currentLang == 'ar' ? Image.asset('assets/images/left.png'): Transform.rotate(
                            angle: 180 * math.pi / 180,
                            child:  Image.asset(
                      'assets/images/left.png',
                    ));
                      },
                    ),) 
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: _width * 0.04,
          ),
          child: Text(
            AppLocalizations.of(context).translate('ad_description'),
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
            margin: EdgeInsets.symmetric(
              horizontal: _width * 0.04,
            ),
            child: Text(
              snapshot.data.adsDetails,
              style: TextStyle(height: 1.4, fontSize: 14),
              textAlign: TextAlign.justify,
            )),
Container(
  margin: EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 15
  ),
  height: 150,
   decoration: BoxDecoration(
              color:  Color(0xffF3F3F3),
              border: Border.all(
                width: 1.0,
                color: Color(0xffF3F3F3),
              ),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
  child:   ClipRRect(
    borderRadius: BorderRadius.all( Radius.circular(10.0)),
    child: GoogleMap(

        myLocationEnabled: true,

        compassEnabled: true,

        markers: _markers,

        initialCameraPosition: initialLocation,

        onMapCreated: (GoogleMapController controller) {

            controller.setMapStyle(Commons.mapStyles);

            _controller.complete(controller);



     setState(() {

              _markers.add(

                  Marker(

                    markerId: MarkerId(snapshot.data.adsId),

                    position: pinPosition,

                    icon: pinLocationIcon

                  )

              );





  });



        })),
),

        Container(
            margin: EdgeInsets.only(top: 10),
            height: 50,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child:   GestureDetector(
                  onTap: (){
                     if (_authProvider.currentUser != null) {
                                   
                                        Navigator.push(context, MaterialPageRoute
                        (builder: (context)=> ChatScreen(
                       senderId: snapshot.data.userDetails[0].id,
                          senderImg: snapshot.data.userDetails[0].userImage,
                          senderName:snapshot.data.userDetails[0].name,
                         senderPhone:snapshot.data.userDetails[0].phone,
                         adsId:snapshot.data.adsId,

                        )
                         ));
                                    } else {
                                      Navigator.pushNamed(
                                          context, '/login_screen');
                                    }
                  },
                  child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Image.asset('assets/images/chat.png',color: Colors.white,)),
               Text(
                  AppLocalizations.of(context).translate('send_to_advertiser'),
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                
              ],
            )))
    
      ],
    );
                        }
                    }
                    return Center(
                      child: SpinKitFadingCircle(color: mainAppColor),
                    );
                  });
   
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);
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
                    },),
                   Container(
                     width: _width *0.55,
                     child: Text( widget.ad.adsTitle,
                     overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline1),
                   ),
                  
                  Spacer(
                    flex: 3,
                  ),
                 IconButton(
                   icon:  Icon(
                    Icons.flag,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () async {
                     final results = await _apiProvider
                      .post(Urls.REPORT_AD_URL + "?api_lang=${_authProvider.currentLang}", body: {
                    "report_user":  _authProvider.currentUser.userId,
                    "report_gid": widget.ad.adsId,
                   
                  });
               
          
                  if (results['response'] == "1") {
                   Commons.showToast(context, message: results["message"] );
                      
                  } else {
                    Commons.showError(context, results["message"]);
                
                  }
                                                   
                  },
                 ),
                  Container(
                    width: _width * 0.02,
                  ),
                  IconButton(

                    onPressed: (){
                        Share.share(widget.ad.adsTitle+" -  السعر : "+widget.ad.adsPrice +" -  الصورة : "+ widget.ad.adsPhoto+" - مشاركة من تطبيق سوق زايد - ",
                          sharePositionOrigin: Rect.fromLTWH(0, 0, _width, _height / 2),
                                 );
                    },
                  icon:  Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 30,
                  ),
                  )
                  ,
                 Container(
                    width: _width * 0.02,
                  ),
                ],
              )),
        ],
      )),
    );
  }
}
