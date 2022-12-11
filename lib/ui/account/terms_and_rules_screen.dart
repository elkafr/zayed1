import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zayed/custom_widgets/safe_area/page_container.dart';
import 'package:zayed/locale/app_localizations.dart';
import 'package:zayed/providers/auth_provider.dart';
import 'package:zayed/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:zayed/providers/terms_provider.dart';
import 'package:zayed/utils/error.dart';
import 'dart:math' as math;

class TermsAndRulesScreen extends StatefulWidget {
  @override
  _TermsAndRulesScreenState createState() => _TermsAndRulesScreenState();
}

class _TermsAndRulesScreenState extends State<TermsAndRulesScreen> {
double _height = 0 , _width = 0;


Widget _buildBodyItem(){
  return ListView(
   
    children: <Widget>[
      SizedBox(
        height: 70,
      ),
        Container(
         alignment: Alignment.center,
         margin: EdgeInsets.only(bottom: _height *0.02),
         child:  Image.asset('assets/images/conditions.png',height:_height *0.15 ,
         fit: BoxFit.cover,
         color: accentColor,),
       ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: _width *0.04),
            child: Divider(),
         ),
  
        
   Expanded(
             child: FutureBuilder<String>(
                future: Provider.of<TermsProvider>(context,
                        listen: false)
                    .getTerms() ,
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
                   return    Container(
         margin: EdgeInsets.symmetric(horizontal: _width *0.04),
         child: Text( snapshot.data,style: TextStyle(
             color: Colors.black,fontSize: 14,height: 1.6
         ),));
                      }
                  }
                  return Center(
                    child: SpinKitFadingCircle(color: mainAppColor),
                  );
                }),
           )
        
    ],
  );
}

@override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
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
                  Text( AppLocalizations.of(context).translate('rules_and_terms'),
                      style: Theme.of(context).textTheme.headline1),
                  Spacer(
                    flex: 3,
                  ),
                ],
              )),
        ],
      )),
    );
  }
}