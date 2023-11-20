import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/current_user_data.dart';

String? currentProjectG = "";
String? userType = "";
String currentProjectId = "";
List<String>? modulePermissionsG;
String? fullNameG = "";

StreamSubscription<DatabaseEvent>? vitacorasInfoStreamSubscription;

displayToastMessages(String msg,BuildContext context){
  Fluttertoast.showToast(msg: msg,toastLength: Toast.LENGTH_LONG);
}

Future<bool> testInternetConnection() async {

  try{
    final result = await InternetAddress.lookup("www.google.com");
    if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
      return true;
    }
  }on SocketException catch(_){
    return false;
  }

  return false;

}