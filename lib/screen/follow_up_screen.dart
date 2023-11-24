import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kapital_ing_app/common_functions/PdfCreatorWorkDaily.dart';
import 'package:kapital_ing_app/screen/signature_daily_work.dart';
import 'package:kapital_ing_app/screen/signature_vitacora_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../common_functions/common_functions.dart';
import '../data_handler/app_data.dart';
import '../main.dart';
import '../models/daily_work_model.dart';

import 'package:path/path.dart' as path;

import 'package:http/http.dart' as http;

import '../widgets/request_camera_gallery.dart';

class FollowUpScreen extends StatefulWidget {
  const FollowUpScreen({super.key});

  @override
  State<FollowUpScreen> createState() => _FollowUpScreenState();
}

class _FollowUpScreenState extends State<FollowUpScreen> {

  TextEditingController dateSelectedTEC = TextEditingController();

  TextEditingController photoDescKapital1TEC = TextEditingController();
  TextEditingController photoDescKapital2TEC = TextEditingController();
  TextEditingController photoDescKapital3TEC = TextEditingController();
  TextEditingController photoDescKapital4TEC = TextEditingController();
  TextEditingController photoDescKapital5TEC = TextEditingController();
  TextEditingController photoDescKapital6TEC = TextEditingController();

  String selectedDate = "";

  File? takenImageKap1 = null;
  File? takenImageKap2 = null;
  File? takenImageKap3 = null;
  File? takenImageKap4 = null;
  File? takenImageKap5 = null;
  File? takenImageKap6 = null;

  Uint8List? image1KapStream = null;
  Uint8List? image2KapStream = null;
  Uint8List? image3KapStream = null;
  Uint8List? image4KapStream = null;
  Uint8List? image5KapStream = null;
  Uint8List? image6KapStream = null;


  String image1KapitalURL = "";
  String image2KapitalURL = "";
  String image3KapitalURL = "";
  String image4KapitalURL = "";
  String image5KapitalURL = "";
  String image6KapitalURL = "";


  String image1KapitalURL_ant = "";
  String image2KapitalURL_ant = "";
  String image3KapitalURL_ant = "";
  String image4KapitalURL_ant = "";
  String image5KapitalURL_ant = "";
  String image6KapitalURL_ant = "";

  Uint8List? signKapitalStream = null;

  String signKapitalURL = "";

  String fullNameKapital = "";

  Uint8List? imageBytesSignKapital;
  Uint8List? imageBytesSignInterv;

  Color bgcSunnyM = Colors.black;
  Color fgcSunnyM = Colors.white;
  Color bgcWindyM = Colors.black;
  Color fgcWindyM = Colors.white;
  Color bgcCloudyM = Colors.black;
  Color fgcCloudyM = Colors.white;
  Color bgcRainyM = Colors.black;
  Color fgcRainyM = Colors.white;

  Color bgcSunnyT = Colors.black;
  Color fgcSunnyT = Colors.white;
  Color bgcWindyT = Colors.black;
  Color fgcWindyT = Colors.white;
  Color bgcCloudyT = Colors.black;
  Color fgcCloudyT = Colors.white;
  Color bgcRainyT = Colors.black;
  Color fgcRainyT = Colors.white;

  String climaManana = "";
  String climaTarde = "";

  DailyWorkAct? dailyWorkActModel;

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dailyWorkActModel = DailyWorkAct();

  }

  @override
  Widget build(BuildContext context) {

    imageBytesSignKapital = Provider.of<AppData>(context).imageBytesSignKapital != null
        ? Provider.of<AppData>(context).imageBytesSignKapital!
        : null;

    double screenWidth = MediaQuery.of(context).size.width * 0.4;

    bool enableKapWidget = true;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Bitacora de Obra"),
          backgroundColor: Colors.yellow,
          actions: [
            IconButton(
              icon: const Icon(Icons.date_range),
              tooltip: 'Seleccione Fecha',
              onPressed: () {
                showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 365)),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                    builder: (context, child) {
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Container(
                              height: 450,
                              width: 700,
                              child: child,
                            ),
                          ),
                        ],
                      );
                    }
                ).then((date){
                  setState(() {
                    if (date is DateTime) {
                      dateSelectedTEC.text = "${DateFormat('yyyy-MM-dd').format(date)}";
                      selectedDate = "${DateFormat('yyyyMMdd').format(date)}";

                      cleanForm();

                      retrieveWorkInfoInfo(selectedDate);

                    }
                  });
                });
              },
            ),
            Visibility(
              child: IconButton(
                icon: const Icon(Icons.document_scanner_rounded),
                tooltip: 'Crear PDF',
                onPressed: () async {

                  dailyWorkActModel!.dateSelected =  dateSelectedTEC.text;

                  dailyWorkActModel!.Image_1Kapital = image1KapStream;
                  dailyWorkActModel!.Image_2Kapital = image2KapStream;
                  dailyWorkActModel!.Image_3Kapital = image3KapStream;
                  dailyWorkActModel!.Image_4Kapital = image4KapStream;
                  dailyWorkActModel!.Image_5Kapital = image5KapStream;
                  dailyWorkActModel!.Image_6Kapital = image6KapStream;

                  dailyWorkActModel!.DescImg1Kap =  photoDescKapital1TEC.text;
                  dailyWorkActModel!.DescImg2Kap =  photoDescKapital2TEC.text;
                  dailyWorkActModel!.DescImg3Kap =  photoDescKapital3TEC.text;
                  dailyWorkActModel!.DescImg4Kap =  photoDescKapital4TEC.text;
                  dailyWorkActModel!.DescImg5Kap =  photoDescKapital5TEC.text;
                  dailyWorkActModel!.DescImg6Kap =  photoDescKapital6TEC.text;

                  dailyWorkActModel!.SignKapital = imageBytesSignKapital;

                  dailyWorkActModel!.ClimaManana = climaManana;
                  dailyWorkActModel!.ClimaTarde = climaTarde;
                  dailyWorkActModel!.FullNameKapital = fullNameKapital;

                  PdfCreatorDailyWork pdfDoc = PdfCreatorDailyWork(dailyWorkAct: dailyWorkActModel!);
                  await pdfDoc.createPDFDoc();
                  pdfDoc.saveAndLaunchFile();

                },
              ),
              visible: true,
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Cerrar',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Visibility(
          visible: (selectedDate != ""),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                    controller: dateSelectedTEC,
                    keyboardType: TextInputType.text,
                    enabled: false,
                    decoration: InputDecoration(
                        labelText: "Fecha Seleccionada",
                        labelStyle: TextStyle(
                            fontSize: 14.0,
                            fontFamily: "Brand-Bold",
                            color: Colors.black
                        ),
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        )
                    ),
                    style: TextStyle(fontSize: 14.0,fontFamily: "Brand-Regular",color: Colors.black),
                    onChanged: (String? value){

                    }
                ),

                SizedBox(height: 10.0,),

                Text(
                  "Estado Climático",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Mañana",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ElevatedButton.icon(
                            onPressed: (){

                              if(enableKapWidget){

                                dailyWorkRef
                                    .child(currentProjectId)
                                    .child(selectedDate)
                                    .child(userCode!)
                                    .child("ClimaManana")
                                    .set("Soleado");

                                setState(() {
                                  climaManana = "Soleado";
                                  bgcSunnyM = Colors.blue;
                                  fgcSunnyM = Colors.yellow;
                                  bgcWindyM = Colors.black;
                                  fgcWindyM = Colors.white;
                                  bgcCloudyM = Colors.black;
                                  fgcCloudyM = Colors.white;
                                  bgcRainyM = Colors.black;
                                  fgcRainyM = Colors.white;
                                });

                              }else{
                                displayToastMessages("Solo Kapital", context);
                              }

                            },
                            icon: Icon(
                                Icons.sunny
                            ),
                            label: Text(""),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: bgcSunnyM,
                                foregroundColor: fgcSunnyM
                            )
                        ),
                        ElevatedButton.icon(
                            onPressed: (){

                              if(enableKapWidget){

                                dailyWorkRef
                                    .child(currentProjectId)
                                    .child(selectedDate)
                                    .child(userCode!)
                                    .child("ClimaManana")
                                    .set("Vientos Fuertes");

                                setState(() {
                                  climaManana = "Vientos Fuertes";
                                  bgcSunnyM = Colors.black;
                                  fgcSunnyM = Colors.white;
                                  bgcWindyM = Colors.blue;
                                  fgcWindyM = Colors.grey;
                                  bgcCloudyM = Colors.black;
                                  fgcCloudyM = Colors.white;
                                  bgcRainyM = Colors.black;
                                  fgcRainyM = Colors.white;
                                });

                              }else{
                                displayToastMessages("Solo Kapital", context);
                              }

                            },
                            icon: Icon(
                                Icons.wind_power
                            ),
                            label: Text(""),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: bgcWindyM,
                                foregroundColor: fgcWindyM
                            )
                        ),
                        ElevatedButton.icon(
                            onPressed: (){

                              if(enableKapWidget){

                                dailyWorkRef
                                    .child(currentProjectId)
                                    .child(selectedDate)
                                    .child(userCode!)
                                    .child("ClimaManana")
                                    .set("Nublado");

                                setState(() {
                                  climaManana = "Nublado";
                                  bgcSunnyM = Colors.black;
                                  fgcSunnyM = Colors.white;
                                  bgcWindyM = Colors.black;
                                  fgcWindyM = Colors.white;
                                  bgcCloudyM = Colors.grey;
                                  fgcCloudyM = Colors.black26;
                                  bgcRainyM = Colors.black;
                                  fgcRainyM = Colors.white;
                                });

                              }else{
                                displayToastMessages("Solo Kapital", context);
                              }

                            },
                            icon: Icon(
                                Icons.cloud
                            ),
                            label: Text(""),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: bgcCloudyM,
                                foregroundColor: fgcCloudyM
                            )
                        ),
                        ElevatedButton.icon(
                            onPressed: (){

                              if(enableKapWidget){

                                dailyWorkRef
                                    .child(currentProjectId)
                                    .child(selectedDate)
                                    .child(userCode!)
                                    .child("ClimaManana")
                                    .set("Lluvioso");

                                setState(() {
                                  climaManana = "Lluvioso";
                                  bgcSunnyM = Colors.black;
                                  fgcSunnyM = Colors.white;
                                  bgcWindyM = Colors.black;
                                  fgcWindyM = Colors.white;
                                  bgcCloudyM = Colors.black;
                                  fgcCloudyM = Colors.white;
                                  bgcRainyM = Colors.grey;
                                  fgcRainyM = Colors.blue;
                                });

                              }else{
                                displayToastMessages("Solo Kapital", context);
                              }

                            },
                            icon: Icon(
                                Icons.water_drop_rounded
                            ),
                            label: Text(""),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: bgcRainyM,
                                foregroundColor: fgcRainyM
                            )
                        )
                      ],
                    ),
                    Text(
                      "Tarde",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ElevatedButton.icon(
                            onPressed: (){

                              if(enableKapWidget){

                                dailyWorkRef
                                    .child(currentProjectId)
                                    .child(selectedDate)
                                    .child(userCode!)
                                    .child("ClimaTarde")
                                    .set("Soleado");

                                setState(() {
                                  climaTarde = "Soleado";
                                  bgcSunnyT = Colors.blue;
                                  fgcSunnyT = Colors.yellow;
                                  bgcWindyT = Colors.black;
                                  fgcWindyT = Colors.white;
                                  bgcCloudyT = Colors.black;
                                  fgcCloudyT = Colors.white;
                                  bgcRainyT = Colors.black;
                                  fgcRainyT = Colors.white;
                                });

                              }else{
                                displayToastMessages("Solo Kapital", context);
                              }

                            },
                            icon: Icon(
                                Icons.sunny
                            ),
                            label: Text(""),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: bgcSunnyT,
                                foregroundColor: fgcSunnyT
                            )
                        ),
                        ElevatedButton.icon(
                            onPressed: (){

                              if(enableKapWidget){

                                dailyWorkRef
                                    .child(currentProjectId)
                                    .child(selectedDate)
                                    .child(userCode!)
                                    .child("ClimaTarde")
                                    .set("Vientos Fuertes");

                                setState(() {
                                  climaTarde = "Vientos Fuertes";
                                  bgcSunnyT = Colors.black;
                                  fgcSunnyT = Colors.white;
                                  bgcWindyT = Colors.blue;
                                  fgcWindyT = Colors.grey;
                                  bgcCloudyT = Colors.black;
                                  fgcCloudyT = Colors.white;
                                  bgcRainyT = Colors.black;
                                  fgcRainyT = Colors.white;
                                });

                              }else{
                                displayToastMessages("Solo Kapital", context);
                              }

                            },
                            icon: Icon(
                                Icons.wind_power
                            ),
                            label: Text(""),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: bgcWindyT,
                                foregroundColor: fgcWindyT
                            )
                        ),
                        ElevatedButton.icon(
                            onPressed: (){

                              if(enableKapWidget){

                                dailyWorkRef
                                    .child(currentProjectId)
                                    .child(selectedDate)
                                    .child(userCode!)
                                    .child("ClimaTarde")
                                    .set("Nublado");

                                setState(() {
                                  climaTarde = "Nublado";
                                  bgcSunnyT = Colors.black;
                                  fgcSunnyT = Colors.white;
                                  bgcWindyT = Colors.black;
                                  fgcWindyT = Colors.white;
                                  bgcCloudyT = Colors.grey;
                                  fgcCloudyT = Colors.black26;
                                  bgcRainyT = Colors.black;
                                  fgcRainyT = Colors.white;
                                });

                              }else{
                                displayToastMessages("Solo Kapital", context);
                              }

                            },
                            icon: Icon(
                                Icons.cloud
                            ),
                            label: Text(""),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: bgcCloudyT,
                                foregroundColor: fgcCloudyT
                            )
                        ),
                        ElevatedButton.icon(
                            onPressed: (){

                              if(enableKapWidget){

                                dailyWorkRef
                                    .child(currentProjectId)
                                    .child(selectedDate)
                                    .child(userCode!)
                                    .child("ClimaTarde")
                                    .set("Lluvioso");

                                setState(() {
                                  climaTarde = "Lluvioso";
                                  bgcSunnyT = Colors.black;
                                  fgcSunnyT = Colors.white;
                                  bgcWindyT = Colors.black;
                                  fgcWindyT = Colors.white;
                                  bgcCloudyT = Colors.black;
                                  fgcCloudyT = Colors.white;
                                  bgcRainyT = Colors.grey;
                                  fgcRainyT = Colors.blue;
                                });

                              }else{
                                displayToastMessages("Solo Kapital", context);
                              }

                            },
                            icon: Icon(
                                Icons.water_drop_rounded
                            ),
                            label: Text(""),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: bgcRainyT,
                                foregroundColor: fgcRainyT
                            )
                        )
                      ],
                    ),
                  ],
                ),

                Divider(
                  height: 3.0,
                  thickness: 3,
                  color: Colors.black,
                ),

                SizedBox(height: 3.0,),

                Text(
                  "Registro Fotográfico Kapital",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),

                SizedBox(height: 3.0,),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        if(enableKapWidget){
                          setState(() {
                            takenImageKap1 = null;
                          });
                          pickImageFromCamera("Kapital",1);
                        }else{
                          displayToastMessages("Solo Kapital", context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.lightGreen
                      ),
                      icon: Icon(
                        Icons.camera,
                        color: Colors.orange,
                        size: 25,
                      ),
                      label: Text(
                        "Foto 1",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(width: 1.0,),
                    ElevatedButton.icon(
                        onPressed: () {
                          if(enableKapWidget){
                            setState(() {
                              takenImageKap2 = null;
                            });
                            pickImageFromCamera("Kapital",2);
                          }else{
                            displayToastMessages("Solo Kapital", context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen
                        ),
                        icon: Icon(
                          Icons.camera,
                          color: Colors.red,
                          size: 25,
                        ),
                        label: Text(
                          "Foto 2",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: screenWidth,
                      child:
                      (image1KapStream != null && takenImageKap1 == null) ?
                      FadeInImage(
                          placeholder: AssetImage('images/loading_snail.gif'),
                          image: Image.memory(image1KapStream!).image,
                          fit: BoxFit.fill
                      ) :
                      takenImageKap1 != null ?
                      Image.file(takenImageKap1!,
                        fit: BoxFit.fill,
                      ) :
                      const Text("Tome la imagen 1"),
                    ),
                    Container(
                      height: 200,
                      width: screenWidth,
                      child:
                      (image2KapStream != null && takenImageKap2 == null) ?
                      FadeInImage(
                          placeholder: AssetImage('images/loading_snail.gif'),
                          image: Image.memory(image2KapStream!).image,
                          fit: BoxFit.fill
                      ) :
                      takenImageKap2 != null ?
                      Image.file(takenImageKap2!,
                        fit: BoxFit.fill,
                      ) :
                      const Text("Tome la imagen 2"),
                    )
                  ],
                ),

                SizedBox(height: 1.0,),

                Focus(
                  child: TextField(
                      controller: photoDescKapital1TEC,
                      keyboardType: TextInputType.multiline,
                      enabled: enableKapWidget,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Descripción Imagen 1 Kapital",
                          labelStyle: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "Brand-Bold",
                              color: Colors.black
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0,fontFamily: "Brand-Regular",color: Colors.black),
                      onChanged: (String? value){

                      }
                  ),
                  onFocusChange: (hasFocus){
                    if(!hasFocus){
                      dailyWorkRef
                          .child(currentProjectId)
                          .child(selectedDate)
                          .child(userCode!)
                          .child("DescImg1Kap")
                          .set(photoDescKapital1TEC.text);
                    }
                  },
                ),

                SizedBox(height: 1.0,),

                Focus(
                  child: TextField(
                      controller: photoDescKapital2TEC,
                      keyboardType: TextInputType.multiline,
                      enabled: enableKapWidget,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Descripción Imagen 2 Kapital",
                          labelStyle: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "Brand-Bold",
                              color: Colors.black
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0,fontFamily: "Brand-Regular",color: Colors.black),
                      onChanged: (String? value){

                      }
                  ),
                  onFocusChange: (hasFocus){
                    if(!hasFocus){
                      dailyWorkRef
                          .child(currentProjectId)
                          .child(selectedDate)
                          .child(userCode!)
                          .child("DescImg2Kap")
                          .set(photoDescKapital2TEC.text);
                    }
                  },
                ),

                SizedBox(height: 1.0,),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          if(enableKapWidget){
                            setState(() {
                              takenImageKap3 = null;
                            });
                            pickImageFromCamera("Kapital",3);
                          }else{
                            displayToastMessages("Solo Kapital", context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen
                        ),
                        icon: Icon(
                          Icons.camera,
                          color: Colors.orange,
                          size: 25,
                        ),
                        label: Text(
                          "Foto 3",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                    SizedBox(width: 1.0,),
                    ElevatedButton.icon(
                        onPressed: () {
                          if(enableKapWidget){
                            setState(() {
                              takenImageKap4 = null;
                            });
                            pickImageFromCamera("Kapital",4);
                          }else{
                            displayToastMessages("Solo Kapital", context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen
                        ),
                        icon: Icon(
                          Icons.camera,
                          color: Colors.red,
                          size: 25,
                        ),
                        label: Text(
                          "Foto 4",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 200,
                      width: screenWidth,
                      child:
                      (image3KapStream != null && takenImageKap3 == null) ?
                      FadeInImage(
                          placeholder: AssetImage('images/loading_snail.gif'),
                          image: Image.memory(image3KapStream!).image,
                          fit: BoxFit.fill
                      ) :
                      takenImageKap3 != null ?
                      Image.file(takenImageKap3!,
                        fit: BoxFit.fill,
                      ) :
                      const Text("Tome la imagen 3"),
                    ),
                    Container(
                      height: 200,
                      width: screenWidth,
                      child:
                      (image4KapStream != null && takenImageKap4 == null) ?
                      FadeInImage(
                          placeholder: AssetImage('images/loading_snail.gif'),
                          image: Image.memory(image4KapStream!).image,
                          fit: BoxFit.fill
                      ) :
                      takenImageKap4 != null ?
                      Image.file(takenImageKap4!,
                        fit: BoxFit.fill,
                      ) :
                      const Text("Tome la imagen 4"),
                    )
                  ],
                ),

                SizedBox(height: 1.0,),

                Focus(
                  child: TextField(
                      controller: photoDescKapital3TEC,
                      keyboardType: TextInputType.multiline,
                      enabled: enableKapWidget,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Descripción Imagen 3 Kapital",
                          labelStyle: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "Brand-Bold",
                              color: Colors.black
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0,fontFamily: "Brand-Regular",color: Colors.black),
                      onChanged: (String? value){

                      }
                  ),
                  onFocusChange: (hasFocus){
                    if(!hasFocus){
                      dailyWorkRef
                          .child(currentProjectId)
                          .child(selectedDate)
                          .child(userCode!)
                          .child("DescImg3Kap")
                          .set(photoDescKapital3TEC.text);
                    }
                  },
                ),

                SizedBox(height: 1.0,),

                Focus(
                  child: TextField(
                      controller: photoDescKapital4TEC,
                      keyboardType: TextInputType.multiline,
                      enabled: enableKapWidget,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Descripción Imagen 4 Kapital",
                          labelStyle: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "Brand-Bold",
                              color: Colors.black
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0,fontFamily: "Brand-Regular",color: Colors.black),
                      onChanged: (String? value){

                      }
                  ),
                  onFocusChange: (hasFocus){
                    if(!hasFocus){
                      dailyWorkRef
                          .child(currentProjectId)
                          .child(selectedDate)
                          .child(userCode!)
                          .child("DescImg4Kap")
                          .set(photoDescKapital4TEC.text);
                    }
                  },
                ),

                SizedBox(height: 1.0,),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          if(enableKapWidget){
                            setState(() {
                              takenImageKap5 = null;
                            });
                            pickImageFromCamera("Kapital",5);
                          }else{
                            displayToastMessages("Solo Kapital", context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen
                        ),
                        icon: Icon(
                          Icons.camera,
                          color: Colors.orange,
                          size: 25,
                        ),
                        label: Text(
                          "Foto 5",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                    SizedBox(width: 1.0,),
                    ElevatedButton.icon(
                        onPressed: () {
                          if(enableKapWidget){
                            setState(() {
                              takenImageKap6 = null;
                            });
                            pickImageFromCamera("Kapital",6);
                          }else{
                            displayToastMessages("Solo Kapital", context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen
                        ),
                        icon: Icon(
                          Icons.camera,
                          color: Colors.red,
                          size: 25,
                        ),
                        label: Text(
                          "Foto 6",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 200,
                      width: screenWidth,
                      child:
                      (image5KapStream != null && takenImageKap5 == null) ?
                      FadeInImage(
                          placeholder: AssetImage('images/loading_snail.gif'),
                          image: Image.memory(image5KapStream!).image,
                          fit: BoxFit.fill
                      ) :
                      takenImageKap5 != null ?
                      Image.file(takenImageKap5!,
                        fit: BoxFit.fill,
                      ) :
                      const Text("Tome la imagen 5"),
                    ),
                    Container(
                      height: 200,
                      width: screenWidth,
                      child:
                      (image6KapStream != null && takenImageKap6 == null) ?
                      FadeInImage(
                          placeholder: AssetImage('images/loading_snail.gif'),
                          image: Image.memory(image6KapStream!).image,
                          fit: BoxFit.fill
                      ) :
                      takenImageKap6 != null ?
                      Image.file(takenImageKap6!,
                        fit: BoxFit.fill,
                      ) :
                      const Text("Tome la imagen 6"),
                    )
                  ],
                ),

                SizedBox(height: 1.0,),

                Focus(
                  child: TextField(
                      controller: photoDescKapital5TEC,
                      keyboardType: TextInputType.multiline,
                      enabled: enableKapWidget,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Descripción Imagen 5 Kapital",
                          labelStyle: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "Brand-Bold",
                              color: Colors.black
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0,fontFamily: "Brand-Regular",color: Colors.black),
                      onChanged: (String? value){

                      }
                  ),
                  onFocusChange: (hasFocus){
                    if(!hasFocus){
                      dailyWorkRef
                          .child(currentProjectId)
                          .child(selectedDate)
                          .child(userCode!)
                          .child("DescImg5Kap")
                          .set(photoDescKapital5TEC.text);
                    }
                  },
                ),

                SizedBox(height: 1.0,),

                Focus(
                  child: TextField(
                      controller: photoDescKapital6TEC,
                      keyboardType: TextInputType.multiline,
                      enabled: enableKapWidget,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Descripción Imagen 6 Kapital",
                          labelStyle: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "Brand-Bold",
                              color: Colors.black
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0,fontFamily: "Brand-Regular",color: Colors.black),
                      onChanged: (String? value){

                      }
                  ),
                  onFocusChange: (hasFocus){
                    if(!hasFocus){
                      dailyWorkRef
                          .child(currentProjectId)
                          .child(selectedDate)
                          .child(userCode!)
                          .child("DescImg6Kap")
                          .set(photoDescKapital6TEC.text);
                    }
                  },
                ),

                SizedBox(height: 10.0,),
                Divider(
                  height: 2,
                  thickness: 2,
                  color: Colors.black,
                ),

                SizedBox(height: 3.0,),

                Divider(
                  height: 3,
                  thickness: 3,
                  color: Colors.black,
                ),

                SizedBox(
                  height: 2.0,
                ),

                SizedBox(height: 1.0,),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () async{
                          if(enableKapWidget){
                            var kapitalSignPath = await Navigator.push(context, MaterialPageRoute(builder: (c)=>SignatureDailyWorkScreen(
                              selectedDate: selectedDate,
                            )));

                            if(kapitalSignPath != ""){
                              fullNameKapital = fullNameG!;
                              dailyWorkRef
                                  .child(currentProjectId)
                                  .child(selectedDate)
                                  .child(userCode!)
                                  .child("FullNameKapital")
                                  .set(fullNameG);
                            }

                          }else{
                            displayToastMessages("Solo Kapital", context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen
                        ),
                        icon: Icon(
                          Icons.draw_rounded,
                          color: Colors.blue,
                          size: 25,
                        ),
                        label: Text(
                          "Firmar",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    )
                  ],
                ),

                SizedBox(
                  height: 5.0,
                ),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 200,
                      width: screenWidth,
                      child:
                      (signKapitalStream != null && imageBytesSignKapital == null) ?
                      FadeInImage(
                          placeholder: AssetImage('images/loading_snail.gif'),
                          image: Image.memory(signKapitalStream!).image,
                          fit: BoxFit.fill
                      ) :
                      (imageBytesSignKapital != null ?
                      Image.memory(imageBytesSignKapital!,fit: BoxFit.fill,) :
                      Text("Firma Kapital")
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 2.0,
                ),

                Divider(
                  height: 3.0,
                  thickness: 3.0,
                  color: Colors.black,
                ),

                SizedBox(
                  height: 2.0,
                ),

              ],
            ),
          ),
        ),

      ),

    );

  }
  

  void retrieveWorkInfoInfo(String selectedDate){

    dailyWorkRef
        .child(currentProjectId)
        .child(selectedDate)
        .child(userCode!)
        .once()
        .then((eventSnap){

      if(eventSnap.snapshot.value == null){
        return;
      }

      if((eventSnap.snapshot.value as Map)["ClimaManana"] != null){
        String texto = (eventSnap.snapshot.value as Map)["ClimaManana"];
        setState(() {

          if(texto == "Soleado"){
            climaManana = "Soleado";
            bgcSunnyM = Colors.blue;
            fgcSunnyM = Colors.yellow;
            bgcWindyM = Colors.black;
            fgcWindyM = Colors.white;
            bgcCloudyM = Colors.black;
            fgcCloudyM = Colors.white;
            bgcRainyM = Colors.black;
            fgcRainyM = Colors.white;
          }else
          if(texto == "Vientos Fuertes"){
            climaManana = "Vientos Fuertes";
            bgcSunnyM = Colors.black;
            fgcSunnyM = Colors.white;
            bgcWindyM = Colors.blue;
            fgcWindyM = Colors.grey;
            bgcCloudyM = Colors.black;
            fgcCloudyM = Colors.white;
            bgcRainyM = Colors.black;
            fgcRainyM = Colors.white;
          }else
          if(texto == "Nublado"){
            climaManana = "Nublado";
            bgcSunnyM = Colors.black;
            fgcSunnyM = Colors.white;
            bgcWindyM = Colors.black;
            fgcWindyM = Colors.white;
            bgcCloudyM = Colors.grey;
            fgcCloudyM = Colors.black26;
            bgcRainyM = Colors.black;
            fgcRainyM = Colors.white;
          }else
          if(texto == "Lluvioso"){
            climaManana = "Lluvioso";
            bgcSunnyM = Colors.black;
            fgcSunnyM = Colors.white;
            bgcWindyM = Colors.black;
            fgcWindyM = Colors.white;
            bgcCloudyM = Colors.black;
            fgcCloudyM = Colors.white;
            bgcRainyM = Colors.grey;
            fgcRainyM = Colors.blue;
          }

        });
      }

      if((eventSnap.snapshot.value as Map)["ClimaTarde"] != null){
        String texto = (eventSnap.snapshot.value as Map)["ClimaTarde"];
        setState(() {

          if(texto == "Soleado"){
            climaTarde = "Soleado";
            bgcSunnyT = Colors.blue;
            fgcSunnyT = Colors.yellow;
            bgcWindyT = Colors.black;
            fgcWindyT = Colors.white;
            bgcCloudyT = Colors.black;
            fgcCloudyT = Colors.white;
            bgcRainyT = Colors.black;
            fgcRainyT = Colors.white;
          }else
          if(texto == "Vientos Fuertes"){
            climaTarde = "Vientos Fuertes";
            bgcSunnyT = Colors.black;
            fgcSunnyT = Colors.white;
            bgcWindyT = Colors.blue;
            fgcWindyT = Colors.grey;
            bgcCloudyT = Colors.black;
            fgcCloudyT = Colors.white;
            bgcRainyT = Colors.black;
            fgcRainyT = Colors.white;
          }else
          if(texto == "Nublado"){
            climaTarde = "Nublado";
            bgcSunnyT = Colors.black;
            fgcSunnyT = Colors.white;
            bgcWindyT = Colors.black;
            fgcWindyT = Colors.white;
            bgcCloudyT = Colors.grey;
            fgcCloudyT = Colors.black26;
            bgcRainyT = Colors.black;
            fgcRainyT = Colors.white;
          }else
          if(texto == "Lluvioso"){
            climaTarde = "Lluvioso";
            bgcSunnyT = Colors.black;
            fgcSunnyT = Colors.white;
            bgcWindyT = Colors.black;
            fgcWindyT = Colors.white;
            bgcCloudyT = Colors.black;
            fgcCloudyT = Colors.white;
            bgcRainyT = Colors.grey;
            fgcRainyT = Colors.blue;
          }

        });
      }

      if((eventSnap.snapshot.value as Map)["Image_1_Kapital"] != null){
        String texto = (eventSnap.snapshot.value as Map)["Image_1_Kapital"];
        setState(() {
          image1KapitalURL = texto;
          fileFromImageUrl(image1KapitalURL,"Kapital",1);
        });
      }

      if((eventSnap.snapshot.value as Map)["DescImg1Kap"] != null){
        String texto = (eventSnap.snapshot.value as Map)["DescImg1Kap"];
        setState(() {
          photoDescKapital1TEC.text = texto;
        });
      }

      if((eventSnap.snapshot.value as Map)["Image_2_Kapital"] != null){
        String texto = (eventSnap.snapshot.value as Map)["Image_2_Kapital"];
        setState(() {
          image2KapitalURL = texto;
          fileFromImageUrl(image2KapitalURL,"Kapital",2);
        });
      }

      if((eventSnap.snapshot.value as Map)["DescImg2Kap"] != null){
        String texto = (eventSnap.snapshot.value as Map)["DescImg2Kap"];
        setState(() {
          photoDescKapital2TEC.text = texto;
        });
      }

      if((eventSnap.snapshot.value as Map)["Image_3_Kapital"] != null){
        String texto = (eventSnap.snapshot.value as Map)["Image_3_Kapital"];
        setState(() {
          image3KapitalURL = texto;
          fileFromImageUrl(image3KapitalURL,"Kapital",3);
        });
      }

      if((eventSnap.snapshot.value as Map)["DescImg3Kap"] != null){
        String texto = (eventSnap.snapshot.value as Map)["DescImg3Kap"];
        setState(() {
          photoDescKapital3TEC.text = texto;
        });
      }

      if((eventSnap.snapshot.value as Map)["Image_4_Kapital"] != null){
        String texto = (eventSnap.snapshot.value as Map)["Image_4_Kapital"];
        setState(() {
          image4KapitalURL = texto;
          fileFromImageUrl(image4KapitalURL,"Kapital",4);
        });
      }

      if((eventSnap.snapshot.value as Map)["DescImg4Kap"] != null){
        String texto = (eventSnap.snapshot.value as Map)["DescImg4Kap"];
        setState(() {
          photoDescKapital4TEC.text = texto;
        });
      }

      if((eventSnap.snapshot.value as Map)["Image_5_Kapital"] != null){
        String texto = (eventSnap.snapshot.value as Map)["Image_5_Kapital"];
        setState(() {
          image5KapitalURL = texto;
          fileFromImageUrl(image5KapitalURL,"Kapital",5);
        });
      }

      if((eventSnap.snapshot.value as Map)["DescImg5Kap"] != null){
        String texto = (eventSnap.snapshot.value as Map)["DescImg5Kap"];
        setState(() {
          photoDescKapital5TEC.text = texto;
        });
      }

      if((eventSnap.snapshot.value as Map)["Image_6_Kapital"] != null){
        String texto = (eventSnap.snapshot.value as Map)["Image_6_Kapital"];
        setState(() {
          image6KapitalURL = texto;
          fileFromImageUrl(image6KapitalURL,"Kapital",6);
        });
      }

      if((eventSnap.snapshot.value as Map)["DescImg6Kap"] != null){
        String texto = (eventSnap.snapshot.value as Map)["DescImg6Kap"];
        setState(() {
          photoDescKapital6TEC.text = texto;
        });
      }

      if((eventSnap.snapshot.value as Map)["Sign_Kapital"] != null){
        String texto = (eventSnap.snapshot.value as Map)["Sign_Kapital"];
        setState(() {
          signKapitalURL = texto;
          fileFromSignImageUrl(signKapitalURL,"Kapital");
        });
      }

      if((eventSnap.snapshot.value as Map)["FullNameKapital"] != null){
        String texto = (eventSnap.snapshot.value as Map)["FullNameKapital"];
        setState(() {
          fullNameKapital = texto;
        });
      }

    });

  }

  Future pickImageFromCamera(String taker,int imageNumber) async{

    var response = await showDialog(
        context: context,
        builder: (BuildContext c) => RequestCameraOrGallery(

        ));

    XFile? returnedImage;

    if(response == "Camara"){
      returnedImage = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 30);
    }else
    if(response == "Galeria"){
      returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 30);
    }

    if(returnedImage == null) return;

    String timeStamp = DateTime.now().year.toString()+DateTime.now().month.toString()+DateTime.now().day.toString()+DateTime.now().hour.toString()+DateTime.now().minute.toString()+DateTime.now().second.toString();

    String dir = path.dirname(returnedImage.path);
    String newFilename = "${taker}_${selectedDate}_${imageNumber.toString()}_${timeStamp}.jpg";
    String newPathName = path.join(dir,"${newFilename}.jpg");
    File imageFile = File(returnedImage.path).renameSync(newPathName);

    var appDirectory = await getDownloadsDirectory();

    Directory folderDir = Directory("${appDirectory!.path}/DailyWork/Fotos/${selectedDate}");

    if(await folderDir.exists() == false){
      await folderDir.create(recursive: true);
    }

    File newImageFile = await imageFile.copy("${folderDir.path}/${newFilename}");

    final uploaded = uploadImageToServer(newFilename, newImageFile,imageNumber);

    setState(() {
      if(taker == "Kapital" && imageNumber==1){
        takenImageKap1 = null;
        takenImageKap1 = newImageFile;
        image1KapStream = newImageFile.readAsBytesSync();
      }else
      if(taker == "Kapital" && imageNumber==2){
        takenImageKap2 = null;
        takenImageKap2 = newImageFile;
        image2KapStream = newImageFile.readAsBytesSync();
      }else
      if(taker == "Kapital" && imageNumber==3){
        takenImageKap3 = null;
        takenImageKap3 = newImageFile;
        image3KapStream = newImageFile.readAsBytesSync();
      }else
      if(taker == "Kapital" && imageNumber==4){
        takenImageKap4 = null;
        takenImageKap4 = newImageFile;
        image4KapStream = newImageFile.readAsBytesSync();
      }else
      if(taker == "Kapital" && imageNumber==5){
        takenImageKap5 = null;
        takenImageKap5 = newImageFile;
        image5KapStream = newImageFile.readAsBytesSync();
      }else
      if(taker == "Kapital" && imageNumber==6){
        takenImageKap6 = null;
        takenImageKap6 = newImageFile;
        image6KapStream = newImageFile.readAsBytesSync();
      }
    });

  }

  Future<bool> uploadImageToServer(String newFilename, File newImageFile, int imageNumber) async{

    final Reference refStorage = dailyWorkPhotosRef.child("Fotos").child(selectedDate).child(userCode!).child(newFilename);

    final UploadTask uploadTask = refStorage.putFile(newImageFile);

    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => true);

    if(taskSnapshot.state == TaskState.success){
      final String url = await taskSnapshot.ref.getDownloadURL();

      dailyWorkRef
          .child(currentProjectId)
          .child(selectedDate)
          .child(userCode!)
          .child("Image_${imageNumber.toString()}_${userType}")
          .set(url);


      displayToastMessages("Imagen cargada correctamente", context);

      return true;

    }else{
      return false;
    }

  }

  Future fileFromImageUrl(String url,String taker,int imageNumber) async {

    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200){

      setState(() {
        if(taker == "Kapital" && imageNumber==1){
          takenImageKap1 = null;
          image1KapStream = response.bodyBytes;
        }else
        if(taker == "Kapital" && imageNumber==2){
          takenImageKap2 = null;
          image2KapStream = response.bodyBytes;
        }else
        if(taker == "Kapital" && imageNumber==3){
          takenImageKap3 = null;
          image3KapStream = response.bodyBytes;
        }else
        if(taker == "Kapital" && imageNumber==4){
          takenImageKap4 = null;
          image4KapStream = response.bodyBytes;
        }else
        if(taker == "Kapital" && imageNumber==5){
          takenImageKap5 = null;
          image5KapStream = response.bodyBytes;
        }else
        if(taker == "Kapital" && imageNumber==6){
          takenImageKap6 = null;
          image6KapStream = response.bodyBytes;
        }
      });

    }

  }

  Future fileFromSignImageUrl(String url,String taker) async {

    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200){

      setState(() {
        if(taker == "Kapital"){
          signKapitalStream = response.bodyBytes;
          Provider.of<AppData>(context, listen: false).saveKapitalSignature(signKapitalStream!);
        }
      });

    }

  }


  void cleanForm() {

    setState(() {

      photoDescKapital1TEC = TextEditingController();
      photoDescKapital2TEC = TextEditingController();
      photoDescKapital3TEC = TextEditingController();
      photoDescKapital4TEC = TextEditingController();
      photoDescKapital5TEC = TextEditingController();
      photoDescKapital6TEC = TextEditingController();

      takenImageKap1 = null;
      takenImageKap2 = null;
      takenImageKap3 = null;
      takenImageKap4 = null;
      takenImageKap5 = null;
      takenImageKap6 = null;

      image1KapStream = null;
      image2KapStream = null;
      image3KapStream = null;
      image4KapStream = null;
      image5KapStream = null;
      image6KapStream = null;

      image1KapitalURL = "";
      image2KapitalURL = "";
      image3KapitalURL = "";
      image4KapitalURL = "";
      image5KapitalURL = "";
      image6KapitalURL = "";

      signKapitalURL = "";

      imageBytesSignKapital = null;
      imageBytesSignInterv = null;

      dailyWorkActModel = DailyWorkAct();

      Provider.of<AppData>(context, listen: false).cleanSignature();
    });

  }
}
