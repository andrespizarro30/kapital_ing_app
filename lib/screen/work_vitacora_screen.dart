import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kapital_ing_app/main.dart';
import 'package:kapital_ing_app/screen/signature_vitacora_screen.dart';
import 'package:kapital_ing_app/widgets/request_if_close.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

import 'package:http/http.dart' as http;

import '../common_functions/PdfCreatorBitacora.dart';
import '../common_functions/common_functions.dart';
import '../data_handler/app_data.dart';
import '../models/bitacora_act_model.dart';
import '../widgets/request_camera_gallery.dart';



class WorkVitacoraScreen extends StatefulWidget {
  const WorkVitacoraScreen({super.key});

  @override
  State<WorkVitacoraScreen> createState() => _WorkVitacoraScreenState();
}

class _WorkVitacoraScreenState extends State<WorkVitacoraScreen> {

  TextEditingController dateSelectedTEC = TextEditingController();
  TextEditingController generalObservTEC = TextEditingController();

  TextEditingController photoDescKapital1TEC = TextEditingController();
  TextEditingController photoDescKapital2TEC = TextEditingController();
  TextEditingController photoDescKapital3TEC = TextEditingController();
  TextEditingController photoDescKapital4TEC = TextEditingController();
  TextEditingController photoDescKapital5TEC = TextEditingController();
  TextEditingController photoDescKapital6TEC = TextEditingController();

  TextEditingController photoDescInterv1TEC = TextEditingController();
  TextEditingController photoDescInterv2TEC = TextEditingController();
  TextEditingController photoDescInterv3TEC = TextEditingController();
  TextEditingController photoDescInterv4TEC = TextEditingController();
  TextEditingController photoDescInterv5TEC = TextEditingController();
  TextEditingController photoDescInterv6TEC = TextEditingController();

  TextEditingController observsKapitalTEC = TextEditingController();
  TextEditingController observsIntervTEC = TextEditingController();

  String selectedDate = "";

  File? takenImageKap1 = null;
  File? takenImageKap2 = null;
  File? takenImageKap3 = null;
  File? takenImageKap4 = null;
  File? takenImageKap5 = null;
  File? takenImageKap6 = null;

  File? takenImageInterv1 = null;
  File? takenImageInterv2 = null;
  File? takenImageInterv3 = null;
  File? takenImageInterv4 = null;
  File? takenImageInterv5 = null;
  File? takenImageInterv6 = null;

  Uint8List? image1KapStream = null;
  Uint8List? image2KapStream = null;
  Uint8List? image3KapStream = null;
  Uint8List? image4KapStream = null;
  Uint8List? image5KapStream = null;
  Uint8List? image6KapStream = null;

  Uint8List? image1IntervStream = null;
  Uint8List? image2IntervStream = null;
  Uint8List? image3IntervStream = null;
  Uint8List? image4IntervStream = null;
  Uint8List? image5IntervStream = null;
  Uint8List? image6IntervStream = null;

  String image1KapitalURL = "";
  String image2KapitalURL = "";
  String image3KapitalURL = "";
  String image4KapitalURL = "";
  String image5KapitalURL = "";
  String image6KapitalURL = "";

  String image1IntervURL = "";
  String image2IntervURL = "";
  String image3IntervURL = "";
  String image4IntervURL = "";
  String image5IntervURL = "";
  String image6IntervURL = "";

  String image1KapitalURL_ant = "";
  String image2KapitalURL_ant = "";
  String image3KapitalURL_ant = "";
  String image4KapitalURL_ant = "";
  String image5KapitalURL_ant = "";
  String image6KapitalURL_ant = "";

  String image1IntervURL_ant = "";
  String image2IntervURL_ant = "";
  String image3IntervURL_ant = "";
  String image4IntervURL_ant = "";
  String image5IntervURL_ant = "";
  String image6IntervURL_ant = "";

  Uint8List? signKapitalStream = null;
  Uint8List? signIntervStream = null;

  String signKapitalURL = "";
  String signIntervURL = "";

  String fullNameKapital = "";
  String fullNameInterv = "";

  bool VBKapital = false;
  bool VBInterv = false;

  bool ClosedKapital = false;
  bool ClosedInterv = false;

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

  BitacoraActModel? bitacoraActModel;

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bitacoraActModel = BitacoraActModel();

  }

  @override
  Widget build(BuildContext context){

    imageBytesSignKapital = Provider.of<AppData>(context).imageBytesSignKapital != null
        ? Provider.of<AppData>(context).imageBytesSignKapital!
        : null;

    imageBytesSignInterv = Provider.of<AppData>(context).imageBytesSignInterv != null
        ? Provider.of<AppData>(context).imageBytesSignInterv!
        : null;

    double screenWidth = MediaQuery.of(context).size.width * 0.4;

    bool enableKapWidget = (userType == "Kapital" && !ClosedKapital && !ClosedInterv ? true : false);

    bool enableIntervWidget = (userType == "Interv" && !ClosedKapital && !ClosedInterv ? true : false);

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

                      retrieveVitacoraInfo(selectedDate);

                      vitacorasOtherUserUpdate(selectedDate);

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

                  bitacoraActModel!.dateSelected =  dateSelectedTEC.text;
                  bitacoraActModel!.ObservacionGeneral = generalObservTEC.text;

                  bitacoraActModel!.Image_1Kapital = image1KapStream;
                  bitacoraActModel!.Image_2Kapital = image2KapStream;
                  bitacoraActModel!.Image_3Kapital = image3KapStream;
                  bitacoraActModel!.Image_4Kapital = image4KapStream;
                  bitacoraActModel!.Image_5Kapital = image5KapStream;
                  bitacoraActModel!.Image_6Kapital = image6KapStream;

                  bitacoraActModel!.DescImg1Kap =  photoDescKapital1TEC.text;
                  bitacoraActModel!.DescImg2Kap =  photoDescKapital2TEC.text;
                  bitacoraActModel!.DescImg3Kap =  photoDescKapital3TEC.text;
                  bitacoraActModel!.DescImg4Kap =  photoDescKapital4TEC.text;
                  bitacoraActModel!.DescImg5Kap =  photoDescKapital5TEC.text;
                  bitacoraActModel!.DescImg6Kap =  photoDescKapital6TEC.text;

                  bitacoraActModel!.Image_1Interv = image1IntervStream;
                  bitacoraActModel!.Image_2Interv = image2IntervStream;
                  bitacoraActModel!.Image_3Interv = image3IntervStream;
                  bitacoraActModel!.Image_4Interv = image4IntervStream;
                  bitacoraActModel!.Image_5Interv = image5IntervStream;
                  bitacoraActModel!.Image_6Interv = image6IntervStream;

                  bitacoraActModel!.DescImg1Interv =  photoDescInterv1TEC.text;
                  bitacoraActModel!.DescImg2Interv =  photoDescInterv2TEC.text;
                  bitacoraActModel!.DescImg3Interv =  photoDescInterv3TEC.text;
                  bitacoraActModel!.DescImg4Interv =  photoDescInterv4TEC.text;
                  bitacoraActModel!.DescImg5Interv =  photoDescInterv5TEC.text;
                  bitacoraActModel!.DescImg6Interv =  photoDescInterv6TEC.text;

                  bitacoraActModel!.ObservKapital =  observsKapitalTEC.text;
                  bitacoraActModel!.ObservInterv =  observsIntervTEC.text;

                  bitacoraActModel!.SignKapital = signKapitalStream;
                  bitacoraActModel!.SignInterv = signIntervStream;

                  bitacoraActModel!.ClimaManana = climaManana;
                  bitacoraActModel!.ClimaTarde = climaTarde;

                  bitacoraActModel!.VoBoKapital = VBKapital;
                  bitacoraActModel!.VoBoInterv = VBInterv;

                  bitacoraActModel!.ClosedKapital = ClosedKapital;
                  bitacoraActModel!.ClosedInterv = ClosedInterv;

                  bitacoraActModel!.FullNameInterv = fullNameInterv;
                  bitacoraActModel!.FullNameKapital = fullNameKapital;

                  PdfCreatorBitacora pdfDoc = PdfCreatorBitacora(bitacoraActModel: bitacoraActModel!);
                  await pdfDoc.createPDFDoc();
                  pdfDoc.saveAndLaunchFile();

                },
              ),
              visible: (VBKapital && VBInterv),
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
                Focus(
                  child: TextField(
                      controller: generalObservTEC,
                      keyboardType: TextInputType.multiline,
                      enabled: enableKapWidget,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Observación General",
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
                  onFocusChange: (hasFocus) {
                    if(!hasFocus){
                      vitacorasRef
                          .child(currentProjectId)
                          .child(selectedDate)
                          .child("ObservacionGeneral")
                          .set(generalObservTEC.text);
                    }
                  },
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

                              vitacorasRef
                                  .child(currentProjectId)
                                  .child(selectedDate)
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

                              vitacorasRef
                                  .child(currentProjectId)
                                  .child(selectedDate)
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

                              vitacorasRef
                                  .child(currentProjectId)
                                  .child(selectedDate)
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

                              vitacorasRef
                                  .child(currentProjectId)
                                  .child(selectedDate)
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

                                vitacorasRef
                                    .child(currentProjectId)
                                    .child(selectedDate)
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

                                vitacorasRef
                                    .child(currentProjectId)
                                    .child(selectedDate)
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

                                vitacorasRef
                                    .child(currentProjectId)
                                    .child(selectedDate)
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

                                vitacorasRef
                                    .child(currentProjectId)
                                    .child(selectedDate)
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
                      vitacorasRef
                          .child(currentProjectId)
                          .child(selectedDate)
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
                      vitacorasRef
                          .child(currentProjectId)
                          .child(selectedDate)
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
                      vitacorasRef
                          .child(currentProjectId)
                          .child(selectedDate)
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
                      vitacorasRef
                          .child(currentProjectId)
                          .child(selectedDate)
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
                      vitacorasRef
                          .child(currentProjectId)
                          .child(selectedDate)
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
                      vitacorasRef
                          .child(currentProjectId)
                          .child(selectedDate)
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
                Text(
                  "Registro Fotográfico Interventor",
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
                          if(enableIntervWidget){
                            setState(() {
                              takenImageInterv1 = null;
                            });
                            pickImageFromCamera("Interv",1);
                          }else{
                            displayToastMessages("Solo Interventoría", context);
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
                        )
                    ),
                    SizedBox(width: 1.0,),
                    ElevatedButton.icon(
                        onPressed: () {
                          if(enableIntervWidget){
                            setState(() {
                              takenImageInterv2 = null;
                            });
                            pickImageFromCamera("Interv",2);
                          }else{
                            displayToastMessages("Solo Interventoría", context);
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
                  children: [
                    Container(
                      height: 200,
                      width: screenWidth,
                      child:
                      (image1IntervStream != null && takenImageInterv1 == null) ?
                      FadeInImage(
                          placeholder: AssetImage('images/loading_snail.gif'),
                          image: Image.memory(image1IntervStream!).image,
                          fit: BoxFit.fill
                      ) :
                      takenImageInterv1 != null ?
                      Image.file(takenImageInterv1!,
                        fit: BoxFit.fill,
                      ) :
                      const Text("Tome la imagen 1"),
                    ),
                    Container(
                      height: 200,
                      width: screenWidth,
                      child:
                      (image2IntervStream != null && takenImageInterv2 == null) ?
                      FadeInImage(
                          placeholder: AssetImage('images/loading_snail.gif'),
                          image: Image.memory(image2IntervStream!).image,
                          fit: BoxFit.fill
                      ) :
                      takenImageInterv2 != null ?
                      Image.file(takenImageInterv2!,
                        fit: BoxFit.fill,
                      ) :
                      const Text("Tome la imagen 2"),
                    )
                  ],
                ),

                SizedBox(height: 1.0,),

                Focus(
                  child: TextField(
                      controller: photoDescInterv1TEC,
                      keyboardType: TextInputType.multiline,
                      enabled: enableIntervWidget,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Descripción Imagen 1 Interventoría",
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
                      vitacorasRef
                          .child(currentProjectId)
                          .child(selectedDate)
                          .child("DescImg1Interv")
                          .set(photoDescInterv1TEC.text);
                    }
                  },
                ),

                SizedBox(height: 1.0,),

                Focus(
                  child: TextField(
                      controller: photoDescInterv2TEC,
                      keyboardType: TextInputType.multiline,
                      enabled: enableIntervWidget,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Descripción Imagen 2 Interventoría",
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
                      vitacorasRef
                          .child(currentProjectId)
                          .child(selectedDate)
                          .child("DescImg2Interv")
                          .set(photoDescInterv2TEC.text);
                    }
                  },
                ),

                SizedBox(height: 3.0,),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          if(enableIntervWidget){
                            setState(() {
                              takenImageInterv3 = null;
                            });
                            pickImageFromCamera("Interv",3);
                          }else{
                            displayToastMessages("Solo Interventoría", context);
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
                          if(enableIntervWidget){
                            setState(() {
                              takenImageInterv4 = null;
                            });
                            pickImageFromCamera("Interv",4);
                          }else{
                            displayToastMessages("Solo Interventoría", context);
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
                      (image3IntervStream != null && takenImageInterv3 == null) ?
                      FadeInImage(
                          placeholder: AssetImage('images/loading_snail.gif'),
                          image: Image.memory(image3IntervStream!).image,
                          fit: BoxFit.fill
                      ) :
                      takenImageInterv3 != null ?
                      Image.file(takenImageInterv3!,
                        fit: BoxFit.fill,
                      ) :
                      const Text("Tome la imagen 3"),
                    ),
                    Container(
                      height: 200,
                      width: screenWidth,
                      child:
                      (image4IntervStream != null && takenImageInterv4 == null) ?
                      FadeInImage(
                          placeholder: AssetImage('images/loading_snail.gif'),
                          image: Image.memory(image4IntervStream!).image,
                          fit: BoxFit.fill
                      ) :
                      takenImageInterv4 != null ?
                      Image.file(takenImageInterv4!,
                        fit: BoxFit.fill,
                      ) :
                      const Text("Tome la imagen 4"),
                    )
                  ],
                ),

                SizedBox(height: 1.0,),

                Focus(
                  child: TextField(
                      controller: photoDescInterv3TEC,
                      keyboardType: TextInputType.multiline,
                      enabled: enableIntervWidget,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Descripción Imagen 3 Interventoría",
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
                      vitacorasRef
                          .child(currentProjectId)
                          .child(selectedDate)
                          .child("DescImg3Interv")
                          .set(photoDescInterv3TEC.text);
                    }
                  },
                ),

                SizedBox(height: 1.0,),

                Focus(
                  child: TextField(
                      controller: photoDescInterv4TEC,
                      keyboardType: TextInputType.multiline,
                      enabled: enableIntervWidget,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Descripción Imagen 4 Interventoría",
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
                      vitacorasRef
                          .child(currentProjectId)
                          .child(selectedDate)
                          .child("DescImg4Interv")
                          .set(photoDescInterv4TEC.text);
                    }
                  },
                ),

                SizedBox(height: 3.0,),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          if(enableIntervWidget){
                            setState(() {
                              takenImageInterv5 = null;
                            });
                            pickImageFromCamera("Interv",5);
                          }else{
                            displayToastMessages("Solo Interventoría", context);
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
                          if(enableIntervWidget){
                            setState(() {
                              takenImageInterv6 = null;
                            });
                            pickImageFromCamera("Interv",6);
                          }else{
                            displayToastMessages("Solo Interventoría", context);
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
                      (image5IntervStream != null && takenImageInterv5 == null) ?
                      FadeInImage(
                          placeholder: AssetImage('images/loading_snail.gif'),
                          image: Image.memory(image5IntervStream!).image,
                          fit: BoxFit.fill
                      ) :
                      takenImageInterv5 != null ?
                      Image.file(takenImageInterv5!,
                        fit: BoxFit.fill,
                      ) :
                      const Text("Tome la imagen 5"),
                    ),
                    Container(
                      height: 200,
                      width: screenWidth,
                      child:
                      (image6IntervStream != null && takenImageInterv6 == null) ?
                      FadeInImage(
                          placeholder: AssetImage('images/loading_snail.gif'),
                          image: Image.memory(image6IntervStream!).image,
                          fit: BoxFit.fill
                      ) :
                      takenImageInterv6 != null ?
                      Image.file(takenImageInterv6!,
                        fit: BoxFit.fill,
                      ) :
                      const Text("Tome la imagen 6"),
                    )
                  ],
                ),
                SizedBox(height: 1.0,),

                Focus(
                  child: TextField(
                      controller: photoDescInterv5TEC,
                      keyboardType: TextInputType.multiline,
                      enabled: enableIntervWidget,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Descripción Imagen 5 Interventoría",
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
                      vitacorasRef
                          .child(currentProjectId)
                          .child(selectedDate)
                          .child("DescImg5Interv")
                          .set(photoDescInterv5TEC.text);
                    }
                  },
                ),

                SizedBox(height: 1.0,),

                Focus(
                  child: TextField(
                      controller: photoDescInterv6TEC,
                      keyboardType: TextInputType.multiline,
                      enabled: enableIntervWidget,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Descripción Imagen 6 Interventoría",
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
                      vitacorasRef
                          .child(currentProjectId)
                          .child(selectedDate)
                          .child("DescImg6Interv")
                          .set(photoDescInterv6TEC.text);
                    }
                  },
                ),

                Divider(
                  height: 3,
                  thickness: 3,
                  color: Colors.black,
                ),

                SizedBox(
                  height: 2.0,
                ),

                Text(
                  "Observaciones Generales",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),

                SizedBox(
                  height: 2.0,
                ),

                Focus(
                  child: TextField(
                      controller: observsKapitalTEC,
                      keyboardType: TextInputType.multiline,
                      enabled: enableKapWidget,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Observaciónes Kapital",
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
                      vitacorasRef
                          .child(currentProjectId)
                          .child(selectedDate)
                          .child("ObservKapital")
                          .set(observsKapitalTEC.text);
                    }
                  },
                ),

                SizedBox(
                  height: 2.0,
                ),

                Focus(
                  child: TextField(
                      controller: observsIntervTEC,
                      keyboardType: TextInputType.multiline,
                      enabled: enableIntervWidget,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Observaciónes Interventoría",
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
                      vitacorasRef
                          .child(currentProjectId)
                          .child(selectedDate)
                          .child("ObservInterv")
                          .set(observsIntervTEC.text);
                    }
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "VºBº Kapital "
                    ),
                    Checkbox(
                        value: VBKapital,
                        onChanged: (bool? select){
                          if(enableKapWidget){
                            setState(() {
                              VBKapital = select!;

                              vitacorasRef
                                  .child(currentProjectId)
                                  .child(selectedDate)
                                  .child("VoBoKapital")
                                  .set(select);

                            });
                          }else{
                            displayToastMessages("Solo Kapital", context);
                          }
                        }
                    ),
                    Text(
                        "VºBº Interventoría "
                    ),
                    Checkbox(
                        value: VBInterv,
                        onChanged: (bool? select){
                          setState(() {
                            if(enableIntervWidget){
                              setState(() {
                                VBInterv = select!;

                                vitacorasRef
                                    .child(currentProjectId)
                                    .child(selectedDate)
                                    .child("VoBoInterv")
                                    .set(select);

                              });
                            }else{
                              displayToastMessages("Solo Interventoría", context);
                            }
                          });
                        }
                    )
                  ],
                ),

                SizedBox(height: 1.0,),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () async{
                          if(enableKapWidget){
                            var kapitalSignPath = await Navigator.push(context, MaterialPageRoute(builder: (c)=>SignatureVitacoraScreen(
                              selectedDate: selectedDate,
                            )));

                            if(kapitalSignPath != ""){
                              fullNameKapital = fullNameG!;
                              vitacorasRef
                                  .child(currentProjectId)
                                  .child(selectedDate)
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
                    ),
                    ElevatedButton.icon(
                        onPressed: () async{
                          if(enableIntervWidget){
                            var intervSignPath = await Navigator.push(context, MaterialPageRoute(builder: (c)=>SignatureVitacoraScreen(
                              selectedDate: selectedDate,
                            )));

                            if(intervSignPath != ""){
                              fullNameInterv = fullNameG!;
                              vitacorasRef
                                  .child(currentProjectId)
                                  .child(selectedDate)
                                  .child("FullNameInterv")
                                  .set(fullNameG);
                            }

                          }else{
                            displayToastMessages("Solo Interventoría", context);
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
                    ),
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

                    Container(
                      height: 200,
                      width: screenWidth,
                      child:
                      (signIntervStream != null && imageBytesSignInterv == null) ?
                      FadeInImage(
                          placeholder: AssetImage('images/loading_snail.gif'),
                          image: Image.memory(signIntervStream!).image,
                          fit: BoxFit.fill
                      ) :
                      (imageBytesSignInterv != null ?
                      Image.memory(imageBytesSignInterv!,fit: BoxFit.fill,) :
                      Text("Firma Interventoría")
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                        "Cerrado Kapital"
                    ),
                    Checkbox(
                        value: ClosedKapital,
                        onChanged: (bool? select) async{
                          if(userType == "Kapital" && !ClosedKapital){

                            var response = await showDialog(
                                context: context,
                                builder: (BuildContext c) => RequestIfClose(
                                ));

                            if(response == "SI"){

                              setState(() {

                                ClosedKapital = select!;

                                vitacorasRef
                                    .child(currentProjectId)
                                    .child(selectedDate)
                                    .child("ClosedKapital")
                                    .set(select);
                              });

                              displayToastMessages("Bitacora cerrada por parte de Kapital", context);
                            }

                          }else{
                            displayToastMessages("Solo Kapital", context);
                          }
                        }
                    ),
                    Text(
                        "Cerrado Interv."
                    ),
                    Checkbox(
                        value: ClosedInterv,
                        onChanged: (bool? select) async{
                          if(userType == "Interv" && !ClosedInterv){

                            var response = await showDialog(
                                context: context,
                                builder: (BuildContext c) => RequestIfClose(
                                ));

                            if(response == "SI"){

                              setState(() {

                                ClosedInterv = select!;

                                vitacorasRef
                                    .child(currentProjectId)
                                    .child(selectedDate)
                                    .child("ClosedInterv")
                                    .set(select);
                              });

                              displayToastMessages("Bitacora cerrada por parte de Interventoría", context);
                            }

                          }else{
                            displayToastMessages("Solo Interventoría", context);
                          }
                        }
                    )
                  ],
                ),

              ],
            ),
          ),
        ),

      ),

    );

  }

  void vitacorasOtherUserUpdate(String selectedDate){

    if(vitacorasInfoStreamSubscription != null){
      vitacorasInfoStreamSubscription?.pause();
      vitacorasInfoStreamSubscription?.cancel;
    }

    vitacorasInfoStreamSubscription = vitacorasRef
        .child(currentProjectId)
        .child(selectedDate)
        .onValue
        .listen((eventSnap) async{

      if(eventSnap.snapshot.value == null){
        return;
      }

      if(userType == "Kapital"){

        if((eventSnap.snapshot.value as Map)["Image_1_Interv"] != null){
          String texto = (eventSnap.snapshot.value as Map)["Image_1_Interv"];
          setState(() {
            image1IntervURL = texto;
            if(image1IntervURL != image1IntervURL_ant){
              image1IntervURL_ant = image1IntervURL;
              fileFromImageUrl(image1IntervURL,"Interv",1);
            }
          });
        }

        if((eventSnap.snapshot.value as Map)["DescImg1Interv"] != null){
          String texto = (eventSnap.snapshot.value as Map)["DescImg1Interv"];
          setState(() {
            photoDescInterv1TEC.text = texto;
          });
        }

        if((eventSnap.snapshot.value as Map)["Image_2_Interv"] != null){
          String texto = (eventSnap.snapshot.value as Map)["Image_2_Interv"];
          setState(() {
            image2IntervURL = texto;
            if(image2IntervURL != image2IntervURL_ant){
              image2IntervURL_ant = image2IntervURL;
              fileFromImageUrl(image2IntervURL,"Interv",2);
            }
          });
        }

        if((eventSnap.snapshot.value as Map)["DescImg2Interv"] != null){
          String texto = (eventSnap.snapshot.value as Map)["DescImg2Interv"];
          setState(() {
            photoDescInterv2TEC.text = texto;
          });
        }

        if((eventSnap.snapshot.value as Map)["Image_3_Interv"] != null){
          String texto = (eventSnap.snapshot.value as Map)["Image_3_Interv"];
          setState(() {
            image3IntervURL = texto;
            if(image3IntervURL != image3IntervURL_ant){
              image3IntervURL_ant = image3IntervURL;
              fileFromImageUrl(image3IntervURL,"Interv",3);
            }
          });
        }

        if((eventSnap.snapshot.value as Map)["DescImg3Interv"] != null){
          String texto = (eventSnap.snapshot.value as Map)["DescImg3Interv"];
          setState(() {
            photoDescInterv3TEC.text = texto;
          });
        }

        if((eventSnap.snapshot.value as Map)["Image_4_Interv"] != null){
          String texto = (eventSnap.snapshot.value as Map)["Image_4_Interv"];
          setState(() {
            image4IntervURL = texto;
            if(image4IntervURL != image4IntervURL_ant){
              image4IntervURL_ant = image4IntervURL;
              fileFromImageUrl(image4IntervURL,"Interv",4);
            }
          });
        }

        if((eventSnap.snapshot.value as Map)["DescImg4Interv"] != null){
          String texto = (eventSnap.snapshot.value as Map)["DescImg4Interv"];
          setState(() {
            photoDescInterv4TEC.text = texto;
          });
        }

        if((eventSnap.snapshot.value as Map)["Image_5_Interv"] != null){
          String texto = (eventSnap.snapshot.value as Map)["Image_5_Interv"];
          setState(() {
            image5IntervURL = texto;
            if(image5IntervURL != image5IntervURL_ant){
              image5IntervURL_ant = image5IntervURL;
              fileFromImageUrl(image5IntervURL,"Interv",5);
            }
          });
        }

        if((eventSnap.snapshot.value as Map)["DescImg5Interv"] != null){
          String texto = (eventSnap.snapshot.value as Map)["DescImg5Interv"];
          setState(() {
            photoDescInterv5TEC.text = texto;
          });
        }

        if((eventSnap.snapshot.value as Map)["Image_6_Interv"] != null){
          String texto = (eventSnap.snapshot.value as Map)["Image_6_Interv"];
          setState(() {
            image6IntervURL = texto;
            if(image6IntervURL != image6IntervURL_ant){
              image6IntervURL_ant = image6IntervURL;
              fileFromImageUrl(image6IntervURL,"Interv",6);
            }
          });
        }

        if((eventSnap.snapshot.value as Map)["DescImg6Interv"] != null){
          String texto = (eventSnap.snapshot.value as Map)["DescImg6Interv"];
          setState(() {
            photoDescInterv6TEC.text = texto;
          });
        }

        if((eventSnap.snapshot.value as Map)["ObservInterv"] != null){
          String texto = (eventSnap.snapshot.value as Map)["ObservInterv"];
          setState(() {
            observsIntervTEC.text = texto;
          });
        }

        if((eventSnap.snapshot.value as Map)["VoBoInterv"] != null){
          bool select = (eventSnap.snapshot.value as Map)["VoBoInterv"];
          setState(() {
            setState(() {
              VBInterv = select;
            });
          });
        }

        if((eventSnap.snapshot.value as Map)["Sign_Interv"] != null){
          String texto = (eventSnap.snapshot.value as Map)["Sign_Interv"];
          setState(() {
            signIntervURL = texto;
            fileFromSignImageUrl(signIntervURL,"Interv");
          });
        }

        if((eventSnap.snapshot.value as Map)["ClosedInterv"] != null){
          bool select = (eventSnap.snapshot.value as Map)["ClosedInterv"];
          setState(() {
            ClosedInterv = select;
          });
        }else{
          setState(() {
            ClosedInterv = false;
          });
        }

        if((eventSnap.snapshot.value as Map)["FullNameInterv"] != null){
          String texto = (eventSnap.snapshot.value as Map)["FullNameInterv"];
          setState(() {
            fullNameInterv = texto;
          });
        }

      }else
      if(userType == "Interv"){

        if((eventSnap.snapshot.value as Map)["ObservacionGeneral"] != null){
          String texto = (eventSnap.snapshot.value as Map)["ObservacionGeneral"];
          setState(() {
            generalObservTEC.text = texto;
          });
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
            if(image1KapitalURL != image1KapitalURL_ant){
              image1KapitalURL_ant = image1KapitalURL;
              fileFromImageUrl(image1KapitalURL,"Kapital",1);
            }
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
            if(image2KapitalURL != image2KapitalURL_ant){
              image2KapitalURL_ant = image2KapitalURL;
              fileFromImageUrl(image2KapitalURL,"Kapital",2);
            }
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
            if(image3KapitalURL != image3KapitalURL_ant){
              image3KapitalURL_ant = image3KapitalURL;
              fileFromImageUrl(image3KapitalURL,"Kapital",3);
            }
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
            if(image4KapitalURL != image4KapitalURL_ant){
              image4KapitalURL_ant = image4KapitalURL;
              fileFromImageUrl(image4KapitalURL,"Kapital",4);
            }
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
            if(image5KapitalURL != image5KapitalURL_ant){
              image5KapitalURL_ant = image5KapitalURL;
              fileFromImageUrl(image5KapitalURL,"Kapital",5);
            }
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
            if(image6KapitalURL != image6KapitalURL_ant){
              image6KapitalURL_ant = image6KapitalURL;
              fileFromImageUrl(image6KapitalURL,"Kapital",6);
            }
          });
        }

        if((eventSnap.snapshot.value as Map)["DescImg6Kap"] != null){
          String texto = (eventSnap.snapshot.value as Map)["DescImg6Kap"];
          setState(() {
            photoDescKapital6TEC.text = texto;
          });
        }

        if((eventSnap.snapshot.value as Map)["ObservKapital"] != null){
          String texto = (eventSnap.snapshot.value as Map)["ObservKapital"];
          setState(() {
            observsKapitalTEC.text = texto;
          });
        }

        if((eventSnap.snapshot.value as Map)["VoBoKapital"] != null){
          bool select = (eventSnap.snapshot.value as Map)["VoBoKapital"];
          setState(() {
            setState(() {
              VBKapital = select;
            });
          });
        }

        if((eventSnap.snapshot.value as Map)["Sign_Kapital"] != null){
          String texto = (eventSnap.snapshot.value as Map)["Sign_Kapital"];
          setState(() {
            signKapitalURL = texto;
            fileFromSignImageUrl(signKapitalURL,"Kapital");
          });
        }

        if((eventSnap.snapshot.value as Map)["ClosedKapital"] != null){
          bool select = (eventSnap.snapshot.value as Map)["ClosedKapital"];
          setState(() {
            ClosedKapital = select;
          });
        }else{
          setState(() {
            ClosedKapital = false;
          });
        }

        if((eventSnap.snapshot.value as Map)["FullNameKapital"] != null){
          String texto = (eventSnap.snapshot.value as Map)["FullNameKapital"];
          setState(() {
            fullNameKapital = texto;
          });
        }

      }
    });

  }

  void retrieveVitacoraInfo(String selectedDate){

    vitacorasRef
        .child(currentProjectId)
        .child(selectedDate)
        .once()
        .then((eventSnap){

      if(eventSnap.snapshot.value == null){
        return;
      }

      if((eventSnap.snapshot.value as Map)["Image_1_Interv"] != null){
        String texto = (eventSnap.snapshot.value as Map)["Image_1_Interv"];
        setState(() {
          image1IntervURL = texto;
          fileFromImageUrl(image1IntervURL,"Interv",1);
        });
      }

      if((eventSnap.snapshot.value as Map)["DescImg1Interv"] != null){
        String texto = (eventSnap.snapshot.value as Map)["DescImg1Interv"];
        setState(() {
          photoDescInterv1TEC.text = texto;
        });
      }

      if((eventSnap.snapshot.value as Map)["Image_2_Interv"] != null){
        String texto = (eventSnap.snapshot.value as Map)["Image_2_Interv"];
        setState(() {
          image2IntervURL = texto;
          fileFromImageUrl(image2IntervURL,"Interv",2);
        });
      }

      if((eventSnap.snapshot.value as Map)["DescImg2Interv"] != null){
        String texto = (eventSnap.snapshot.value as Map)["DescImg2Interv"];
        setState(() {
          photoDescInterv2TEC.text = texto;
        });
      }

      if((eventSnap.snapshot.value as Map)["Image_3_Interv"] != null){
        String texto = (eventSnap.snapshot.value as Map)["Image_3_Interv"];
        setState(() {
          image3IntervURL = texto;
          fileFromImageUrl(image3IntervURL,"Interv",3);
        });
      }

      if((eventSnap.snapshot.value as Map)["DescImg3Interv"] != null){
        String texto = (eventSnap.snapshot.value as Map)["DescImg3Interv"];
        setState(() {
          photoDescInterv3TEC.text = texto;
        });
      }

      if((eventSnap.snapshot.value as Map)["Image_4_Interv"] != null){
        String texto = (eventSnap.snapshot.value as Map)["Image_4_Interv"];
        setState(() {
          image4IntervURL = texto;
          fileFromImageUrl(image4IntervURL,"Interv",4);
        });
      }

      if((eventSnap.snapshot.value as Map)["DescImg4Interv"] != null){
        String texto = (eventSnap.snapshot.value as Map)["DescImg4Interv"];
        setState(() {
          photoDescInterv4TEC.text = texto;
        });
      }

      if((eventSnap.snapshot.value as Map)["Image_5_Interv"] != null){
        String texto = (eventSnap.snapshot.value as Map)["Image_5_Interv"];
        setState(() {
          image5IntervURL = texto;
          fileFromImageUrl(image5IntervURL,"Interv",5);
        });
      }

      if((eventSnap.snapshot.value as Map)["DescImg5Interv"] != null){
        String texto = (eventSnap.snapshot.value as Map)["DescImg5Interv"];
        setState(() {
          photoDescInterv5TEC.text = texto;
        });
      }

      if((eventSnap.snapshot.value as Map)["Image_6_Interv"] != null){
        String texto = (eventSnap.snapshot.value as Map)["Image_6_Interv"];
        setState(() {
          image6IntervURL = texto;
          fileFromImageUrl(image6IntervURL,"Interv",6);
        });
      }

      if((eventSnap.snapshot.value as Map)["DescImg6Interv"] != null){
        String texto = (eventSnap.snapshot.value as Map)["DescImg6Interv"];
        setState(() {
          photoDescInterv6TEC.text = texto;
        });
      }

      if((eventSnap.snapshot.value as Map)["ObservInterv"] != null){
        String texto = (eventSnap.snapshot.value as Map)["ObservInterv"];
        setState(() {
          observsIntervTEC.text = texto;
        });
      }

      if((eventSnap.snapshot.value as Map)["VoBoInterv"] != null){
        bool select = (eventSnap.snapshot.value as Map)["VoBoInterv"];
        setState(() {
          setState(() {
            VBInterv = select;
          });
        });
      }

      if((eventSnap.snapshot.value as Map)["Sign_Interv"] != null){
        String texto = (eventSnap.snapshot.value as Map)["Sign_Interv"];
        setState(() {
          signIntervURL = texto;
          fileFromSignImageUrl(signIntervURL,"Interv");
        });
      }

      if((eventSnap.snapshot.value as Map)["ClosedInterv"] != null){
        bool select = (eventSnap.snapshot.value as Map)["ClosedInterv"];
        setState(() {
          ClosedInterv = select;
        });
      }else{
        setState(() {
          ClosedInterv = false;
        });
      }

      if((eventSnap.snapshot.value as Map)["FullNameInterv"] != null){
        String texto = (eventSnap.snapshot.value as Map)["FullNameInterv"];
        setState(() {
          fullNameInterv = texto;
        });
      }

      if((eventSnap.snapshot.value as Map)["ObservacionGeneral"] != null){
        String texto = (eventSnap.snapshot.value as Map)["ObservacionGeneral"];
        setState(() {
          generalObservTEC.text = texto;
        });
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

      if((eventSnap.snapshot.value as Map)["ObservKapital"] != null){
        String texto = (eventSnap.snapshot.value as Map)["ObservKapital"];
        setState(() {
          observsKapitalTEC.text = texto;
        });
      }

      if((eventSnap.snapshot.value as Map)["VoBoKapital"] != null){
        bool select = (eventSnap.snapshot.value as Map)["VoBoKapital"];
        setState(() {
          setState(() {
            VBKapital = select;
          });
        });
      }

      if((eventSnap.snapshot.value as Map)["Sign_Kapital"] != null){
        String texto = (eventSnap.snapshot.value as Map)["Sign_Kapital"];
        setState(() {
          signKapitalURL = texto;
          fileFromSignImageUrl(signKapitalURL,"Kapital");
        });
      }

      if((eventSnap.snapshot.value as Map)["ClosedKapital"] != null){
        bool select = (eventSnap.snapshot.value as Map)["ClosedKapital"];
        setState(() {
          ClosedKapital = select;
        });
      }else{
        setState(() {
          ClosedKapital = false;
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

    Directory folderDir = Directory("${appDirectory!.path}/Vitacoras/Fotos/${selectedDate}");

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
        image3KapStream = newImageFile.readAsBytesSync();
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
      else
      if(taker != "Kapital" && imageNumber==1){
        takenImageInterv1 = null;
        takenImageInterv1 = newImageFile;
        image1IntervStream = newImageFile.readAsBytesSync();
      }else
      if(taker != "Kapital" && imageNumber==2){
        takenImageInterv2 = null;
        takenImageInterv2 = newImageFile;
        image2IntervStream = newImageFile.readAsBytesSync();
      }else
      if(taker != "Kapital" && imageNumber==3){
        takenImageInterv3 = null;
        takenImageInterv3 = newImageFile;
        image3IntervStream = newImageFile.readAsBytesSync();
      }else
      if(taker != "Kapital" && imageNumber==4){
        takenImageInterv4 = null;
        takenImageInterv4 = newImageFile;
        image4IntervStream = newImageFile.readAsBytesSync();
      }else
      if(taker != "Kapital" && imageNumber==5){
        takenImageInterv5 = null;
        takenImageInterv5 = newImageFile;
        image5IntervStream = newImageFile.readAsBytesSync();
      }else
      if(taker != "Kapital" && imageNumber==6){
        takenImageInterv6 = null;
        takenImageInterv6 = newImageFile;
        image6IntervStream = newImageFile.readAsBytesSync();
      }
    });

  }

  Future<bool> uploadImageToServer(String newFilename, File newImageFile, int imageNumber) async{

    final Reference refStorage = vitacoraPhotosRef.child("Fotos").child(selectedDate).child(newFilename);

    final UploadTask uploadTask = refStorage.putFile(newImageFile);

    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => true);

    if(taskSnapshot.state == TaskState.success){
      final String url = await taskSnapshot.ref.getDownloadURL();

      vitacorasRef
          .child(currentProjectId)
          .child(selectedDate)
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

      /*
      var appDirectory = await getDownloadsDirectory();

      Directory folderDir = Directory("${appDirectory!.path}/Vitacoras/Fotos/${selectedDate}");

      String imageName = "${taker}_${selectedDate}_${imageNumber.toString()}.jpg";

      if(await folderDir.exists() == false){
        await folderDir.create(recursive: true);
      }

      final file = File("${folderDir.path}/${imageName}");

      file.writeAsBytesSync(response.bodyBytes);
      */

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
        else
        if(taker != "Kapital" && imageNumber==1){
          takenImageInterv1 = null;
          image1IntervStream = response.bodyBytes;
        }else
        if(taker != "Kapital" && imageNumber==2){
          takenImageInterv2 = null;
          image2IntervStream = response.bodyBytes;
        }else
        if(taker != "Kapital" && imageNumber==3){
          takenImageInterv3 = null;
          image3IntervStream = response.bodyBytes;
        }else
        if(taker != "Kapital" && imageNumber==4){
          takenImageInterv4 = null;
          image4IntervStream = response.bodyBytes;
        }else
        if(taker != "Kapital" && imageNumber==5){
          takenImageInterv5 = null;
          image5IntervStream = response.bodyBytes;
        }else
        if(taker != "Kapital" && imageNumber==6){
          takenImageInterv6 = null;
          image6IntervStream = response.bodyBytes;
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
        }else
        if(taker != "Kapital"){
          signIntervStream = response.bodyBytes;
        }
      });

    }

  }


  void cleanForm() {

    setState(() {
      generalObservTEC = TextEditingController();

      photoDescKapital1TEC = TextEditingController();
      photoDescKapital2TEC = TextEditingController();
      photoDescKapital3TEC = TextEditingController();
      photoDescKapital4TEC = TextEditingController();
      photoDescKapital5TEC = TextEditingController();
      photoDescKapital6TEC = TextEditingController();

      photoDescInterv1TEC = TextEditingController();
      photoDescInterv2TEC = TextEditingController();
      photoDescInterv3TEC = TextEditingController();
      photoDescInterv4TEC = TextEditingController();
      photoDescInterv5TEC = TextEditingController();
      photoDescInterv6TEC = TextEditingController();

      observsKapitalTEC = TextEditingController();
      observsIntervTEC = TextEditingController();

      takenImageKap1 = null;
      takenImageKap2 = null;
      takenImageKap3 = null;
      takenImageKap4 = null;
      takenImageKap5 = null;
      takenImageKap6 = null;

      takenImageInterv1 = null;
      takenImageInterv2 = null;
      takenImageInterv3 = null;
      takenImageInterv4 = null;
      takenImageInterv5 = null;
      takenImageInterv6 = null;

      image1KapStream = null;
      image2KapStream = null;
      image3KapStream = null;
      image4KapStream = null;
      image5KapStream = null;
      image6KapStream = null;

      image1IntervStream = null;
      image2IntervStream = null;
      image3IntervStream = null;
      image4IntervStream = null;
      image5IntervStream = null;
      image6IntervStream = null;

      image1KapitalURL = "";
      image2KapitalURL = "";
      image3KapitalURL = "";
      image4KapitalURL = "";
      image5KapitalURL = "";
      image6KapitalURL = "";

      image1IntervURL = "";
      image2IntervURL = "";
      image3IntervURL = "";
      image4IntervURL = "";
      image5IntervURL = "";
      image6IntervURL = "";

      signKapitalURL = "";
      signIntervURL = "";

      VBKapital = false;
      VBInterv = false;

      imageBytesSignKapital = null;
      imageBytesSignInterv = null;

      bitacoraActModel = BitacoraActModel();

      Provider.of<AppData>(context, listen: false).cleanSignature();
    });

  }
}
