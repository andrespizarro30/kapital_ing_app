import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../common_functions/common_functions.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<bool> _onWillPop() async {
    return false;
  }

  StreamSubscription<Position>? streamSubscriptionPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    updateLocationAtRealTime();


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text("Constructora Kapital"),
        ),
        drawer: Container(
          color: Colors.white,
          width: 300.0,
          child: Drawer(
            child: ListView(
              children: [
                Container(
                  height: 165.0,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                    child: Row(
                      children: [
                        Image.asset("images/kapital_logo.jpg",height: 65.0,width: 65.0,),
                        SizedBox(width: 16.0,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Pending for setup...",style: TextStyle(fontSize: 16.0,fontFamily: "Brand-Bold"),),
                            SizedBox(height: 6.0,),
                            Text("Pending for setup...",style: TextStyle(fontSize: 12.0,fontFamily: "Brand-Bold"),),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1.0,
                  color: Colors.black,
                  thickness: 1.0,
                ),
                SizedBox(height: 12.0,),
                ListTile(
                  leading: Icon(Icons.document_scanner),
                  title: Text("Actas de Vecindad",style: TextStyle(fontSize: 15.0)),
                  onTap: (){
                    if(modulePermissionsG!.contains("ActaVecindad") || modulePermissionsG!.contains("All")){
                      Navigator.pushNamed(context, 'neightbor_act');
                      displayToastMessages("Actas de Vecindad", context);
                    }else{
                      displayToastMessages("No tiene permisos para este módulo", context);
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.card_travel),
                  title: Text("Bitacora de Obra",style: TextStyle(fontSize: 15.0)),
                  onTap: (){
                    if(modulePermissionsG!.contains("BitacoraObra") || modulePermissionsG!.contains("All")){
                      Navigator.pushNamed(context, 'work_vitacora');
                      displayToastMessages("Vitacoras de Obra", context);
                    }else{
                      displayToastMessages("No tiene permisos para este módulo", context);
                    }

                  },
                ),
                ListTile(
                  leading: Icon(Icons.remove_red_eye_outlined ),
                  title: Text("Control y Seguimiento Diario",style: TextStyle(fontSize: 15.0)),
                  onTap: (){
                    if(modulePermissionsG!.contains("CtrlSeg") || modulePermissionsG!.contains("All")){
                      Navigator.pushNamed(context, 'follow_up');
                      displayToastMessages("Control y Seguimiento Diario de Actividades", context);
                    }else{
                      displayToastMessages("No tiene permisos para este módulo", context);
                    }

                  },
                ),
                ListTile(
                  leading: Icon(Icons.follow_the_signs),
                  title: Text("Salir",style: TextStyle(fontSize: 15.0)),
                  onTap: (){
                    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
      timeLimit: Duration(milliseconds: 600000)
  );

  void updateLocationAtRealTime(){

    streamSubscriptionPosition = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position? position) async {


              //DatabaseReference userRef = FirebaseDatabase.instance.ref().child("position");

              //userRef.child("Pao").set("${position!.latitude},${position!.longitude}");


    });

  }

}
