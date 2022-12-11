import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zayed/custom_widgets/connectivity/network_indicator.dart';
import 'package:zayed/locale/app_localizations.dart';
import 'package:zayed/models/user.dart';
import 'package:zayed/providers/auth_provider.dart';
import 'package:zayed/providers/navigation_provider.dart';
import 'package:zayed/shared_preferences/shared_preferences_helper.dart';
import 'package:zayed/ui/add_ad/widgets/add_ad_bottom_sheet.dart';
import 'package:zayed/utils/app_colors.dart';
import 'package:provider/provider.dart';


class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
 bool _initialRun = true;
   AuthProvider _authProvider;
 NavigationProvider _navigationProvider;
 
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  void _iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void _firebaseCloudMessagingListeners() {
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    _flutterLocalNotificationsPlugin.initialize(platform);
 
    if (Platform.isIOS) _iOSPermission();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        _showNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');

        Navigator.pushNamed(context, '/notification_screen');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');

        Navigator.pushNamed(context, '/notification_screen');
      },
    );
  }

  _showNotification(Map<String, dynamic> message) async {
    var android = new AndroidNotificationDetails(
      'channel id',
      "CHANNLE NAME",
      "channelDescription",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await _flutterLocalNotificationsPlugin.show(
        0,
        message['notification']['title'],
        message['notification']['body'],
        platform);
  }



  Future<Null> _checkIsLogin() async {
    var userData = await SharedPreferencesHelper.read("user");
    if (userData != null) {
      _authProvider.setCurrentUser(User.fromJson(userData));
  _firebaseCloudMessagingListeners();
    }
   
  }
  


 

 @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) { 
      _authProvider = Provider.of<AuthProvider>(context);
       _checkIsLogin();
       _initialRun = false;
      
    }
  }



  @override
  Widget build(BuildContext context) {
    _navigationProvider = Provider.of<NavigationProvider>(context);
    return NetworkIndicator(
        child: Scaffold(
      body: _navigationProvider.selectedContent,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon:  Icon(Icons.home,
              color: Color(0xFFC7C7C7),
            ),
            activeIcon: Icon(Icons.home,
              color: mainAppColor,) ,
            title: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  AppLocalizations.of(context).translate('all'),
                  style: TextStyle(fontSize: 12.0),
                )),
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.favorite,
               color: Color(0xFFC7C7C7),
            ),
             activeIcon: Icon(Icons.favorite,
             color: mainAppColor,) ,
            title: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  AppLocalizations.of(context).translate('favourite'),
                  style: TextStyle(fontSize: 12.0),
                )),
          ),
           BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/add.png',

            ),

            title: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text('',style: TextStyle(height: 0.0),)),
          ),
           BottomNavigationBarItem(
            icon:  Icon(Icons.notifications,
               color: Color(0xFFC7C7C7),
            ),
             activeIcon: Icon(Icons.notifications,
             color: mainAppColor,) ,
            title: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                 AppLocalizations.of(context).translate('notifications'),
                  style: TextStyle(fontSize: 12.0),
                )),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/user.png',
               color: Color(0xFFC7C7C7),
            ),
             activeIcon: Image.asset(
              'assets/images/user.png',
              color: mainAppColor,
            ),
            title: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                       AppLocalizations.of(context).translate('my_account'),
                  style: TextStyle(fontSize: 12.0),
                )),
          ),
        
        ],
        currentIndex: _navigationProvider.navigationIndex,
        selectedItemColor: mainAppColor,
        unselectedItemColor: Color(0xFFC4C4C4),
        onTap: (int index) {
          if(index == 0 && _navigationProvider.navigationIndex ==0){
            _navigationProvider.setMapIsActive(!_navigationProvider.mapIsActive);
          }else  if ((index == 1 || index == 2 || index == 3 || index == 4) &&
                    _authProvider.currentUser == null){
              
                  Navigator.pushNamed(context, '/login_screen');
              
          } else  if(index == 2){
            showModalBottomSheet<dynamic>(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    context: context,
                    builder: (builder) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: AddAdBottomSheet());
                    });
          }else{
 _navigationProvider.upadateNavigationIndex(index);
          }
         
          
        },
        elevation: 5,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    ));
  }
}
