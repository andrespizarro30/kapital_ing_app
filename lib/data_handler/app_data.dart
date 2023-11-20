
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier{

  Uint8List? imageBytes;

  void saveSignature(Uint8List imageBytes){

    this.imageBytes=imageBytes;

    notifyListeners();

  }

  void cleanSignature(){

    this.imageBytes=null;

    notifyListeners();

  }

  Uint8List? imageBytesSignKapital;

  void saveKapitalSignature(Uint8List imageBytes){

    this.imageBytesSignKapital=imageBytes;

    notifyListeners();

  }

  void cleanKapitalSignature(){

    this.imageBytesSignKapital=null;

    notifyListeners();

  }

  Uint8List? imageBytesSignInterv;

  void saveIntervSignature(Uint8List imageBytes){

    this.imageBytesSignInterv=imageBytes;

    notifyListeners();

  }

  void cleanIntervSignature(){

    this.imageBytesSignInterv=null;

    notifyListeners();

  }




}