import 'package:flutter/material.dart';
import 'package:kapital_ing_app/screen/login_screen.dart';
import 'package:kapital_ing_app/screen/main_menu_screen.dart';
import 'package:kapital_ing_app/screen/neighborhood_act_screen.dart';
import 'package:kapital_ing_app/screen/siganture_screen.dart';
import 'package:kapital_ing_app/screen/splash_screen.dart';
import 'package:kapital_ing_app/screen/work_vitacora_screen.dart';

import '../screen/follow_up_screen.dart';

Map<String, WidgetBuilder> getRoutes(){
  return <String,WidgetBuilder>{
    'login' : (BuildContext context) => LoginScreen(),
    'main_menu': (BuildContext context) => MainMenuScreen(),
    'splash': (BuildContext context) => SplashScreen(),
    'neightbor_act': (BuildContext context) => NeighborhoodAct(),
    'signature': (BuildContext context) => SignatureScreen(),
    'work_vitacora': (BuildContext context) => WorkVitacoraScreen(),
    'follow_up': (BuildContext context) => FollowUpScreen()
  };
}