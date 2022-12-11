
import 'package:zayed/ui/auth/code_activation_screen.dart';
import 'package:zayed/ui/auth/login_screen.dart';
import 'package:zayed/ui/auth/new_password_screen.dart';
import 'package:zayed/ui/auth/phone_password_recovery_screen.dart';
import 'package:zayed/ui/auth/register_screen.dart';
import 'package:zayed/ui/bottom_navigation.dart/bottom_navigation_bar.dart';
import 'package:zayed/ui/my_ads/my_ads_screen.dart';
import 'package:zayed/ui/notification/notification_screen.dart';
import 'package:zayed/ui/splash/splash_screen.dart';
import 'package:zayed/ui/home/cats_screen.dart';



final routes = {
  '/': (context) => SplashScreen(),
  '/login_screen':(context)=> LoginScreen(),
  '/phone_password_reccovery_screen' :(context) => PhonePasswordRecoveryScreen(),
  '/code_activation_screen':(context) => CodeActivationScreen(),
 '/new_password_screen' :(context) => NewPasswordScreen(),
 '/register_screen':(context) => RegisterScreen(),
  '/navigation': (context) =>  BottomNavigation(),
  '/my_ads_screen':(context) =>MyAdsScreen(),
 '/notification_screen':(context) => NotificationScreen(),
 '/cats_screen':(context) => CatsScreen()


};
