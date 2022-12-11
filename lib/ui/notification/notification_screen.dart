import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zayed/custom_widgets/no_data/no_data.dart';
import 'package:zayed/custom_widgets/safe_area/page_container.dart';
import 'package:zayed/locale/app_localizations.dart';
import 'package:zayed/models/notification_message.dart';
import 'package:zayed/networking/api_provider.dart';
import 'package:zayed/providers/auth_provider.dart';
import 'package:zayed/providers/notification_provider.dart';
import 'package:zayed/ui/notification/widgets/notification_item.dart';
import 'package:zayed/utils/app_colors.dart';
import 'package:zayed/utils/urls.dart';
import 'package:provider/provider.dart';
import 'package:zayed/utils/error.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>  with TickerProviderStateMixin{
  double _height = 0 , _width = 0;
  AnimationController _animationController;
  AuthProvider _authProvider;
  ApiProvider _apiProvider = ApiProvider();

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

Widget _buildBodyItem(){
  return ListView(
    children: <Widget>[
      SizedBox(
        height: 80,
      ),
      Container(
        height: _height - 150,
        width: _width,
        child: FutureBuilder<List<NotificationMsg>>(
                  future:  Provider.of<NotificationProvider>(context,
                          listen: false)
                      .getMessageList() ,
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
                            errorMessage: AppLocalizations.of(context).translate('error')
                          );
                        } else {
                          if (snapshot.data.length > 0) {
                     return     ListView.builder(
            itemCount: snapshot.data.length,
             itemBuilder: (BuildContext context, int index) {
               var count = snapshot.data.length;
                      var animation = Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn),
                        ),
                      );
                      _animationController.forward();
               return Dismissible(
                              // Each Dismissible must contain a Key. Keys allow Flutter to
                              // uniquely identify widgets.
                              key: Key(snapshot.data[index].messageId),
                              // Provide a function that tells the app
                              // what to do after an item has been swiped away.
                              onDismissed: (direction) async {
                                // Remove the item from the data source.
                             await   _apiProvider.get(Urls.DELETE_NOTIFICATION_URL +
         'user_id=${_authProvider.currentUser.userId}&notify_id=${snapshot.data[index].messageId}');
                      setState(() {
                                  
                                  snapshot.data.removeAt(index);
                                });

                               
                              },
                              // Show a red background as the item is swiped away.
                              background: Container(color: Colors.red),
                              child: Container(
              height: _height *0.125,
              child: NotificationItem(
      enableDivider: snapshot.data.length - 1 != index ,
                animation: animation,
                animationController: _animationController,
                notificationMsg: snapshot.data[index],
              )));
             }
          );
                          } else {
                            return NoData(message:AppLocalizations.of(context).translate('no_results'));
                          }
                        }
                    }
                    return Center(
                      child: SpinKitFadingCircle(color: mainAppColor),
                    );
                  })
       
      )
    ],
  );
}

@override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);
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
            child: Center(
              child: Text(AppLocalizations.of(context).translate('notifications'),
                  style: Theme.of(context).textTheme.headline1),
            ),
          )
        ],
      )),
    );
  }
}